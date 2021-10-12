`include "../include/all_def.svh"

module stage_ID (
  input   clk, rst, flush_ID,
  input   [4:0]   wb_idx,
  input   [31:0]  instr, pc_fromIF, pc4_fromIF, wb_data,  
  output logic        op1_ctrl, op2_ctrl, rd_src_fromID, mem_wr_fromID, mem_rd_fromID,
  output logic [1:0]  br_op,
  output logic [2:0]  funct3_fromID,
  output logic [3:0]  alu_op,
  output logic [4:0]  rs1_idx_fromIF, rs2_idx_fromIF, rs1_idx_fromID,
  output logic [4:0]  rs2_idx_fromID, rd_idx_fromID,
  output logic [31:0] imm, rs1_fromID, rs2_fromID, pc_fromID, pc4_fromID
);

logic [31:0]  regfile [31:0];

// deal immediate
always_ff @(posedge clk) begin
  case(`OP6to2)
    `ItypeOP, `LD, `JALR: 
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
  if (rst || flush_ID)
    alu_op <= `NOP;
  else
    case(`OP6to2)
      `RtypeOP: 
        alu_op <= {`FUNCT7_5, `FUNCT3};
      `ItypeOP: 
        alu_op <= (`FUNCT3 == `SR) ? {`FUNCT7_5, `FUNCT3} : {1'b0, `FUNCT3};
      `LD, `JALR, `ST, `BRA, `AUIPC, `LUI, `JAL:
        alu_op <= `ADD;
      default:
        alu_op <= `NOP;
    endcase
end

// branch type op
always_ff @(posedge clk) begin
  if (rst || flush_ID)
    br_op <= `NOBRA;
  else 
    case(`OP6to2)
      `BRA: 
        br_op <= `BrCond;
      `JAL, `JALR:
        br_op <= `BrUcond;
      default: 
        br_op <= `NOBRA;
    endcase
end

// op 1 op2 source ctrl
always_ff @(posedge clk) begin
  if (`OP6to2 == `BRA || `OP6to2 == `AUIPC || `OP6to2 == `JAL)
    op1_ctrl <= `OP1FromPC;
  else
    op1_ctrl <= `OP1FromRS1;

  if (`OP6to2 == `RtypeOP)
    op2_ctrl <= `OP2FromRS2;
  else
    op2_ctrl <= `OP2FromIMM;
end

always_ff @(posedge clk) begin
  if(rst || flush_ID)
    mem_rd_fromID <= 1'b0;
  else
    if (`OP6to2 == `LD) 
      mem_rd_fromID <= 1'b1;
    else
      mem_rd_fromID <= 1'b0;
end

// memory read and write ctrl
always_ff @(posedge clk) begin
  if(rst || flush_ID)
    mem_wr_fromID <= 1'b0;
  else if (`OP6to2 == `ST) 
    mem_wr_fromID <= 1'b1;
  else
    mem_wr_fromID <= 1'b0;
end

// rd index
always_ff @(posedge clk) begin
  if (rst || flush_ID)
    rd_idx_fromID <= 5'd0;
  else
    if (`OP6to2 == `ST || `OP6to2 == `BRA)
      rd_idx_fromID <= 5'd0;
    else
      rd_idx_fromID <= `RDIDX;
end

always_ff @(posedge clk) begin
  case(`OP6to2)
    `JAL, `JALR:
      rd_src_fromID <= `RdFromPC4;
    default: 
      rd_src_fromID <= `RdFromALU;
  endcase
end

// deal LUI
always_comb begin
  if(`OP6to2 == `LUI)
    rs1_idx_fromIF = 5'd0;
  else
    rs1_idx_fromIF = `RS1IDX;
end

assign rs2_idx_fromIF = `RS2IDX;

// write regfile
always_ff @(posedge clk) begin
  if (rst)
    regfile[0] <= 32'd0;
  // write back
  else if (wb_idx > 5'd0)
    regfile[wb_idx] <= wb_data;
end

// read regfile
always_ff @(posedge clk) begin
  rs1_fromID <= regfile[rs1_idx_fromIF];
  rs2_fromID <= regfile[rs2_idx_fromIF];
end

// rs1 rs2 idx register
always_ff @(posedge clk) begin
  if (rst || flush_ID) begin
    rs1_idx_fromID <= 5'd0;
    rs2_idx_fromID <= 5'd0;
  end
  else begin
    rs1_idx_fromID <= rs1_idx_fromIF;
    rs2_idx_fromID <= rs2_idx_fromIF;
  end
end

always_ff @(posedge clk) begin 
  funct3_fromID <= `FUNCT3;
end

// PC
always_ff @(posedge clk) begin
  if (rst || flush_ID) begin
    pc_fromID <= 32'd0;
    pc4_fromID <= 32'd0;
  end
  else begin
    pc_fromID <= pc_fromIF;
    pc4_fromID <= pc4_fromIF;
  end
end

endmodule 