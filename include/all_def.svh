`ifndef ALL_DEF_SVH
`define ALL_DEF_SVH

// instrution
`define OP6to2      instr[6:2]
`define FUNCT3      instr[14:12]
`define FUNCT3_2    instr[14]
`define RDIDX       instr[11:7]
`define RS1IDX      instr[19:15]
`define RS2IDX      instr[24:20]
`define FUNCT7      instr[31:25]
`define FUNCT7_5    instr[30]

//imm
`define ImmI        {{21{instr[31]}}, instr[30:20]}
`define ImmST       {{21{instr[31]}}, instr[30:25], instr[11:7]}
`define ImmB        {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}
`define ImmU        {instr[31:12], 12'b0}
`define ImmJ        {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}

// opcode
// R-Type
`define RtypeOP   5'b01100 
// I-Type
`define ItypeOP   5'b00100 
`define LD        5'b00000   // [rs1 + imm] -> rd
`define JALR      5'b11001   // pc + 4 -> rd, rs1 + imm -> PC */
// S-Type
`define ST        5'b01000   // rs2 -> [rs1 + Imm]
// B-Type
`define BRA       5'b11000
// U-Type
`define AUIPC     5'b00101   // pc + imm -> rd 
`define LUI       5'b01101   // imm -> rd
// J-Type
`define JAL       5'b11011   // pc + 4 -> rd, pc + imm -> pc

// alu op
`define ADD     4'b0000
`define SUB     4'b1000
`define SLL     4'b0001
`define SLT     4'b0010
`define SLTU    4'b0011
`define XOR     4'b0100
`define SRL     4'b0101
`define SRA     4'b1101
`define OR      4'b0110
`define AND     4'b0111
`define NOP     4'b1111

`define SR      3'b101

//branch op
`define BEQ     3'b000
`define BNE     3'b001
`define BLT     3'b100
`define BGE     3'b101
`define BLTU    3'b110
`define BGEU    3'b111

`define NOBRA     2'b00
`define BrCond    2'b01
`define BrUcond   2'b10

`define BEQ2    2'b00
`define BLT2    2'b10
`define BLTU2   2'b11

// load store op
`define LB      3'b000
`define LH      3'b001
`define LW      3'b010
`define LBU     3'b100
`define LHU     3'b101

`define MemByte      2'b00
`define MemHalf      2'b01
`define MemWord      2'b10

//other
`define OP1FromRS1    1'b0
`define OP1FromPC     1'b1
`define OP2FromRS2    1'b0
`define OP2FromIMM    1'b1
`define RdFromALU     1'b0
`define RdFromPC4     1'b1

`define RSFromID           2'd0
`define RSFwFromEX         2'd1
`define RSFwFromMEM        2'd2

`endif