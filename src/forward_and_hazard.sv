module forward_and_hazard (
  input       clk, rst,
  input       mem_rd_fromID, br_take,
  input [4:0] rs1_idx_fromIF, rs2_idx_fromIF, rd_idx_fromID, rd_idx_fromEX,
  output logic  hazard,
  output logic [1:0]  rs1_ctrl, rs2_ctrl 
);

// hazard
always_comb begin
  if (((rd_idx_fromID == rs1_idx_fromIF || rd_idx_fromID == rs2_idx_fromIF) 
      && mem_rd_fromID && rd_idx_fromID > 0) || br_take) begin
    hazard = 1'b1;
  end
  else begin
    hazard = 1'b0;
  end
end

// forward rs1
always_ff @(posedge clk) begin
  if (rst || hazard)
    rs1_ctrl <= `RSFromID;
  else
    if (rd_idx_fromID > 0 && rs1_idx_fromIF == rd_idx_fromID)
      rs1_ctrl <= `RSFwFromEX;
    else if (rd_idx_fromEX > 0 && rs1_idx_fromIF == rd_idx_fromEX)
      rs1_ctrl <= `RSFwFromMEM;
    else
      rs1_ctrl <= `RSFromID;
end

// forward rs2
always_ff @(posedge clk) begin
  if (rst || hazard)
    rs2_ctrl <= `RSFromID;
  else
    if (rd_idx_fromID > 0 && rs2_idx_fromIF == rd_idx_fromID)
      rs2_ctrl <= `RSFwFromEX;
    else if (rd_idx_fromEX > 0 && rs2_idx_fromIF == rd_idx_fromEX)
      rs2_ctrl <= `RSFwFromMEM;
    else
      rs2_ctrl <= `RSFromID;
end

endmodule 