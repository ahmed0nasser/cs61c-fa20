_start:
    addi t0, x0, 0xF0
    addi t1, x0, 0x0F

    and t2, t0, t1
    or  s0, t0, t1
    xor s1, t0, t1

    andi sp, t0, 0xFF
    ori  ra, t1, 0xF0
    xori a0, t1, 0xFF

    add a0, a0, t2
    add a0, a0, s0
    add a0, a0, s1

    csrrw x0, 0x51E, a0
