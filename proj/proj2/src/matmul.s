.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
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
# =======================================================
matmul:

    # Error checks
    ble a1, x0, error_2
    ble a2, x0, error_2
    ble a4, x0, error_3
    ble a5, x0, error_3
    bne a2, a4, error_4
    j no_error
error_2:
	addi a1, x0, 2
    j exit2
error_3:
	addi a1, x0, 3
    j exit2
error_4:
	addi a1, x0, 4
    j exit2
no_error:

    # Prologue
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
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    
    add s7, x0, x0 # i(s7) = 0
outer_loop_start:
	beq s7, s1, outer_loop_end

	add s8, x0, x0 # j(s8) = 0
inner_loop_start:
	beq s8, s5, inner_loop_end


	li a0, 4
    mul a0, a0, s2
    mul a0, a0, s7
    add a0, a0, s0
    li a3, 1
    
    li a1, 4
    mul a1, a1, s8
    add a1, a1, s3
    mv a4, s5
    
	mv a2, s2
    
    jal ra dot
    
    mul t0, s2, s7
    add t0, t0, s8
    li t1, 4
    mul t0, t0, t1
    add t0, t0, s6
    sw a0, 0(t0)


	addi s8, s8, 1
	j inner_loop_start
inner_loop_end:

	addi s7, s7, 1
	j outer_loop_start
outer_loop_end:

	# Epilogue
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

