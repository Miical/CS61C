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
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
	bgt a1, x0, valid
    addi a1, x0, 7
    j exit2
valid:
	addi t0, x0, 0 # t0 is the present index 
    lw t1 0(a0)    # t1 is the largest elements
    addi t2, x0, 0 # t2 is the index of the largest element
loop_start:
	addi t0, t0, 1
    beq t0, a1, loop_end
    
    li t3, 4
	mul t3, t3, t0
    add t3, t3, a0
    lw t3, 0(t3)
	bgt t3, t1, loop_continue
    j loop_start
loop_continue:
	mv t1, t3
    mv t2, t0
    j loop_start
loop_end:
	mv a0, t2
    ret
