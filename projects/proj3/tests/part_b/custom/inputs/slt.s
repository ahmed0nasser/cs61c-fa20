_start:
    addi t0, x0, -5
    addi t1, x0, 3

    slt t2, t0, t1      # 1
    slt s0, t1, t0      # 0
    slt s1, t1, t1      # 0

    add a0, t2, s0
    add a0, a0, s1      # expect 1

    csrrw x0, 0x51E, a0
