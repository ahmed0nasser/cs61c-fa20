.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    # Check number of command line args
    addi t0, x0, 5                              # t0 = 5
    beq a0, t0, prologue                        # jumb to prologue if a0 == 5
    addi a1, x0, 89                             # exit with error code 89
    jal exit2


prologue:
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)

    # Store args
    lw s0, 4(a1)                                # store M0_PATH
    lw s1, 8(a1)                                # store M1_PATH
    lw s2, 12(a1)                               # store INPUT_PATH
    lw s3, 16(a1)                               # store OUTPUT_PATH
    addi s4, a2, 0                              # store print_classification



	# =====================================
    # LOAD MATRICES
    # =====================================
    # Allocate memory for m0, m1 and input dimensions
    addi a0, x0, 24                             # a0 = 24
    jal malloc
    beq a0, x0, malloc_failure                  # jump to malloc_failure when returned pointer == 0
    addi s5, a0, 0                              # store returned pointer

    # Load pretrained m0
    addi a0, s0, 0                              # a0 = M0_PATH
    addi a1, s5, 0                              # a1 = pointer to rows#
    addi a2, s5, 4                              # a2 = pointer to cols#
    jal read_matrix
    addi s0, a0, 0                              # store returned matrix pointer

    # Load pretrained m1
    addi a0, s1, 0                              # a0 = M1_PATH
    addi a1, s5, 8                              # a1 = pointer to rows#
    addi a2, s5, 12                             # a2 = pointer to cols#
    jal read_matrix
    addi s1, a0, 0                              # store returned matrix pointer

    # Load input matrix
    addi a0, s2, 0                              # a0 = INPUT_PATH
    addi a1, s5, 16                             # a1 = pointer to rows#
    addi a2, s5, 20                             # a2 = pointer to cols#
    jal read_matrix
    addi s2, a0, 0                              # store returned matrix pointer



    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # Allocate memory for matrix d = m0 * input
    lw t0, 0(s5)                                # t0 = m0 rows#
    lw t1, 20(s5)                               # t1 = input matrix cols#
    mul t0, t0, t1                              # t0 = m0 rows# * input matrix cols#
    slli a0, t0, 2                              # a0 = m0 rows# * input matrix cols# * 4
    jal malloc                                  # allocate memory for matrix d
    beq a0, x0, malloc_failure                  # jump to malloc_failure when returned pointer == 0
    addi s6, a0, 0                              # store matrix d pointer

    # Do matrix multiplication
    addi a0, s0, 0                              # a0 = pointer to m0
    lw a1, 0(s5)                                # a1 = m0 rows#
    lw a2, 4(s5)                                # a2 = m0 cols#
    addi a3, s2, 0                              # a3 = pointer to input matrix
    lw a4, 16(s5)                               # a4 = input matrix rows#
    lw a5, 20(s5)                               # a5 = input matrix cols#
    addi a6, s6, 0                              # a6 = pointer to matrix d
    jal matmul


    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    addi a0, s6, 0                              # a0 = pointer to matrix d
    lw t0, 0(s5)                                # t0 = m0 rows#
    lw t1, 20(s5)                               # t1 = input matrix cols#
    mul a1, t0, t1                              # a1 = m0 rows# * input matrix cols#
    jal relu


    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # Allocate memory for matrix f = m1 * d
    lw t0, 8(s5)                                # t0 = m1 rows#
    lw t1, 20(s5)                               # t1 = d cols#
    mul t0, t0, t1                              # t0 = m1 rows# * d cols#
    slli a0, t0, 2                              # a0 = m1 rows# * d cols# * 4
    jal malloc                                  # allocate memory for matrix f
    beq a0, x0, malloc_failure                  # jump to malloc_failure when returned pointer == 0
    addi s7, a0, 0                              # store matrix f pointer

    # Do matrix multiplication    
    addi a0, s1, 0                              # a0 = pointer to m1
    lw a1, 8(s5)                                # a1 = m1 rows#
    lw a2, 12(s5)                               # a2 = m1 cols#
    addi a3, s6, 0                              # a3 = pointer to matrix d
    lw a4, 0(s5)                                # a4 = matrix d rows#
    lw a5, 20(s5)                               # a5 = matrix d cols#
    addi a6, s7, 0                              # a6 = pointer to matrix f
    jal matmul
   


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    addi a0, s3, 0                              # a0 = OUTPUT_PATH
    addi a1, s7, 0                              # a1 = pointer to matrix f
    lw a2, 8(s5)                                # a2 = f rows#
    lw a3, 20(s5)                               # a3 = f cols#
    jal write_matrix



    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    addi a0, s7, 0                              # a0 = pointer to matrix f
    lw t0, 8(s5)                                # t0 = f rows#
    lw t1, 20(s5)                               # t1 = f cols#
    mul a1, t0, t1                              # a1 = f rows# * f cols#
    jal argmax
    bne s4, x0, free_allocated_memory           # jump to free_allocated_memory if a2 != 0

    # Print classification
    addi a1, a0, 0                              # prints argmax result to the console
    jal print_int

    # Print newline afterwards for clarity
    addi a1, x0, 10                             # prints LF character to the console
    jal print_char


free_allocated_memory:
    # Free m0
    addi a0, s0, 0
    jal free
    # Free m1
    addi a0, s1, 0
    jal free
    # Free input matrix
    addi a0, s2, 0
    jal free
    # Free dimensions
    addi a0, s5, 0
    jal free
    # Free matrix d
    addi a0, s6, 0
    jal free
    # Free matrix f
    addi a0, s7, 0
    jal free

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
    addi sp, sp, 36

    ret



malloc_failure:
    addi a1, x0, 88                     # exit with error code 88
    jal exit2
