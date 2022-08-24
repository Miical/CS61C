.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:
	addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    # fopen 
    mv a1, s0
    li a2 0
  	jal fopen
    li t0, -1
    beq a0, t0, error_50
    mv s0, a0 # s0 now is the file pointer
    
    # (fread) read row number
    mv a1, s0
    mv a2, s1
   	li a3, 4
    jal fread
    li t0, 4
   	bne a0, t0, error_51
    lw s1, 0(s1) # s1 now is the row number
    
    # (fread) read column number
    mv a1, s0
    mv a2, s2
   	li a3, 4
    jal fread
    li t0, 4
   	bne a0, t0, error_51
    lw s2, 0(s2) # s2 now is the column number
    
    # malloc
   	li a0, 4
    mul a0, a0, s1
    mul a0, a0, s2
    jal malloc
   	mv s3, a0 # s3 is the memory address 
    
    # (fread) read matrix
    mv a1, s0
    mv a2, s3
   	li a3, 4
    mul a3, a3, s1
    mul a3, a3, s2
    jal fread
    li t0, 4
    mul t0, t0, s1
    mul t0, t0, s2
   	bne a0, t0, error_51
    
    # fclose
   	mv a1, s0
    jal fclose
    bne a0, x0, error_52
    
    mv a0, s3

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
	addi sp, sp, 20
    
	ret

error_1:
	li a1, 1
    jal exit2
error_50:
	li a1, 50
    jal exit2
error_51:
	li a1, 51
    jal exit2   
error_52:
	li a1, 52
    jal exit2
    
   
