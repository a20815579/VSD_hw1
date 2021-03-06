module stage_MEM_and_WB (
  input   clk, rst, mem_rd_fromEX,
  input [2:0]   funct3_fromEX,
  input [4:0]   rd_idx_fromEX,
  input [31:0]  rd_fromEX, mem_read_out,
  output logic [4:0]    wb_idx,
  output logic [31:0]   wb_data, rd_fromMEM
);

// deal load
always_comb begin
  if(mem_rd_fromEX)
    case(funct3_fromEX)
      `LB: 
        wb_data = {{24{mem_read_out[7]}}, mem_read_out[7:0]};
      `LH: 
        wb_data = {{16{mem_read_out[15]}}, mem_read_out[15:0]};
      `LW: 
        wb_data = mem_read_out[31:0];
      `LBU: 
        wb_data = {24'd0, mem_read_out[7:0]};
      `LHU: 
        wb_data = {16'd0, mem_read_out[15:0]};
      default: 
        wb_data = 32'd0;
    endcase
  else
    wb_data = rd_fromEX;
end

assign wb_idx = rd_idx_fromEX;

always_ff @(posedge clk) begin
  if (rst) begin
    rd_fromMEM <= 32'd0;
  end
  else begin
    if(mem_rd_fromEX)
      rd_fromMEM <= wb_data;
    else
      rd_fromMEM <= rd_fromEX;
  end
end

endmodule