.section .text
.align 2
.globl main
main:
  lui   a2, 0x80000         # 0x80000000 -> a2
  li    a3, 0xffffffff      # 0xffffffff -> a3
  lw    t1, mul1            # mul1 -> t1
  lw    t2, mul2            # mul2 low -> t2
  and   t4, t1, a2          # t4 = mul1 sign bit
  beq   t4, x0, mul1pos
  xor   t1, t1, a3
  addi  t1, t1, 1           # t1 = -mul1
mul1pos:  
  and   t5, t2, a2          # t5 = mul2 sign bit
  beq   t5, x0, mul2pos
  xor   t2, t2, a3
  addi  t2, t2, 1           # t2 = -mul2
mul2pos:
  xor   a4, t4, t5          # a4 = result is pos ?
  # iter 0
  slli  t4, t1, 0x1f        # t4 = mul1 << 31 (t4 LSB)
  li    a1, 0
  beq   x0, t4, no_add0     # t4 == 0?
  mv    a0, t2              # a0 = mul2
  li    t3, 0
no_add0:
  srli  t1, t1, 1           # mul1 >>= 1
  and   t4, t2, a2          # t4 = mul2 low MSB
  srli  t4, t4, 0x1f        # t4 >> 31 (t4 = carry)
  slli  t2, t2, 1           # mul2 low <<= 1
  slli  t3, t3, 1           # mul2 high <<= 1
  add   t3, t3, t4          # add back mul2 shift carry
  li    t6, 0x30            # t6 is counter, loop 30 times
# iter 1~29
loop:
  slli  t4, t1, 0x1f        # t4 = mul1 << 31
  beq   x0, t4, no_add      # t4 == 0?
  add   a0, a0, t2          # a0 = a0 + t2 
  sltu  t5, a0, t2          # t5 = (a0 < t2) overflow?
  add   t4, t5, t3          # add carry
  add   a1, a1, t4          # a1 = a1 + t4
no_add:
  srli  t1, t1, 1           # mul1 >>= 1
  and   t4, t2, a2          # t4 = mul2 low MSB
  slli  t2, t2, 1           # mul2 low <<= 1
  slli  t3, t3, 1           # mul2 high <<= 1
  srli  t4, t4, 0x1f        # t4 >> 31
  add   t3, t3, t4          # mul2 shift left carry
  addi  t6, t6, -1
  bne   t6, x0, loop
# iter 30
  slli  t4, t1, 0x1f        # t4 = mul1 << 31
  beq  x0, t4, no_add30     # t4 == 0?
  add   a0, a0, t2          # a0 = a0 + t2 
  sltu  t5, a0, t2          # t5 = (a0 < t2) overflow?
  add   t4, t5, t3          # t4 = t5 + t3 //add carry
  add   a1, a1, t4          # a1 = a1 + t4
no_add30:
  bge   a4, x0, res_pos
  xor   a0, a0, a3
  mv    a4, a0
  addi  a0, a0, 1
  sltu  a4, a0, a4
  xor   a1, a1, a3
  add   a1, a1, a4
res_pos:
  la    t0, _test_start
  sw    a0, 0(t0)
  sw    a1, 4(t0)
  ret