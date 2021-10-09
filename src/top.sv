`include "stage_IF.sv"
`include "stage_ID.sv"
`include "stage_EX.sv"
`include "stage_MEM_and_MEM.sv"
`include "forward_unit.sv"
`include "hazard_unit.sv"
`include "SRAM_wrapper.sv"

// instrution
`define OP6to2      instr[6:2]
`define FUNCT3      instr[14:12]
`define FUNCT3_2    instr[14]
`define RDIDX       instr[11:7]
`define RS1IDX      instr[19:15]
`define RS2IDX      instr[24:20]
`define FUNCT7      instr[31:25]
`define FUNCT7_5    instr[30]

//imm
`define ImmI        {{21{instr[31]}}, instr[30:20]}
`define ImmST       {{21{instr[31]}}, instr[30:25], instr[11:7]}
`define ImmB        {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}
`define ImmU        {instr[31:12], 12'b0}
`define ImmJ        {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}

// opcode
// R-Type
`define RtypeOP   5'b01100 
// I-Type
`define ItypeOP   5'b00100 
`define LD        5'b00000   // [rs1 + imm] -> rd
`define JALR      5'b11001   // pc + 4 -> rd, rs1 + imm -> PC */
// S-Type
`define ST        5'b01000   // rs2 -> [rs1 + Imm]
// B-Type
`define BRA       5'b11000
// U-Type
`define AUIPC     5'b00101   // pc + imm -> rd 
`define LUI       5'b01101   // imm -> rd
// J-Type
`define JAL       5'b11011   // pc + 4 -> rd, pc + imm -> pc

// alu op
`define ADD     4'b0000
`define SUB     4'b1000
`define SLL     4'b0001
`define SLT     4'b0010
`define SLTU    4'b0011
`define XOR     4'b0100
`define SRL     4'b0101
`define SRA     4'b1101
`define OR      4'b0110
`define AND     4'b0111
`define NOP     4'b1111

`define SL      3'b001
`define SR      3'b101

//branch op
`define BEQ     3'b000
`define BNE     3'b001
`define BLT     3'b100
`define BGE     3'b101
`define BLTU    3'b110
`define BGEU    3'b111

`define NOBRA     2'b00
`define BrCond    2'b01
`define BrUcond   2'b10

`define BEQ2    2'b00
`define BLT2    2'b10
`define BLTU2   2'b11

// load store op
`define LB      3'b000
`define LH      3'b001
`define LW      3'b010
`define LBU     3'b100
`define LHU     3'b101

`define MemByte      2'b00
`define MemHalf      2'b01
`define MemWord      2'b10

`define AddrLast2     alu_res[1:0]

//other
`define OP1FromRS1    1'b0
`define OP1FromPC     1'b1
`define OP2FromRS2    1'b0
`define OP2FromIMM    1'b1
`define RdFromALU     1'b0
`define RdFromPC4     1'b1

`define RSFromID           2'd0
`define RSFwFromEX         2'd1
`define RSFwFromMEM        2'd2

module top (
    input clk,
    input rst
);

logic         br_take, stall_IF, flush_ID;
logic         op1_ctrl, op2_ctrl, rd_src_toEX, mem_wr_toEX, mem_rd_toEX;
logic [1:0]   br_op, 
logic [2:0]   funct3_toEX
logic [3:0]   alu_op,
logic [4:0]   rd_idx_toEX,
logic [13:0]  instr_addr, alu_res_EX;
logic [31:0]  instr_out, pc_toID, pc4_toID;
logic [31:0]  wb_data, imm, rs1_toEX, rs2_toEX, pc_toEX, pc4_toEX;

forward_unit FW(
  .clk(clk), 
  .flush_ID(flush_ID),
  input [4:0]         rs1_idx_ID, rs2_idx_ID, rd_idx_EX, rd_idx_MEM,
  output logic [1:0]  rs1_ctrl, rs2_ctrl  
  );

stage_EX EX(
  .clk(clk), 
  .rst(rst), 
  .mem_wr_fromID(mem_wr_toEX), 
  .mem_rd_fromID(mem_rd_toEX), 
  .op1_ctrl(op1_ctrl), 
  .op2_ctrl(op2_ctrl), 
  .rd_src_fromID(rd_src_toEX),
  input [1:0]     
  .rs1_ctrl(), 
  .rs2_ctrl(),
  input [2:0]     funct3_fromID
  input [4:0]     rd_idx_fromID,
  input [31:0]    pc_fromID, imm_fromID, pc4_fromID,
  input [31:0]    rs1_fromID, rs1_fromEX, rs1_fromMEM, rs2_fromID, rs2_fromEX, rs2_fromMEM,
  output logic    br_take, rd_src_toMEM, mem_rd,
  output logic [1:0]    wr_mem_en,
  output logic [2:0]    funct3_toMEM,
  output logic [4:0]    rd_idx_toMEM,
  output logic [13:0]   mem_addr,
  output logic [31:0]   alu_res_EX ,alu_res_toMEM, pc4_toMEM
  );

stage_ID ID(
  .clk(clk), 
  .rst(rst), 
  .flush_ID(flush_ID),
  .instr(instr_out), 
  .pc_fromIF(pc_toID), 
  .pc4_fromIF(pc4_toID), 
  .wb_data(wb_data),  
  .op1_ctrl(op1_ctrl), 
  .op2_ctrl(op2_ctrl), 
  .rd_src_toEX(rd_src_toEX),
  .mem_wr_toEX(mem_wr_toEX), 
  .mem_rd_toEX(mem_rd_toEX),
  .br_op(br_op),
  .funct3_toEX(funct3_toEX),
  .alu_op(alu_op),
  .rd_idx_toEX(rd_idx_toEX), 
  .imm(imm), 
  .rs1_toEX(rs1_toEX), 
  .rs2_toEX(rs2_toEX), 
  .pc_toEX(pc_toEX), 
  .pc4_toEX(pc4_toEX)
);

SRAM_wrapper IMem(
  .CK(clk),
  .CS(1'b1),
  .OE(1'b1),
  .WEB(4'd0),
  .A(instr_addr),
  .DI(32'd0),
  .DO(instr_out)
);

stage_IF IF(
  .clk(clk),
  .rst(rst),
  .instr_from_mem(instr_out),
  .alu_res(alu_res_EX),
  .br_take(br_take),
  .stall_IF(stall_IF),
  .instr_addr(instr_addr), 
  .pc_toID(pc_toID), 
  .pc4_toID(pc4_toID)
);


