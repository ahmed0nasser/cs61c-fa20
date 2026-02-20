_start:
    addi t0, x0, 5
    addi t1, x0, 5
    addi a0, x0, 0

    beq t0, t1, L1
    addi a0, a0, 100

L1:
    bne t0, t1, L2
    addi a0, a0, 1

L2:
    blt t0, t1, L3
    addi a0, a0, 2

L3:
    csrrw x0, 0x51E, a0
