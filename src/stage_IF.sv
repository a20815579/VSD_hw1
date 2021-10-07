module stage_IF (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input rst_n,  // Asynchronous reset active low
  
);

always_comb begin
    pc4 = pc + 4;
end

// pc ctrl
always_ff @(posedge clk) begin
  if (rst)
      pc <= 32'd0;
  else if (br_take)
      pc <= alu_res;
  else if (!stall)
      pc <= pc4;
  else
      pc <= pc;
end

always_ff @(posedge clk) begin
  if (rst || br_take) begin
    pc_toID <= 0;
    pc4_toID <= 0;
  end
  else if (!stall) begin
    pc_toID <= pc;
    pc4_toID <= pc4;
  end
  else begin
    pc_toID <= pc_toID;
    pc4_toID <= pc4_toID;
  end
end

always_ff @(posedge clk) begin
    if (rst) begin
        last_instr <= 0;
    end
    else begin
        last_instr <= instr;
    end
end

always_comb begin
    instr_addr = pc[15:2];
    // inst = (lastBranchTaken) ? 32'd0 : (lastStall) ? lastInst : instFromIMem;
end

// ?
/* branch taken, stall */
always_ff @(posedge clk) begin
    if (rst) begin
        lastBranchTaken <= 0;
        lastStall <= 1;
    end
    else begin
        lastBranchTaken <= branchTaken;
        lastStall <= stall;
    end
end

endmodule