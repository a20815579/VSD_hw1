module hazard_unit (
  input       mem_rd_fromIF
  input [4:0] rs1_idx_fromIF, rs2_idx_fromIF, rd_idx_fromID, 
  output logic  stall_IF, flush_ID
);

always_comb begin
  if ((rd_idx_fromID == rs1_idx_fromIF || rd_idx_fromID == rs2_idx_fromIF) 
      && mem_rd_fromIF && rd_idx_fromID > 0) begin
    stall_IF = 1;
    flush_ID = 1;    
  end
  else if (br_take) begin
    stall_IF = 0;
    flush_ID = 1;
  end
  else begin
    stall_IF = 0;
    flush_ID = 0;
  end
end

endmodule 