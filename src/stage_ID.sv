// instrution
`define OP6to2      instr[6:2]
`define FUNCT3      inst[14:12]
`define FUNCT3_2    inst[14]
`define RDIDX       inst[11:7]
`define RS1IDX      inst[19:15]
`define RS2IDX      inst[24:20]
`define FUNCT7      inst[31:25]
`define FUNCT7_5    inst[30]
`define ImmI        {{21{inst[31]}}, inst[30:20]}
`define ImmST       {{21{inst[31]}}, inst[30:25], inst[11:7]}
`define ImmB        {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}
`define ImmU        {inst[31:12], 12'b0}
`define ImmJ        {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0}
`define ImmShamt    {27'd0, inst[24:20]}

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

// alu_op
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

//br_op
`define BEQ     3'b000
`define BNE     3'b001
`define BLT     3'b100
`define BGE     3'b101
`define BLTU    3'b110
`define BGEU    3'b111
`define UNCOND  3'b010
`define NOBRA   3'b011

//other
`define OP1FromRS1    0
`define OP1FromPC     1

`define OP2FromRS2    0
`define OP2FromIMM    1

`define WbRd          0
`define WbPC          1

// `define MemS          0
// `define MemUS         1
// `define MemByte       0
// `define MemHalf       1
// `define MemWord       2

`define EXFromID            0
`define EXFwFromMEM         1
`define EXFwFromWB          2

module stage_ID (
  input   clk, rst,
  input   stall
  input   [31:0]  instr, IFID_pc,
  output logic [3:0]  alu_op,
  output logic [31:0] imm, rs1, rs2,
);

logic [31:0] ID_instr, ID_pc;

assign wire funct3_toEX = `FUNCT3;

// deal immediate
always_ff @(posedge clk) begin
  case(`OP6to2)
    `ItypeOP:
      if(`FUNCT3 == `SR or `FUNCT3 == `SL)
        imm <= `ImmShamt;
      else
        imm <= `ImmI;
    `LD, `JALR: 
      imm <= `ImmI;
    `ST:
      imm <= `ImmST;
    `BRA:
      imm <= `ImmB;
    `AUIPC, `LUI:
      imm <= `ImmU;
    `JAL:
      imm <= `ImmJ;
    default:
      imm <= 32'd0;
  endcase
end

// ALU op
always_ff @(posedge clk) begin
    if (rst || clear) begin
        alu_op <= `NOP;
    end
    else begin
      case(`OP6to2)
        `RtypeOP, `ItypeOP: 
          alu_op <= {`FUNCT7_5, `FUNCT3};
        `LD, `JALR, `ST, `BEU, `AUIPC, `LUI, `JAL:
          alu_op <= `ADD;
        default:
          alu_op <= `NOP;
      endcase
    end
end

// branch type op ?
always_ff @(posedge clk) begin
    if (rst || clear) begin
        br_en <= 0;
    end
    else begin
      case(`OP6to2)
        `BRA, `JAL, `JALR:
          br_en <= 1;
        default: 
          br_en <= 0;
      endcase
    end
end

// op 1 op2 source ctrl
always_ff @(posedge clk) begin
  if (`OP6to2 == `BEU || `OP6to2 == `AUIPC || `OP6to2 == `JAL)
    op1_ctrl <= `OP1FromPC;
  else
    op1_ctrl <= `OP1FromRS1;

  if (`OP6to2 == `RtypeOP)
    op2_ctrl <= `OP2FromRS2;
  else
    op2_ctrl <= `OP2FromIMM;
end

// memory read
always_ff @(posedge clk) begin
  if (`OP6to2 == `LD) begin
    mem_rd_toEX <= 1;
  else
    mem_rd_toEX <= 0;
end

// memory write
always_ff @(posedge clk) begin
  if (`OP6to2 == `ST) begin
    mem_wr_toEX <= 1;
  else
    mem_wr_toEX <= 0;
end

// rd index
always_ff @(posedge clk) begin
  if (rst || clear) begin
    rd_idx_toEX <= 0;
  end
  else begin
    if (`OPCODE32 == `ST || `OPCODE32 == `BEU)
      rd_idx_toEX <= 0;
    else
      rd_idx_toEX <= `RDIDX;
  end
end

always_comb begin
  if(`OP6to2 == `LUI)
    rs1_idx = 5'd0;
  else
    rs1_idx = `RS1IDX;
end

always_ff @(posedge clk) begin
  if (rst) begin
    for (int j = 1; j < 32; j = j + 1) begin
      regfile[j] <= 0;
    end
  end
  // write back
  else if (rdIdxFromWB > 0) begin
    RF[rdIdxFromWB] <= WBDataFromWB;
  end
end

// read regfile
always_comb begin
  rs1 = regfile[rs1_idx];
  rs2 = regfile[rs2_idx];
end

// PC
always_ff @(posedge clk) begin
  if (rst || clear) begin
    pc_toEX <= 32'h0;
    pc4_toEX <= 32'h0;
  end
  else begin
    pc_toEX <= pc_fromIF;
    pc4_toEX <= pc4_fromIF;
  end
end

endmodule 