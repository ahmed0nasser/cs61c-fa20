.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    slt t0, x0, a1                          # check if a1 > 0
    slt t1, x0, a2                          # check if a2 > 0
    and t1, t1, t0                          # combine checks
    bne t1, x0, m1_dims_check               # jump to m1_dims_check for true check
    addi a1, x0, 72                         # exit with error code 72
    jal exit2

m1_dims_check:
    slt t0, x0, a4                          # check if a4 > 0
    slt t1, x0, a5                          # check if a5 > 0
    and t1, t1, t0                          # combine checks
    bne t1, x0, dims_match_check            # jump to dims_match_check for true check
    addi a1, x0, 73                         # exit with error code 73
    jal exit2

dims_match_check:
    beq a2, a4, start                       # jump to start if m0's cols == m1's rows
    addi a1, x0, 74                         # exit with error code 74
    jal exit2

start:
    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)

    addi s0, a0, 0                          # store m0 pointer (m0 row pointer)
    addi s1, a3, 0                          # store m1 pointer
    addi s2, a1, 0                          # store m0 rows number
    addi s3, a2, 0                          # store common dimension: m0 cols number, m1 rows number
    addi s4, a5, 0                          # store m1 cols number
    addi s5, a6, 0                          # store d pointer
    addi s6, x0, 0                          # initialize outer counter

outer_loop_start:
    beq s6, s2, outer_loop_end              # jump if outer counter equals m0 rows number    
    addi s7, x0, 0                          # initialize inner counter
    addi s8, s1, 0                          # initialize m1 col pointer

inner_loop_start:
    beq s7, s4, inner_loop_end              # jump if inner counter equals m1 cols number
    addi a0, s0, 0                          # move m0 row pointer to a0
    addi a1, s8, 0                          # move m1 col pointer to a1
    addi a2, s3, 0                          # move common dimension to a2
    addi a3, x0, 1                          # put unity stride for row vector
    addi a4, s4, 0                          # put m1 cols number to col vector stride
    jal dot

    sw a0, 0(s5)                            # store dot product in d pointer location

    addi s5, s5, 4                          # update d pointer to next location
    addi s8, s8, 4                          # update m1 col pointer to next col
    addi s7, s7, 1                          # increment inner loop counter
    j inner_loop_start
inner_loop_end:

    slli t0, s3, 2                          # multiply m0 cols number by 2
    add s0, s0, t0                          # update m0 row pointer to next row
    addi s6, s6, 1                          # increment outer loop counter
    j outer_loop_start
outer_loop_end:

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40
   
    ret
