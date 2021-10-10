`include "../include/all_def.svh"

module stage_ID (
  input   clk, rst, flush_ID,
  input   [31:0]  instr, pc_fromIF, pc4_fromIF, wb_data,  
  output logic        op1_ctrl, op2_ctrl, rd_src_fromID, mem_wr_fromID, mem_rd_fromIF, mem_rd_fromID,
  output logic [1:0]  br_op,
  output logic [2:0]  funct3_fromID,
  output logic [3:0]  alu_op,
  output logic [4:0]  rs1_idx_fromIF, rs2_idx_fromIF, rs1_idx_fromID, rs2_idx_fromID, rd_idx_fromID, 
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
  if (rst || flush_ID) begin
    alu_op <= `NOP;
  end
  else begin
    case(`OP6to2)
      `RtypeOP, `ItypeOP: 
        alu_op <= {`FUNCT7_5, `FUNCT3};
      `LD, `JALR, `ST, `BRA, `AUIPC, `LUI, `JAL:
        alu_op <= `ADD;
      default:
        alu_op <= `NOP;
    endcase
  end
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

always_comb begin
  if (`OP6to2 == `LD) 
    mem_rd_fromIF <= 1;
  else
    mem_rd_fromIF <= 0;
end

always_ff @(posedge clk) begin
  if(rst || flush_ID)
    mem_rd_fromID <= 0;
  else
    mem_rd_fromID <= mem_rd_fromIF;
end

// memory read and write ctrl
always_ff @(posedge clk) begin
  if(rst || flush_ID)
    mem_rd_fromID <= 0;
  else if (`OP6to2 == `LD) 
    mem_rd_fromID <= 1;
  else
    mem_rd_fromID <= 0;

  if(rst || flush_ID)
    mem_wr_fromID <= 0;
  else if (`OP6to2 == `ST) begin
    mem_wr_fromID <= 1;
  else
    mem_wr_fromID <= 0;
end

// rd index
always_ff @(posedge clk) begin
  if (rst || flush_ID) begin
    rd_idx_fromID <= 0;
  end
  else begin
    if (`OP6to2 == `ST || `OP6to2 == `BRA)
      rd_idx_fromID <= 0;
    else
      rd_idx_fromID <= `RDIDX;
  end
end

always_ff @(posedge clk) begin
  case(`OP6to2)
    `JAL, `JALR:
      rd_src_fromID <= `RdFromPC4;
    default: 
      rd_src_fromID <= `RdFromALU;
end

// deal LUI
always_comb begin
  if(`OP6to2 == `LUI)
    rs1_idx_fromIF = 5'd0;
  else
    rs1_idx_fromIF = `RS1IDX;
end

// write regfile
always_ff @(posedge clk) begin
  if (rst) begin
    for (int i = 0; i < 32; i = i + 1) begin
      regfile[i] <= 0;
    end
  end
  // write back
  else if (rd_idx_fromWB > 0) begin
    regfile[rd_idx_fromWB] <= wb_data;
  end
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