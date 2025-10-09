.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
	addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    addi s0, a1, 0                      # store matrix pointer
    addi s1, a2, 0                      # store rows#
    addi s2, a3, 0                      # store cols#

    # Open file
    addi a1, a0, 0                      # move filename string to a1
    addi a2, x0, 1                      # put write permission i.e. 1 in a2
    jal fopen                           # open file
    addi t0, x0, -1                     # t0 = -1
    bne a0, t0, write_dims              # jump to write_dims if a0 != -1
    addi a1, x0, 93                     # exit with error code 93
    jal exit2

write_dims:
    addi s3, a0, 0                      # store file descriptor
    addi sp, sp, -8                     # decrease sp pointer by 8
    sw s1, 0(sp)                        # store rows# in low 4 bytes
    sw s2, 4(sp)                        # store cols# in high 4 bytes
    addi a1, s3, 0                      # a1 = file descriptor
    addi a2, sp, 0                      # a2 = pointer to buffer to be written (stack pointer)
    addi a3, x0, 2                      # a3 = 2 (elements# to be written)
    addi a4, x0, 4                      # a4 = 4 (size of each element)
    jal fwrite
    addi t0, x0, 2                      # t0 = 2
    bne a0, t0, fwrite_failure          # jump to fwrite_failure if a0 != 2
    addi sp, sp, 8                      # increase sp pointer by 8

    # Write matrix elements
    addi a1, s3, 0                      # a1 = file descriptor
    addi a2, s0, 0                      # a2 = pointer to buffer to be written (matrix pointer)
    mul a3, s1, s2                      # a3 = rows# * cols# (elements# to be written)
    addi a4, x0, 4                      # a4 = 4 (size of each element)
    jal fwrite
    mul t0, s1, s2                      # t0 = rows# * cols#
    bne a0, t0, fwrite_failure          # jump to fwrite_failure if a0 != rows# * cols#

    # Close file
    addi a1, s3, 0                      # a1 = file descriptor
    jal fclose
    beq a0, x0, return                  # jump to return if a0 == 0
    addi a1, x0, 95                     # exit with error code 95
    jal exit2

return:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
	addi sp, sp, 20

    ret


fwrite_failure:
    addi a1, x0, 94                     # exit with error code 94
    jal exit2