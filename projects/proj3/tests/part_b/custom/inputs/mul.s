_start:
    addi t0, x0, -4
    addi t1, x0, 6

    mul   t2, t0, t1      # -24
    mulh  s0, t0, t1      # high signed
    mulhu s1, t0, t1      # high unsigned

    add a0, t2, s0
    add a0, a0, s1

    csrrw x0, 0x51E, a0
