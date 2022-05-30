.section .text
.align 2
.globl main
main:
    lw      t0, div1        # t0 = div1
    lw      t1, div2        # t1 = div2
start_loop:
    beq     t0, x0, end_remain1   # t0 == 0
    beq     t1, x0, end_remain2   # t1 == 0
    blt     t0, t1, remain2
remain1:
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    blt     t0, t1, start_loop
    sub     t0, t0, t1
    j       remain1
remain2:
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    sub     t1, t1, t0
    blt     t1, t0, start_loop
    j       remain2
end_remain1:
    la      t2, _test_start
    sw      t1, 0(t2)
    ret
end_remain2:
    sw      t0, 0(t2)
    ret