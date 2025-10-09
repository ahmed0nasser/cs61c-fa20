.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    blt x0, a1, start           # jumbs to start if a1 > 0
    addi a1, x0, 78             # exit with error code 78
    jal exit2

start:
    # Prologue

    addi t0, x0, 0              # initialize counter

loop_start:
    beq t0, a1, loop_end        # exit when counter equals array size
    lw t1, 0(a0)                # load current array element
    bge t1, x0, loop_continue   # skip if element is greater than or equal zero
    sw x0, 0(a0)                # store zero in this array element

loop_continue:
    addi a0, a0, 4              # point to next element
    addi t0, t0, 1              # increment counter
    j loop_start                # loop

loop_end:
    # Epilogue
    
	ret
