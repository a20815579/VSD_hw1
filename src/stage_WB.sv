module stage_WB (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input rst_n,  // Asynchronous reset active low
  
);

always_comb begin
  if(mem_rd_fromMEM)
    case(funct3_fromMEM)
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
  else
    wb_data = alu_res_fromMEM;
end

endmodule