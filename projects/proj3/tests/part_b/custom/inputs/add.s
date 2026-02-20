_start:
    addi t0, x0, 5
    addi t1, x0, 10
    add  t2, t0, t1      # 15

    add  s0, t0, x0      # 5
    add  s1, x0, t1      # 10

    addi a0, x0, 0
    add  a0, a0, t2
    add  a0, a0, s0
    add  a0, a0, s1      # 15+5+10=30

    csrrw x0, 0x51E, a0
