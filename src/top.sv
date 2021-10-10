`include "stage_IF.sv"
`include "stage_ID.sv"
`include "stage_EX.sv"
`include "stage_MEM_and_MEM.sv"
`include "forward_unit.sv"
`include "hazard_unit.sv"
`include "SRAM_wrapper.sv"

module top (
    input clk,
    input rst
);

logic         br_take, stall_IF, flush_ID, rd_src_fromEX, mem_rd_fromEX;
logic         op1_ctrl, op2_ctrl, rd_src_fromID, mem_wr_fromID, mem_rd_fromIF, mem_rd_fromID;
logic [1:0]   br_op, rs1_ctrl, rs2_ctrl, wr_mem_en
logic [2:0]   funct3_fromID, funct3_fromEX
logic [3:0]   alu_op;
logic [4:0]   rs1_idx_fromIF, rs2_idx_fromIF, rs1_idx_fromID, rs2_idx_fromID;
logic [4:0]   rd_idx_fromID, rd_idx_fromEX, rd_idx_fromMEM;
logic [13:0]  instr_addr, data_addr; 
logic [31:0]  instr_out, data_out, pc_fromIF, pc4_fromIF;
logic [31:0]  wb_data, imm, rs1_fromID, rs2_fromID, pc_fromID, pc4_fromID;
logic [31:0]  alu_res, rd_fromEX, rd_fromMEM;

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
  .alu_res(alu_res),
  .br_take(br_take),
  .stall_IF(stall_IF),
  .instr_addr(instr_addr), 
  .pc_fromIF(pc_fromIF), 
  .pc4_fromIF(pc4_fromIF)
);

stage_ID ID(
  .clk(clk), 
  .rst(rst), 
  .flush_ID(flush_ID),
  .instr(instr_out), 
  .pc_fromIF(pc_fromIF), 
  .pc4_fromIF(pc4_fromIF), 
  .wb_data(wb_data),  
  .op1_ctrl(op1_ctrl), 
  .op2_ctrl(op2_ctrl), 
  .rd_src_fromID(rd_src_fromID),
  .mem_wr_fromID(mem_wr_fromID), 
  .mem_rd_fromIF(mem_rd_fromIF),
  .mem_rd_fromID(mem_rd_fromID),
  .br_op(br_op),
  .funct3_fromID(funct3_fromID),
  .alu_op(alu_op),
  .rs1_idx_fromIF(rs1_idx_fromIF), 
  .rs2_idx_fromIF(rs2_idx_fromIF),
  .rs1_idx_fromID(rs1_idx_fromID),
  .rs2_idx_fromID(rs2_idx_fromID),
  .rd_idx_fromID(rd_idx_fromID), 
  .imm(imm), 
  .rs1_fromID(rs1_fromID), 
  .rs2_fromID(rs2_fromID), 
  .pc_fromID(pc_fromID), 
  .pc4_fromID(pc4_fromID)
);

stage_EX EX(
  .clk(clk), 
  .rst(rst), 
  .mem_wr_fromID(mem_wr_fromID), 
  .mem_rd_fromID(mem_rd_fromID), 
  .op1_ctrl(op1_ctrl), 
  .op2_ctrl(op2_ctrl), 
  .rd_src_fromID(rd_src_fromID),    
  .rs1_ctrl(rs1_ctrl), 
  .rs2_ctrl(rs2_ctrl),
  .funct3_fromID(funct3_fromID),
  .rd_idx_fromID(rd_idx_fromID),
  .imm(imm), 
  .pc_fromID(pc_fromID), 
  .pc4_fromID(pc4_fromID),
  .rs1_fromID(rs1_fromID), 
  .rs1_fw_fromEX(rd_fromEX), 
  .rs1_fw_fromMEM(rd_fromMEM), 
  .rs2_fromID(rs2_fromID), 
  .rs2_fw_fromEX(rd_fromEX), 
  .rs2_fw_fromMEM(rd_fromMEM),
  .br_take(br_take), 
  .rd_src_fromEX(rd_src_fromEX), 
  .mem_rd(mem_rd_fromEX),
  .wr_mem_en(wr_mem_en),
  .funct3_fromEX(funct3_fromEX),
  .rd_idx_fromEX(rd_idx_fromEX),
  .mem_addr(rs2_fromID),
  .rd_fromEX(rd_fromEX),
  .pc4_fromEX(pc4_fromEX)
  );

SRAM_wrapper DMem(
    .CK(clk),
    .CS(1'b1),
    .OE(mem_rd_fromID),
    .WEB(wr_mem_en),
    .A(data_addr),
    .DI(rs2_fromID),
    .DO(data_out)
);

stage_MEM_and_WB MEMandWB(
  .clk(clk), 
  .mem_rd_fromEX(mem_rd_fromEX), 
  .rd_src_fromEX(rd_src_fromEX),
  .funct3_fromEX(funct3_fromEX),
  .rd_idx_fromEX(rd_idx_fromEX),
  .rd_fromEX(rd_fromEX), 
  .mem_read_out(data_out),
  .rd_idx_fromMEM(rd_idx_fromMEM),
  .wb_data(wb_data), 
  .rd_fromMEM(rd_fromMEM)
);

forward_unit FW(
  .clk(clk), 
  .flush_ID(flush_ID),
  .rs1_idx_ID(rs1_idx_fromID), 
  .rs2_idx_ID(rs2_idx_fromID), 
  .rd_idx_EX(rd_idx_fromEX), 
  .rd_idx_MEM(rd_idx_fromMEM),
  .rs1_ctrl(rs1_ctrl), 
  .rs2_ctrl(rs2_ctrl)  
);

hazard_unit HZ(
  .mem_rd_fromIF(mem_rd_fromIF),
  .rs1_idx_fromIF(rs1_idx_fromIF), 
  .rs2_idx_fromIF(rs2_idx_fromIF), 
  .rd_idx_fromEX(rd_idx_fromEX), 
  .stall_IF(stall_IF), 
  .flush_ID(flush_ID)
);

endmodule // top
