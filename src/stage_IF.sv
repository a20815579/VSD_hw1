module stage_IF (
  input           clk, rst, br_take, stall_IF,
  input [31:0]    instr_from_mem, pc_res,
  output logic [13:0] instr_addr,
  output logic [31:0] pc_fromIF, pc4_fromIF, instr
);

logic         br_take_reg, stall_IF_reg;
logic [31:0]  pc, pc4, instr_reg;

always_comb begin
    pc4 = pc + 4;
    instr_addr = pc[15:2];
    instr = (br_take_reg) ? 32'd0 : (stall_IF_reg) ? instr_reg : instr_from_mem;
end

// pc ctrl
always_ff @(posedge clk) begin
  if (rst)
      pc <= 32'd0;
  else if (br_take)
      pc <= pc_res;
  else if (!stall_IF)
      pc <= pc4;
  else
      pc <= pc;
end

always_ff @(posedge clk) begin
  if (rst || br_take) begin
    pc_fromIF <= 0;
    pc4_fromIF <= 0;
  end
  else if (stall_IF) begin
    pc_fromIF <= pc_fromIF;
    pc4_fromIF <= pc4_fromIF;    
  end
  else begin
    pc_fromIF <= pc;
    pc4_fromIF <= pc4;
  end
end

always_ff @(posedge clk) begin
  if (rst) begin
    instr_reg <= 0;
    br_take_reg <= 0;
    stall_IF_reg <= 1;
  end
  else begin
    instr_reg <= instr;
    br_take_reg <= br_take;
    stall_IF_reg <= stall_IF;
  end
end

endmodule