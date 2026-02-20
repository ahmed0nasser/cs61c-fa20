jal ra, start

func:
    addi a0, a0, 10
    jalr x0, ra, 0

start:
    addi a0, x0, 0
    jal ra, func
    addi a0, a0, 5
    csrrw x0, 0x51E, a0
