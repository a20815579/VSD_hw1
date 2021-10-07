module forward_unit(
  input               clk,
  input [4:0]         rs1_idx_ID,
  input [4:0]         rx2_idx_ID,
  input [4:0]         rd_idx_EX,
  input [4:0]         rd_idx_MEM,
  input               clear,
  output logic [1:0]  rs1_final,
  output logic [1:0]  rs2_final  
  );

always_ff @(posedge clk) begin
  if (clear)
    rs1_final <= `RSFromID;
  else
    if (rd_idx_EX > 0 && rs1_idx_ID == rd_idx_EX)
      rs1_final <= `RSFwFromMEM;
    else if (rd_idx_MEM > 0 && rs1_idx_ID == rd_idx_MEM)
      rs1_final <= `RSFwFromWB;
    else
      rs1_final <= `RSFromID;
end

always_ff @(posedge clk) begin
  if (clear)
    rs2_final <= `EXFromID;
  else
    if (rd_idx_EX > 0 && rx2_idx_ID == rd_idx_EX)
      rs2_final <= `EXFwFromMEM;
    else if (rd_idx_MEM > 0 && rx2_idx_ID == rd_idx_MEM)
      rs2_final <= `EXFwFromWB;
    else
      rs2_final <= `EXFromID;
end
endmodule