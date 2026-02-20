_start:
    addi t0, x0, 3
loop:
    addi t0, t0, -1
    bne t0, x0, loop
    addi a0, x0, 7
    csrrw x0, 0x51E, a0
