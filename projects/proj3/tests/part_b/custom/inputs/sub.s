_start:
    addi t0, x0, 20
    addi t1, x0, 5

    sub t2, t0, t1      # 15
    sub s0, t1, t1      # 0
    sub s1, t1, t0      # -15

    add a0, t2, s0
    add a0, a0, s1      # 15 + 0 - 15 = 0

    csrrw x0, 0x51E, a0
