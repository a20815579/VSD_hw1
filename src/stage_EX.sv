`include "../include/all_def.svh"

`define AddrLast2     alu_res[1:0]

module stage_EX(
  input   clk, rst, mem_wr_fromID, mem_rd_fromID, op1_ctrl, op2_ctrl, rd_src_fromID,
  input [1:0]     rs1_ctrl, rs2_ctrl, br_op,
  input [2:0]     funct3_fromID,
  input [3:0]     alu_op,
  input [4:0]     rd_idx_fromID,
  input [31:0]    imm, pc_fromID, pc4_fromID,
  input [31:0]    rs1_fromID, rs1_fw_fromEX, rs1_fw_fromMEM, rs2_fromID, rs2_fw_fromEX, rs2_fw_fromMEM,
  output logic    br_take, mem_rd_fromEX,
  output logic [3:0]    wr_mem_en,
  output logic [2:0]    funct3_fromEX,
  output logic [4:0]    rd_idx_fromEX,
  output logic [13:0]   mem_addr,
  output logic [31:0]   rd_fromEX, pc_res, rs2_final, wb_mem
  );

logic     br_cond_tmp, br_cond_final;
logic [31:0]  alu_res, op1, op2, rs1_final;

// ALU
always_comb begin
  case (alu_op)
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
  if(rd_src_fromID == `RdFromPC4)
    rd_fromEX <= pc4_fromID;
  else
    rd_fromEX <= alu_res;
end

assign pc_res = alu_res;
assign mem_addr = alu_res[15:2];

// branch condition
always_comb begin
  case (funct3_fromID[2:1])
    `BEQ2:
      br_cond_tmp = (rs1_final == rs2_final);
    `BLT2:
      br_cond_tmp = ($signed(rs1_final) < $signed(rs2_final));
    `BLTU2:
      br_cond_tmp = ($unsigned(rs1_final) < $unsigned(rs2_final));
    default:
      br_cond_tmp = 1'b0;
  endcase
end

assign br_cond_final = br_cond_tmp ^ funct3_fromID[0];

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

// deal store to mem
always_comb begin
  if(mem_wr_fromID)
    case(funct3_fromID[1:0])
      `MemByte:
        case(`AddrLast2)
          // active low
          2'b00: begin
            wr_mem_en = 4'b1110;
            wb_mem = rs2_final;
          end
          2'b01: begin
            wr_mem_en = 4'b1101;
            wb_mem = rs2_final << 8;
          end
          2'b10: begin
            wr_mem_en = 4'b1011;
            wb_mem = rs2_final << 16;
          end
          2'b11: begin
            wr_mem_en = 4'b0111;
            wb_mem = rs2_final << 24;
          end
        endcase
      `MemHalf: 
        case(`AddrLast2)
          2'b00: begin
            wr_mem_en = 4'b1100;
            wb_mem = rs2_final;
          end
          2'b01: begin
            wr_mem_en = 4'b1001;
            wb_mem = rs2_final << 8;
          end
          default: begin
            wr_mem_en = 4'b0011;
            wb_mem = rs2_final << 16;
          end
        endcase
      default: begin
        wr_mem_en = 4'b0000;
        wb_mem = rs2_final;
      end
    endcase
  else begin
    wr_mem_en = 4'b1111;
    wb_mem = rs2_final;
  end
end

always_ff @(posedge clk) begin
  if (rst) begin    
    mem_rd_fromEX <= 1'b0;
    rd_idx_fromEX <= 5'd0;
    funct3_fromEX <= 3'd0;
  end
  else begin
    mem_rd_fromEX <= mem_rd_fromID;
    rd_idx_fromEX <= rd_idx_fromID;
    funct3_fromEX <= funct3_fromID; 
  end
end


endmodule
