`include "../include/all_def.svh"

module stage_ID (
  input   clk, rst, hazard,
  input   [4:0]   wb_idx,
  input   [31:0]  instr, pc_fromIF, pc4_fromIF, wb_data,  
  output logic        op1_ctrl, op2_ctrl, rd_src_fromID, mem_wr_fromID, mem_rd_fromID,
  output logic [1:0]  br_op,
  output logic [2:0]  funct3_fromID,
  output logic [3:0]  alu_op,
  output logic [4:0]  rs1_idx_fromIF, rs2_idx_fromIF,
  output logic [4:0]  rd_idx_fromID,
  output logic [31:0] imm, rs1_fromID, rs2_fromID, pc_fromID, pc4_fromID
);

logic [31:0]  regfile [31:0];
logic         mem_rd_fromID_comb, mem_wr_fromID_comb;
logic [1:0]   br_op_comb;
logic [3:0]   alu_op_comb;
logic [4:0]   rd_idx_fromIF;
logic [31:0]  imm_comb;

// ALU op
always_comb begin
  case(`OP6to2)
    `RtypeOP: 
      alu_op_comb = {`FUNCT7_5, `FUNCT3};
    `ItypeOP: 
      alu_op_comb = (`FUNCT3 == `SR) ? {`FUNCT7_5, `FUNCT3} : {1'b0, `FUNCT3};
    `LD, `JALR, `ST, `BRA, `AUIPC, `LUI, `JAL:
      alu_op_comb = `ADD;
    default:
      alu_op_comb = `NOP;
  endcase
end

// deal immediate
always_comb begin
  case(`OP6to2)
    `ItypeOP, `LD, `JALR: 
      imm_comb = `ImmI;
    `ST:
      imm_comb = `ImmST;
    `BRA:
      imm_comb = `ImmB;
    `AUIPC, `LUI:
      imm_comb = `ImmU;
    `JAL:
      imm_comb = `ImmJ;
    default:
      imm_comb = 32'd0;
  endcase
end

// branch type op
always_comb begin
  case(`OP6to2)
    `BRA: 
      br_op_comb = `BrCond;
    `JAL, `JALR:
      br_op_comb = `BrUcond;
    default: 
      br_op_comb = `NOBRA;
  endcase
end

always_comb begin
  if (`OP6to2 == `ST || `OP6to2 == `BRA)
    rd_idx_fromIF = 5'd0;
  else
    rd_idx_fromIF = `RDIDX;
end

// deal LUI
always_comb begin
  if(`OP6to2 == `LUI)
    rs1_idx_fromIF = 5'd0;
  else
    rs1_idx_fromIF = `RS1IDX;
end

assign rs2_idx_fromIF = `RS2IDX;

// op 1 op2 source ctrl
always_ff @(posedge clk) begin
  case(`OP6to2)
    `BRA, `AUIPC, `JAL: 
      op1_ctrl <= `OP1FromPC;
    default: 
      op1_ctrl <= `OP1FromRS1;
  endcase

  if (`OP6to2 == `RtypeOP)
    op2_ctrl <= `OP2FromRS2;
  else
    op2_ctrl <= `OP2FromIMM;
end

// rd index
always_ff @(posedge clk) begin
  case(`OP6to2)
    `JAL, `JALR:
      rd_src_fromID <= `RdFromPC4;
    default: 
      rd_src_fromID <= `RdFromALU;
  endcase
end

// memory read and write ctrl
always_comb begin
  if (`OP6to2 == `LD) 
    mem_rd_fromID_comb = 1'b1;
  else
    mem_rd_fromID_comb = 1'b0;

  if (`OP6to2 == `ST) 
    mem_wr_fromID_comb = 1'b1;
  else
    mem_wr_fromID_comb = 1'b0;
end

// write regfile
always_ff @(posedge clk) begin
  if (rst)
    regfile[0] <= 32'd0;
  // write back
  else if (wb_idx > 5'd0)
    regfile[wb_idx] <= wb_data;
end

always_ff @(posedge clk) begin 
  funct3_fromID <= `FUNCT3;
end

// PC
always_ff @(posedge clk) begin
  if (rst || hazard) begin
    pc_fromID <= 32'd0;
    pc4_fromID <= 32'd0;
    mem_rd_fromID <= 1'b0;
    mem_wr_fromID <= 1'b0;
    rd_idx_fromID <= 5'd0;
    alu_op <= `NOP;
    br_op <= `NOBRA;
    imm <= 32'd0;
    rs1_fromID <= 32'd0;
    rs2_fromID <= 32'd0;
  end
  else begin
    pc_fromID <= pc_fromIF;
    pc4_fromID <= pc4_fromIF;
    mem_rd_fromID <= mem_rd_fromID_comb;
    mem_wr_fromID <= mem_wr_fromID_comb;
    rd_idx_fromID <= rd_idx_fromIF;
    alu_op <= alu_op_comb;
    br_op <= br_op_comb;
    imm <= imm_comb;
    rs1_fromID <= regfile[rs1_idx_fromIF];
    rs2_fromID <= regfile[rs2_idx_fromIF];
  end
end

endmodule 