wvRestoreSignal -win $_nWave1 "/homes/nfs/Parker/sandy/H24071037/build/signal.rc" \
           -overWriteAutoAlias on
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvSelectSignal -win $_nWave1 {( "G2" 9 )} 
wvSelectSignal -win $_nWave1 {( "G2" 5 )} 
wvSelectSignal -win $_nWave1 {( "G2" 11 )} 
wvScrollDown -win $_nWave1 0
wvScrollUp -win $_nWave1 1
wvScrollUp -win $_nWave1 1
wvScrollUp -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvSetCursor -win $_nWave1 14273949.097247 -snap {("G2" 6)}
wvScrollUp -win $_nWave1 1
wvScrollUp -win $_nWave1 1
wvScrollUp -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvResizeWindow -win $_nWave1 0 23 1280 657
wvScrollDown -win $_nWave1 3
wvScrollUp -win $_nWave1 3
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 9)}
wvSetPosition -win $_nWave1 {("G1" 0)}
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSelectSignal -win $_nWave1 {( "G2" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 )} \
           
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 0)}
wvSelectGroup -win $_nWave1 {G3}
wvSelectGroup -win $_nWave1 {G1}
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 28)}
wvSetPosition -win $_nWave1 {("G1" 28)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top_tb/TOP/ID/alu_op\[3:0\]} \
{/top_tb/TOP/ID/br_op\[1:0\]} \
{/top_tb/TOP/ID/clk} \
{/top_tb/TOP/ID/flush_ID} \
{/top_tb/TOP/ID/funct3_fromID\[2:0\]} \
{/top_tb/TOP/ID/imm\[31:0\]} \
{/top_tb/TOP/ID/instr\[31:0\]} \
{/top_tb/TOP/ID/mem_rd_fromID} \
{/top_tb/TOP/ID/mem_rd_fromIF} \
{/top_tb/TOP/ID/mem_wr_fromID} \
{/top_tb/TOP/ID/op1_ctrl} \
{/top_tb/TOP/ID/op2_ctrl} \
{/top_tb/TOP/ID/pc4_fromID\[31:0\]} \
{/top_tb/TOP/ID/pc4_fromIF\[31:0\]} \
{/top_tb/TOP/ID/pc_fromID\[31:0\]} \
{/top_tb/TOP/ID/pc_fromIF\[31:0\]} \
{/top_tb/TOP/ID/rd_idx_fromID\[4:0\]} \
{/top_tb/TOP/ID/rd_src_fromID} \
{/top_tb/TOP/ID/regfile\[31:0\]} \
{/top_tb/TOP/ID/rs1_fromID\[31:0\]} \
{/top_tb/TOP/ID/rs1_idx_fromID\[4:0\]} \
{/top_tb/TOP/ID/rs1_idx_fromIF\[4:0\]} \
{/top_tb/TOP/ID/rs2_fromID\[31:0\]} \
{/top_tb/TOP/ID/rs2_idx_fromID\[4:0\]} \
{/top_tb/TOP/ID/rs2_idx_fromIF\[4:0\]} \
{/top_tb/TOP/ID/rst} \
{/top_tb/TOP/ID/wb_data\[31:0\]} \
{/top_tb/TOP/ID/wb_idx\[4:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 25 26 27 28 )} 
wvSetPosition -win $_nWave1 {("G1" 28)}
wvGetSignalClose -win $_nWave1
wvScrollUp -win $_nWave1 5
wvScrollDown -win $_nWave1 0
wvSelectGroup -win $_nWave1 {G1}
wvRenameGroup -win $_nWave1 {G1} {ID}
wvScrollDown -win $_nWave1 4
wvScrollUp -win $_nWave1 1
wvScrollUp -win $_nWave1 1
wvScrollUp -win $_nWave1 1
wvScrollUp -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvZoomOut -win $_nWave1
