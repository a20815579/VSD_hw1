.section .text
.align 2
.globl main
main:
  la    t0, _test_start     # &_test_start -> t0 (dest)
  la    t1, array_addr      # &array_addr -> t1
  lw    t2, 0(t1)           # array_addr[0] -> t2
  lw    t3, -4(t1)          # array_size -> t3
  sw    t2, 0(t0)           # array_addr[0] -> dest[0]
  addi  t2, t1, 4           # t2 = &array_addr[i] (i = 1)
  slli  t3, t3, 2           # array_size << 2
  add   t1, t1, t3          # t1 = &array_addr + array_size (end of array)
  li    t3, 0               # t3 = j = i-1 = 0
loop0:
  bge   t2, t1, end_loop0   # while (i < array_size) (&array_addr[i] < end of array)
  lw    t4, 0(t2)           # array_addr[i] -> t4 (key)
  add   t5, t0, t3          # t5 = &dest[j]
loop1:
  lw    t6, 0(t5)           # dest[j] -> t6
  blt   t5, t0, end_loop1   # if (&dest[j] < &dest) goto end_loop1
  bge   t4, t6, end_loop1   # if (key >= dest[j]) goto end_loop1
  sw    t6, 4(t5)           # &dest[j+1] = dest[j]
  addi  t5, t5, -4          # &dest[j--]
  j     loop1
end_loop1:
  sw    t4, 4(t5)           # key -> dest[j+1]
  addi  t2, t2, 4           # &array_addr[i++]
  addi  t3, t3, 4           # i++(j++)
  j     loop0
end_loop0:
  ret