module stage_EX(

  );

// ALU
always_comb begin
  case (aluOp)
    `ADD:
      alu_res = op1 + op2;
    `SUB:
      alu_res = op1 - op2;
    `SLL:
      alu_res = op1 << (op2[4:0]);
    `SRL:
      alu_res = op1 >> (op2[4:0]);
    `SLT:
      alu_res = $signed(op1) < $signed(op2);
    `SLTU:
      alu_res = $unsigned(op1) < $unsigned(op2);
    `XOR:
      alu_res = op1 ^ op2;    
    `OR:
      alu_res = op1 | op2;
    `AND:
      alu_res = op1 & op2;    
    `SRA:
      alu_res = $signed(op1) >>> (op2[4:0]);
    default:
      alu_res = 32'h0;
  endcase
end

// branch condition
always_comb begin
  case (funct3_fromID[2:1])
    `BEQ2:
      br_cond_tmp = (op1 == op2);
    `BLT2:
      br_cond_tmp = ($signed(rs1_final) < $signed(forwardedRS2));
    `BLTU2:
      br_cond_tmp = ($unsigned(rs1_final) < $unsigned(forwardedRS2));
    default: begin
      br_cond_tmp = 0;
    end
  endcase
end

assign wire br_cond_final = br_cond_tmp ^ funct3_fromID[0];

always_comb begin
  case(br_op)
    `BrCond: 
      br_take = br_cond_final;
    `BrUcond: 
      br_take = 1;
    default: 
      br_take = 0;
  endcase
end

// op1 ctrl
always_comb begin
  case (op1_fw_ctrl)
    `EXFromID:
      rs1_final = rs1;
    `EXFwFromMEM:
      rs1_final = rs1_fromMEM;
    `EXFwFromWB:
      rs1_final = rs1_fromWB;
    default:
      rs1_final = rs1;
  endcase
end

always_comb begin
  if (op1_ctrl == `OP1FromRS1)
    op1 = rs1_final;
  else
    op1 = pc_fromID;
end

always_comb begin
  case (op2_fw_ctrl)
    `EXFromID:
      rs2_final = rs2;
    `EXFwFromMEM:
      rs2_final = rs2_fromMEM;
    `EXFwFromWB:
      rs2_final = rs2_fromWB;
    default:
      rs2_final = rs2;
  endcase
end

always_comb begin
  if (op2_ctrl == `OP2FromRS2)
    op2 = rs1_final;
  else
    op2 = imm_fromID;
end

always_ff @(posedge clk) begin
  if (rst) begin
    pc4_toMEM <= 0;
    rs2_toMEM <= 0;
    rd_idx_toMEM <= 0;
    mem_wr_toMEM <= 0;
    mem_rd_toMEM <= 0;
    funct3_toMEM <= 0;
    //WBSelToMEM <= 0;   
  end
  else begin
    pc4_toMEM <= pc4_fromID;
    rs2_toMEM <= rs2_final;
    rd_idx_toMEM <= rd_idx_fromID;
    mem_wr_toMEM <= mem_wr_fromID;
    mem_rd_toMEM <= mem_rd_fromID;
    funct3_toMEM <= funct3_fromID;  
  end
end


endmodule