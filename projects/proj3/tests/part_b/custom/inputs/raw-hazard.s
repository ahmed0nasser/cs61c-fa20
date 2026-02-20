_start:
    addi t0, x0, 5
    add  t1, t0, t0
    add  t2, t1, t0
    add  a0, t2, x0
    csrrw x0, 0x51E, a0
