_start:
    addi t0, x0, 1
    beq t0, t0, next
next:
    addi a0, x0, 5
    csrrw x0, 0x51E, a0
