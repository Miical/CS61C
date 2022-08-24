.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
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
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:
	addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    
    # fopen 
    mv a1, s0
    li a2 1
  	jal fopen
    li t0, -1
    beq a0, t0, error_53
    mv s0, a0 # s0 now is the file pointer

	# (fwrite) write line and column number
    li a0, 4
    jal malloc
    mv s4, a0
    
    sw s2, 0(s4)
    mv a1, s0
    mv a2, s4
    li a3, 1
   	li a4, 4
    jal fwrite
    bne a0, a3, error_54
    
	sw s3, 0(s4)
    mv a1, s0
    mv a2, s4
    li a3, 1
   	li a4, 4
    jal fwrite
    bne a0, a3, error_54
    
    mv a0, s4
    jal free    
    
	# (fwrite) write matrix
    mv a1, s0
    mv a2, s1
    mv a3, s2
    mul a3, a3, s3
    li a4 4
   	jal fwrite
    bne a0, a3, error_54

	# fclose
    mv a1, s0
    jal fclose
    bne a0, x0, error_55

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
	addi sp, sp, 24

    ret

error_1:
	li a1, 1
    jal exit2
error_53:
	li a1, 53
    jal exit2
error_54:
	li a1, 54
    jal exit2
error_55:
	li a1, 55
    jal exit2


