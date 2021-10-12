.section .text
.align 2
.globl main
main:
    lw      a0, 0x348(zero) #a0->a
    lw      a1, 0x34c(zero) #a1->b
    lui     t0, 0x8         #t0->&_test_start
start_loop:
    beqz    a0, end_loop0   #a0==0
    beqz    a1, end_loop1   #a1==0
    blt     a0, a1, update1
update0:
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    sub     a0, a0, a1
    blt     a0, a1, start_loop
    j       update0
update1:
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    sub     a1, a1, a0
    blt     a1, a0, start_loop
    j       update1

end_loop0:
    sw      a1, 0(t0)
    ret
end_loop1:
    sw      a0, 0(t0)
    ret