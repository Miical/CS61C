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
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
	ble a2, x0, error_5
    ble a3, x0, error_6
    ble a4, x0, error_6
    j valid
error_5:
	addi a1, x0, 5
    j exit2
error_6:
	addi a1, x0, 6
    j exit2
valid: 
	add t0, x0, x0 # t0 is the present index 
    add t1, x0, x0 # t1 is the sum
loop_start:
	# t3 is the first value
    addi t3, x0, 4
	mul t3, t3, a3
    mul t3, t3, t0
    add t3, t3, a0
    lw t3, 0(t3)
    
    # t4 is the second value
    addi t4, x0, 4
    mul t4, t4, a4
    mul t4, t4, t0
    add t4, t4, a1
    lw t4, 0(t4)
    
    # product is saved in t3
    mul t3, t3, t4    
    add t1, t1, t3
    
    addi t0, t0, 1
    beq t0, a2, loop_end
    j loop_start
    
loop_end:
    mv a0, t1
    ret
