`include "stage_IF.sv"
`include "stage_ID.sv"
`include "stage_EX.sv"
`include "stage_MEM_and_WB.sv"
`include "forward_unit.sv"
`include "hazard_unit.sv"
`include "SRAM_wrapper.sv"

module top (
    input clk,
    input rst
);

logic         br_take, stall_IF, flush_ID, rd_src_fromEX, mem_rd_fromEX;
logic         op1_ctrl, op2_ctrl, rd_src_fromID, mem_wr_fromID, mem_rd_fromID;
logic [1:0]   br_op, rs1_ctrl, rs2_ctrl;
logic [2:0]   funct3_fromID, funct3_fromEX;
logic [3:0]   alu_op, wr_mem_en;
logic [4:0]   rs1_idx_fromIF, rs2_idx_fromIF, rs1_idx_fromID, rs2_idx_fromID;
logic [4:0]   rd_idx_fromID, rd_idx_fromEX, rs2_idx_fromEX, wb_idx;
logic [13:0]  instr_addr, data_addr; 
logic [31:0]  instr, instr_from_mem, mem_read_out, pc_fromIF, pc4_fromIF;
logic [31:0]  wb_data, imm, rs1_fromID, rs2_fromID, pc_fromID, pc4_fromID;
logic [31:0]  rd_fromEX, rd_fromMEM, pc_res, rs2_final, wb_mem;

SRAM_wrapper IM1(
  .CK(clk),
  .CS(1'b1),
  .OE(1'b1),
  .WEB(4'b1111),
  .A(instr_addr),
  .DI(32'd0),
  .DO(instr_from_mem)
);

stage_IF IF(
  .clk(clk),
  .rst(rst),
  .br_take(br_take),
  .stall_IF(stall_IF),
  .instr_from_mem(instr_from_mem),
  .pc_res(pc_res),
  .instr_addr(instr_addr), 
  .pc_fromIF(pc_fromIF), 
  .pc4_fromIF(pc4_fromIF),
  .instr(instr)
);

stage_ID ID(
  .clk(clk), 
  .rst(rst), 
  .flush_ID(flush_ID),
  .wb_idx(wb_idx),
  .instr(instr), 
  .pc_fromIF(pc_fromIF), 
  .pc4_fromIF(pc4_fromIF), 
  .wb_data(wb_data),  
  .op1_ctrl(op1_ctrl), 
  .op2_ctrl(op2_ctrl), 
  .rd_src_fromID(rd_src_fromID),
  .mem_wr_fromID(mem_wr_fromID), 
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
  .br_op(br_op),
  .funct3_fromID(funct3_fromID),
  .alu_op(alu_op),
  .rs2_idx_fromID(rs2_idx_fromID),
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
  .mem_rd_fromEX(mem_rd_fromEX),
  .wr_mem_en(wr_mem_en),
  .funct3_fromEX(funct3_fromEX),
  .rs2_idx_fromEX(rs2_idx_fromEX),
  .rd_idx_fromEX(rd_idx_fromEX),
  .mem_addr(data_addr),
  .rd_fromEX(rd_fromEX),
  .pc_res(pc_res),
  .rs2_final(rs2_final),
  .wb_mem(wb_mem)
  );

SRAM_wrapper DM1(
    .CK(clk),
    .CS(1'b1),
    .OE(mem_rd_fromEX),
    .WEB(wr_mem_en),
    .A(data_addr),
    .DI(wb_mem),
    .DO(mem_read_out)
);

stage_MEM_and_WB MEMandWB(
  .clk(clk), 
  .rst(rst),
  .mem_rd_fromEX(mem_rd_fromEX), 
  .rd_src_fromEX(rd_src_fromEX),
  .funct3_fromEX(funct3_fromEX),
  .rs2_idx_fromEX(rs2_idx_fromEX),
  .rd_idx_fromEX(rd_idx_fromEX),
  .rd_fromEX(rd_fromEX), 
  .mem_read_out(mem_read_out),
  .wb_idx(wb_idx),
  .wb_data(wb_data), 
  .rd_fromMEM(rd_fromMEM)
);

forward_unit FW(
  .clk(clk), 
  .rst(rst),
  .flush_ID(flush_ID),
  .rs1_idx_fromIF(rs1_idx_fromIF), 
  .rs2_idx_fromIF(rs2_idx_fromIF), 
  .rd_idx_fromID(rd_idx_fromID), 
  .rd_idx_fromEX(rd_idx_fromEX),
  .rs1_ctrl(rs1_ctrl), 
  .rs2_ctrl(rs2_ctrl)  
);

hazard_unit HZ(
  .mem_rd_fromID(mem_rd_fromID),
  .br_take(br_take),
  .rs1_idx_fromIF(rs1_idx_fromIF), 
  .rs2_idx_fromIF(rs2_idx_fromIF), 
  .rd_idx_fromID(rd_idx_fromID), 
  .stall_IF(stall_IF), 
  .flush_ID(flush_ID)
);

endmodule // top
