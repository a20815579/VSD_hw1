module stage_MEM_and_WB (
  input   clk, rst_n, mem_rd_fromEX, rd_src_fromEX,
  input [2:0]   funct3_fromEX,
  input [4:0]   rd_idx_fromEX,
  output logic [4:0]    rd_idx_toWB,
  output logic [31:0]   wb_data, rd_toWB
);

// load
always_comb begin
  if(mem_rd_fromEX)
    case(funct3_fromEX)
      `LB: 
        wb_data = {24{mem_read_out[7]}, mem_read_out[7:0]};
      `LH: 
        wb_data = {16{mem_read_out[15]}, mem_read_out[15:0]};
      `LW: 
        wb_data = mem_read_out[31:0];
      `LBU: 
        wb_data = {24'd0, mem_read_out[7:0]};
      `LHU: 
        wb_data = {16'd0, mem_read_out[15:0]};
      default: 
        wb_data = 32'd0;
    endcase
  else if (rd_src_fromEX == `RdFromPC4)
    wb_data = pc4_fromEX;
  else
    wb_data = alu_res_fromEX;
end

always_comb begin
  if(mem_rd_fromEX)
    wb_idx = rs2_idx;
  else
    wb_idx = rd_idx_fromEX;
end

always_ff @(posedge clk) begin
  if (rst) begin
    rd_idx_toWB <= 5'd0;
    rd_toWB <= 32'd0;
  end
  else begin
    rd_idx_toWB <= rd_idx_fromEX;
    rd_toWB <= alu_res_fromEX;
  end
end

endmodule