.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
	addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    addi s0, a1, 0                      # store rows# pointer
    addi s1, a2, 0                      # store cols# pointer

    # Open file
    addi a1, a0, 0                      # move filename string to a1
    addi a2, x0, 0                      # put read permission i.e. 0 in a2
    jal fopen                           # open file
    addi t0, x0, -1                     # t0 = -1
    bne a0, t0, dims_malloc             # jump to dims_malloc if a0 != -1
    addi a1, x0, 90                     # exit with error code 90
    jal exit2

dims_malloc:    
    addi s2, a0, 0                      # store file descriptor
    addi a0, x0, 8                      # specify size of rows# and cols# read from the file
    jal malloc                          # allocate memory for them
    beq a0, x0, malloc_failure          # jump to malloc_failure when returned pointer == 0

    # Read matrix dimensions
    addi s3, a0, 0                      # store buffer for rows# and cols#
    addi a1, s2, 0                      # a1 = file descriptor
    addi a2, s3, 0                      # a2 = pointer to buffer
    addi a3, x0, 8                      # a3 = 8 bytes to be read
    jal fread
    addi t0, x0, 8                      # t0 = 8
    bne a0, t0, fread_failure           # jump to fread_failure if a0 != 8

    # Store dimensions in output pointers
    lw t0, 0(s3)                        # t0 = rows# read from buffer    
    lw t1, 4(s3)                        # t1 = cols# read from buffer
    sw t0, 0(s0)                        # store rows# in rows# address
    sw t1, 0(s1)                        # store cols# in cols# address
    mul s4, t0, t1                      # s4 = rows# * cols#
    slli s4, s4, 2                      # s4 = s4 * 4
    addi a0, s3, 0                      # free dimensions buffer memory
    jal free

    # Allocate memory to read matrix
    addi a0, s4, 0                      # a0 = s4 * 4
    jal malloc                          # allocate memory for them
    beq a0, x0, malloc_failure          # jump to malloc_failure when returned pointer == 0

    # Read matrix from file
    addi s3, a0, 0                      # store pointer to matrix allocated memory
    addi a1, s2, 0                      # a1 = file descriptor
    addi a2, s3, 0                      # a2 = pointer to matrix allocated memory
    addi a3, s4, 0                      # a3 = bytes# to be read
    jal fread
    bne a0, s4, fread_failure           # jump to fread_failure if a0 != s4

    # Close file
    addi a1, s2, 0                      # a1 = file descriptor
    jal fclose
    beq a0, x0, return                  # jump to return if a0 == 0
    addi a1, x0, 92                     # exit with error code 92
    jal exit2

return:
    addi a0, s3, 0                      # a0 = pointer to matrix allocated memory
    
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
	addi sp, sp, 24

    ret

malloc_failure:
    addi a1, x0, 88                     # exit with error code 88
    jal exit2

fread_failure:
    addi a1, x0, 91                     # exit with error code 91
    jal exit2