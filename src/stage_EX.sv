`include "../include/all_def.svh"

module stage_EX(
  input   clk, rst, mem_wr_fromID, mem_rd_fromID, op1_ctrl, op2_ctrl, rd_src_fromID,
  input [1:0]     rs1_ctrl, rs2_ctrl,
  input [2:0]     funct3_fromID
  input [4:0]     rs2_idx_fromID, rd_idx_fromID,
  input [31:0]    imm, pc_fromID, pc4_fromID,
  input [31:0]    rs1_fromID, rs1_fw_fromEX, rs1_fw_fromMEM, rs2_fromID, rs2_fw_fromEX, rs2_fw_fromMEM,
  output logic    br_take, rd_src_fromEX, mem_rd_fromEX,
  output logic [1:0]    wr_mem_en,
  output logic [2:0]    funct3_fromEX,
  output logic [4:0]    rs2_idx_fromEX, rd_idx_fromEX,
  output logic [13:0]   mem_addr,
  output logic [31:0]   alu_res, rd_fromEX ,pc4_fromEX
  );

logic     br_cond_tmp, br_cond_final;
logic [31:0]  alu_res, op1, op2, rs1_final, rs2_final;

// ALU
always_comb begin
  case (alu_op_fromID)
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
      alu_res = 32'd0;
  endcase
end

always_ff @(posedge clk) begin
  if(rd_src_fromID == RdFromPC4)
    rd_fromEX <= pc4_fromID;
  else
    rd_fromEX <= alu_res;
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
      br_cond_tmp = 1'b0;
    end
  endcase
end

assign wire br_cond_final = br_cond_tmp ^ funct3_fromID[0];

always_comb begin
  case(br_op)
    `BrCond: 
      br_take = br_cond_final;
    `BrUcond: 
      br_take = 1'b1;
    default: 
      br_take = 1'b0;
  endcase
end

// op1 ctrl
always_comb begin
  case (rs1_ctrl)
    `RSFromID:
      rs1_final = rs1_fromID;
    `RSFwFromEX:
      rs1_final = rs1_fw_fromEX;
    `RSFwFromMEM:
      rs1_final = rs1_fw_fromMEM;
    default:
      rs1_final = rs1_fromID;
  endcase
end

always_comb begin
  if (op1_ctrl == `OP1FromRS1)
    op1 = rs1_final;
  else
    op1 = pc_fromID;
end

always_comb begin
  case (rs2_ctrl)
    `RSFromID:
      rs2_final = rs2_fromID;
    `RSFwFromEX:
      rs2_final = rs2_fw_fromEX;
    `RSFwFromMEM:
      rs2_final = rs2_fw_fromMEM;
    default:
      rs2_final = rs2_fromID;
  endcase
end

always_comb begin
  if (op2_ctrl == `OP2FromRS2)
    op2 = rs2_final;
  else
    op2 = imm;
end

// prepare for store to memory
always_comb begin
  mem_addr = alu_res[15:2];
end

always_comb begin
  if(mem_wr_fromID)
    case(funct3_fromID[1:0])
      `MemByte:
        case(`AddrLast2)
          2'b00: 
            wr_mem_en = 4'b0001;
          2'b01: 
            wr_mem_en = 4'b0010;
          2'b10: 
            wr_mem_en = 4'b0100;
          2'b11: 
            wr_mem_en = 4'b1000;
        endcase
      `MemHalf: 
        case(`AddrLast2)
          2'b00:
            wr_mem_en = 4'b0011;
          2'b01:
            wr_mem_en = 4'b0110;
          default:
            wr_mem_en = 4'b1100;
        endcase
      default: 
        wr_mem_en = 4'b1111;
    endcase
  else
    wr_mem_en = 4'b0000;
end

always_ff @(posedge clk) begin
  if (rst) begin    
    rs2_idx_fromEX <= 0;
    mem_rd_fromEX <= 0;
    pc4_fromEX <= 0;
    rd_idx_fromEX <= 1'b0;
    funct3_fromEX <= 1'b0;
    //alu_res_fromEX <= 1'b0; 
  end
  else begin
    rs2_idx_fromEX <= rs2_idx_fromID;
    mem_rd_fromEX <= mem_rd_fromID;
    pc4_fromEX <= pc4_fromID;
    rd_src_fromEX <= rd_src_fromID;
    rd_idx_fromEX <= rd_idx_fromID;
    funct3_fromEX <= funct3_fromID; 
    //alu_res_fromEX <= alu_res; 
  end
end


endmodule