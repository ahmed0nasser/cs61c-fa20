.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    blt x0, a2, stride_check                # jump to stride_check if a2 > 0
    addi a1, x0, 75                         # exit with error code 75
    jal exit2

stride_check:    
    slt t0, x0, a3                          # check if a3 > 0
    slt t1, x0, a4                          # check if a4 > 0
    and t1, t1, t0                          # combine checks
    bne t1, x0, start                       # jump to start for true check
    addi a1, x0, 76                         # exit with error code 76
    jal exit2
    
start:
    # Prologue

    addi t0, a0, 0                          # store v0 pointer
    addi t1, a1, 0                          # store v1 pointer
    addi t2, x0, 0                          # initialize counter
    addi a0, x0, 0                          # initialize accumulator
    slli a3, a3, 2                          # multiply v0 stride by 4
    slli a4, a4, 2                          # multiply v1 stride by 4

loop_start:
    beq t2, a2, loop_end                    # exit when counter equals vector size
    lw t3, 0(t0)                            # load current v0 element
    lw t4, 0(t1)                            # load current v1 element
    mul t3, t3, t4                          # multiply v0 element by v1 element
    add a0, a0, t3                          # accumulate multiplication result (a0 += t3)
    add t0, t0, a3                          # update v0 pointer to next element
    add t1, t1, a4                          # update v1 pointer to next element
    addi t2, t2, 1                          # increment counter
    j loop_start

loop_end:
    # Epilogue
    
    ret
