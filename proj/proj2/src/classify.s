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
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
	li t0, 5
	bne a0, t0, error_49

    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
	sw s8, 32(sp)
    sw ra, 36(sp)

	lw s0, 4(a1) # s0 is the path of m0 matrix
    lw s1, 8(a1) # s1 is the path of m1 matrix
    lw s2, 12(a1) # s2 is the path of input matrix 
    lw s3, 16(a1) # s3 is the output path
    mv s8, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
	li a0, 8
    jal malloc
    mv s4, a0 # s4 is the temporary memory to story m0's h, w
    mv a0, s0
    mv a1, s4
    mv a2, s4
    addi a2, a2, 4
    jal read_matrix
    mv s0, a0 # s0 now is the pointer to m0
    
    li a0, 8
    jal malloc
    mv s5, a5 # s4 is the temporary memory to story m1's h, w
    mv a0, s1
    mv a1, s5
    mv a2, s5
    addi a2, a2, 4
    jal read_matrix
    mv s1, a0 # s1 now is the pointer to m1
    
    li a0, 8
    jal malloc
    mv s6, a0 # s4 is the temporary memory to story iuput's h, w
    mv a0, s2
    mv a1, s6
    mv a2, s6
    addi a2, a2, 4
    jal read_matrix
    mv s2, a0 # s2 now is the pointer to input matrix

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

	
    # 1. m0 * input
    
   	# hidden_layer result memory
    lw a1, 0(s4)
    lw a5, 4(s6)
    li a0, 4
    mul a0, a0, a1
    mul a0, a0, a5
    jal malloc
    mv s7, a0 # s7 is pointer to result
	
   	mv a0, s0
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s2
    lw a4, 0(s6)
    lw a5, 4(s6)
    mv a6, s7
    jal matmul
    
  	  # m0 = m0 * input (set s0, [s4])
    mv a0, s0
    jal free
    mv s0, s7
    lw a1, 0(s4)
    lw a5, 4(s6)
    sw a5, 4(s4)
    
    
    # 2. ReLU(m0 * input)
	mv a0, s0
    mul a1, a1, a5
    jal relu
    
    # 3. m1 * ReLU(m0 * input)
    
	lw t0, 0(s5)
    lw t1, 4(s4)
    li a0, 4
    mul a0, a0, t0
    mul a0, a0, t1
    jal malloc
    mv s7, a0 # s7 is the pointer to result
    
    mv a0, s1
    lw a1, 0(s5)
    lw a2, 4(s5)
    mv a3, s0
    lw a4, 0(s4)
    lw a5, 4(s4)
    mv a6, s7
    jal matmul
    
    # m1 = m1 * ()
    mv a0, s1
    jal free
    mv s1, s7
    lw t0, 0(s5)
    lw t1, 4(s4)
    sw t1, 4(s5)
    
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

	mv a0, s3
    mv a1, s2
    lw a2, 0(s5)
    lw a3, 4(s5)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
	mv a0, s1
    lw a1, 0(s5)
    lw t0, 4(s5)
    mul a1, a1, t0
    jal argmax
    mv s7, a0 # s7 is the result

    bne s8, x0, not_print
    # Print classification
    
	mv a1, s7
    jal print_int

    # Print newline afterwards for clarity
	li a1 '\n'
    jal print_char
not_print:
    mv a0, s0
    jal free
    mv a0, s1
    jal free
    mv a0, s2
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free

    mv a0, s7

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40

    ret

error_49:
	li a1, 49
    jal exit2
    
