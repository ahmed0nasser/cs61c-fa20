.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    blt x0, a1, start           # jumbs to start if a1 > 0
    addi a1, x0, 77             # exit with error code 77
    jal exit2

start:
    # Prologue

    addi t0, x0, 0              # initialize counter
    addi t1, a0, 0              # initialize next element pointer
    lw t2, 0(t1)                # initialize max element
    addi a0, x0, 0              # initialize max element index

loop_start:
    beq t0, a1, loop_end        # exit when counter equals array size
    lw t3, 0(t1)                # load current array element
    bge t2, t3, loop_continue   # skip if max is greater than or equal current
    addi t2, t3, 0              # update max element
    addi a0, t0, 0              # update max element index

loop_continue:
    addi t1, t1, 4              # point to next element
    addi t0, t0, 1              # increment counter
    j loop_start                # loop

loop_end:
    # Epilogue
    
	ret
