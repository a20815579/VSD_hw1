module stage_MEM (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input rst_n,  // Asynchronous reset active low
  
);

// store
always_comb begin
  if(mem_wr_fromEX)
    case(funct3_fromEX[1:0])
      `MemByte:
        case(`AddrLast2)
          2'b00: 
            wr_en = 4'b0001;
          2'b01: 
            wr_en = 4'b0010;
          2'b10: 
            wr_en = 4'b0100;
          2'b11: 
            wr_en = 4'b1000;
        endcase
      `MemHalf: 
        case(`AddrLast2)
          2'b00:
            wr_en = 4'b0011;
          2'b01:
            wr_en = 4'b0110;
          default:
            wr_en = 4'b1100;
        endcase
      default: 
        wr_en = 4'b1111;
    endcase
  else
    wr_en = 4'b0000;
end

always_ff @(posedge clk) begin
  if (rst) begin
    rd_idx_toWB <= 5'd0;
    alu_res_toWB <= 32'd0;
    pc4_toWB <= 32'd0;
    mem_rd_toWB <= 1'b0;
    funct3_toWB <= 3'b000;
  end
  else begin
    rd_idx_toWB <= rd_idx_fromEX;
    alu_res_toWB <= alu_res_fromEX;
    pc4_toWB <= pc4_fromEX;
    mem_rd_toWB <= mem_rd_fromEX;
    funct3_toWB <= funct3_fromEX;
  end
end

endmodule