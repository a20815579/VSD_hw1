module stage_IF (
  input           clk, rst, br_take, hazard,
  input [31:0]    instr_from_mem, pc_res,
  output logic [13:0] instr_addr,
  output logic [31:0] pc_fromIF, pc4_fromIF, instr
);

logic         br_take_reg, hazard_reg;
logic [31:0]  pc, pc4, instr_reg;

assign instr_addr = pc[15:2];
assign pc4 = pc + 4;

always_comb begin
  if(br_take_reg)
    instr = 32'd0;
  else if(hazard_reg)
    instr = instr_reg;
  else
    instr = instr_from_mem;
end

// pc ctrl
always_ff @(posedge clk) begin
  if (rst)
      pc <= 32'd0;
  else 
    if (br_take)
      pc <= pc_res;
    else if (hazard)
      pc <= pc;
    else
      pc <= pc4;
end

always_ff @(posedge clk) begin
  if (rst || br_take) begin
    pc_fromIF <= 0;
    pc4_fromIF <= 0;
  end
  else if (hazard) begin
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
    instr_reg <= 32'b0;
    br_take_reg <= 1'b0;
    hazard_reg <= 1'b1;
  end
  else begin
    instr_reg <= instr;
    br_take_reg <= br_take;
    hazard_reg <= hazard;
  end
end

endmodule