.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
	mv t0, x0    
	bgt a1, x0, loop_start
    addi a1, x0, 8
    j exit2
loop_start:
	li t1, 4
    mul t1, t0, t1
    add t1, t1, a0
    lw t2, 0(t1)
    bge t2, x0, loop_continue
    sub t2, x0, t2
    sw t2, 0(t1)
loop_continue:
	addi t0, t0, 1
    beq t0, a1, loop_end
    j loop_start
loop_end:
	ret
