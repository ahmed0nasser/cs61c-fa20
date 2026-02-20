_start:
    lui t0, 0x11223
    addi t0, x0, 0x344

    lw t1, 0(t0)
    lb t2, 0(t0)
    lh s0, 0(t0)

    addi s1, x0, 0x55
    sb s1, 0(t0)
    sh s1, 2(t0)
    sw s1, 0(t0)

    lw a0, 0(t0)
    csrrw x0, 0x51E, a0
