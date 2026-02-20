_start:
    lui t0, 0x11223
    addi t0, x0, 0x344
    lui t1, 0xAAA
    addi t1, x0, 0xA
    sw t1, 0(t0)
    lw a0, 0(t0)
    csrrw x0, 0x51E, a0
