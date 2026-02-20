_start:
    lui t0, 0x11223
    addi t0, x0, 0x344
    addi t1, x0, 1
    sw t1, 0(t0)
    addi t1, x0, 2
    sw t1, 4(t0)
    addi t1, x0, 3
    sw t1, 8(t0)
    addi t1, x0, 4
    sw t1, 12(t0)
    addi t1, x0, 5
    sw t1, 16(t0)
    addi t2, x0, 0

loop:
    beq t1, x0, done
    lw s0, 0(t0)
    add t2, t2, s0
    addi t0, t0, 4
    addi t1, t1, -1
    jal x0, loop

done:
    add a0, x0, t2
    csrrw x0, 0x51E, a0
