_start:
    lui t0, 0x12345
    auipc t1, 0

    add a0, t0, t1
    csrrw x0, 0x51E, a0
