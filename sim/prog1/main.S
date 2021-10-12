.section .text
.align 2
.globl main
main:
  lui   t0, 0x8             #t0 -> &_test_start
  li    t3, 380             #t3 -> &array_addr
  lw    t4, 0(t3)           #t4 -> *(&array_addr)
  addi  t1, t3, 4           #t1 -> upper = &array_addr + 4
  lw    t2, -4(t3)         #t2 -> array_size
  sw    t4, 0(t0)           #*(&_test_start) = *(&array_addr)
  slli  t2, t2, 2           #array_size <<= 2
  add   t2, t3, t2          #array_size += &array_addr
loop0:
  bge   t1, t2, end_loop0   #while (upper < array_size)
  addi  t5, t1, -4          #t5 -> lower = upper - 4
  lw    t6, 0(t1)           #t6 -> ref = *(upper)
  add   a0, t0, t5          
  addi  a0, a0, -380        #a0 -> &_test_start + lower
  lw    a1, 0(a0)           #a1 -> *(&_test_start + lower)
loop1:
  blt   a0, t0, end_loop1   #if (&_test_start + lower < &_test_start) goto end_loop1
  bge   t6, a1, end_loop1   #if (ref >= *(&_test_start + lower)) goto end_loop1
  sw    a1, 4(a0)           #*(&_test_start + lower + 4) = *(&_test_start + lower)
  addi  a0, a0, -4          #&_test_start + lower --
  lw    a1, 0(a0)           #*(&_test_start + lower)
  jal   x0, loop1
end_loop1:
  sw    t6, 4(a0)           #*(&_test_start + lower)) = ref
  addi  t1, t1, 4           #upper += 4
  jal   x0, loop0
end_loop0:
  ret