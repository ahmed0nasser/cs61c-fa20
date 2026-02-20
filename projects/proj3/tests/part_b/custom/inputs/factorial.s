_start:
    addi t0, x0, 5
    addi t1, x0, 1

loop:
    beq t0, x0, done
    mul t1, t1, t0
    addi t0, t0, -1
    jal x0, loop

done:
    add a0, x0, t1
    csrrw x0, 0x51E, a0
