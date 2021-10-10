`include "../include/all_def.svh"

module forward_unit(
  input               clk, flush_ID,
  input [4:0]         rs1_idx_ID, rs2_idx_ID, rd_idx_EX, rd_idx_MEM,
  output logic [1:0]  rs1_ctrl, rs2_ctrl  
  );

// forward rs1
always_ff @(posedge clk) begin
  if (rst || flush_ID)
    rs1_ctrl <= `RSFromID;
  else
    if (rd_idx_EX > 0 && rs1_idx_ID == rd_idx_EX)
      rs1_ctrl <= `RSFwFromEX;
    else if (rd_idx_MEM > 0 && rs1_idx_ID == rd_idx_MEM)
      rs1_ctrl <= `RSFwFromMEM;
    else
      rs1_ctrl <= `RSFromID;
end

// forward rs2
always_ff @(posedge clk) begin
  if (flush_ID)
    rs2_ctrl <= `RSFromID;
  else
    if (rd_idx_EX > 0 && rs2_idx_ID == rd_idx_EX)
      rs2_ctrl <= `RSFwFromEX;
    else if (rd_idx_MEM > 0 && rs2_idx_ID == rd_idx_MEM)
      rs2_ctrl <= `RSFwFromMEM;
    else
      rs2_ctrl <= `RSFromID;
end
endmodule