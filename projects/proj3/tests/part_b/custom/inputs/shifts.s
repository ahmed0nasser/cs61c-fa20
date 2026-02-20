_start:
    addi t0, x0, -16      # 0xFFFFFFF0
    slli t1, t0, 1
    srli t2, t0, 1
    srai s0, t0, 1

    add a0, t1, t2
    add a0, a0, s0

    csrrw x0, 0x51E, a0
