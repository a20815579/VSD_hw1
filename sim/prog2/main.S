.section .text
.align 2
.globl main
main:
  lui   t0, 0x8             #t0 -> &_test_start
  lui   a2, 0x80000         #a2 -> 0x80000000
  li    a3, 0xffffffff      #a3 -> 0xffffffff
  lw    t1, 0x72c(zero)     #t1 -> mul1     
  lw    t2, 0x730(zero)     #t2 -> mul2 low
  #srai  t3, t2, 0x1f        #t3 -> mul2 high
  and   t4, t1, a2          #t4 -> mul1 sign bit
  bge   t4, zero, mul1pos
  xor   t1, t1, a3
  addi  t1, t1, 1           #mul1 = -mul1
mul1pos:  
  and   t5, t2, a2          #t5 -> mul2 sign bit
  bge   t5, zero, mul2pos
  xor   t2, t2, a3
  addi  t2, t2, 1           #mul2 = -mul2
mul2pos:
  xor   t6, t4, t5          #t6 = (result == pos)?
  /* Iter 0 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  li    a1, 0
  bgeu  zero, t4, no_add0   #t4 == 0?
  mv    a0, t2              #a0 = t2 //Doesn't check overflow
  li    t3, 0
no_add0:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 1 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add1   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add1:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 2 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add2   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add2:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 3 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add3   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add3:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 4 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add4   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add4:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 5 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add5   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add5:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 6 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add6   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add6:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 7 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add7   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add7:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 8 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add8   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add8:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 9 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add9   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add9:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 10 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add10   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add10:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 10 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add11   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add11:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 12 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add12   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add12:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 13 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add13   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add13:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 14 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add14   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add14:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 15 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add15   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add15:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 16 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add16   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add16:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 17 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add17   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add17:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 18 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add18   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add18:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 19 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add19   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add19:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 20 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add20   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add20:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 21 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add21   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add21:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 22 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add22   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add22:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 23 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add23   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add23:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 24 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add24   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add24:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 25 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add25   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add25:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 26 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add26   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add26:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 27 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add27   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add27:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 28 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add28   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add28:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 29 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add29   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add29:
  srli  t1, t1, 1           #mul1 >>= 1
  and   t4, t2, a2          #t4 -> mul2 MSB
  slli  t2, t2, 1           #mul2 low <<= 1
  slli  t3, t3, 1           #mul2 high <<= 1
  srli  t4, t4, 0x1f        #t4 >>=31
  add   t3, t3, t4          #mul2 shift left carry
  /* Iter 30 */
  slli  t4, t1, 0x1f        #t4 -> (mul1 & 1) << 31
  bgeu  zero, t4, no_add30   #t4 == 0?
  add   a0, a0, t2          #a0 = a0 + t2 //Doesn't check overflow
  sltu  t5, a0, t2          #t5 = (a0 < t2) -> overflow
  add   t4, t5, t3          #t4 = t5 + t3 //Add carry
  add   a1, a1, t4          #a1 = a1 + t4
no_add30:
  bge   t6, zero, resultpos
  xor   a0, a0, a3
  mv    t6, a0
  addi  a0, a0, 1
  sltu  t6, a0, t6
  xor   a1, a1, a3
  add   a1, a1, t6
resultpos:
  sw    a0, 0(t0)
  sw    a1, 4(t0)
  ret