## Part A: Mathematical Functions

### Task 1: ReLU

In `relu.s`, implement our `relu` function to apply the mathematical ReLU function on every element of the input array. This ReLU function is defined as ReLU(a)=max(a,0)ReLU(a)=max(a,0), and applying it elementwise on our matrix is equivalent to setting every negative value equal to 0.

Additionally, notice that our `relu` function operates on a 1D vector, not a 2D matrix. We can do this because we’re applying the function individually on every element of the matrix, and our 2D matrix is stored in memory as a row-major 1D vector.

```assembly
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

```

### Task 2: ArgMax

Near the end of our neural net, we’ll be provided with scores for every possible classification. For MNIST, we’ll be given a vector of length 10 containing scores for every digit ranging from 0 to 9. The larger the score for a digit, the more confident we are that our handwritten input image contained that digit. Thus, to classify our handwritten image, we pick the digit with the highest score.

The score for the digit ii is stored in the ii-th element of the array, to pick the digit with the highest score we find the array index with the highest value. In `argmax.s`, implement the `argmax` function to return the index of the largest element in the array. If there are multiple largest elements, return the smallest index.

Additionally, note that just like `relu`, this function takes in a 1D vector and not a 2D matrix. The index you’re expected to return is the index of the largest element in this 1D vector.

```assembly
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
```

### Task 3.1: Dot Product

In `dot.s`, implement the `dot` function to compute the dot product of two integer vectors. The dot product of two vectors aa and bb is defined as dot(a,b)=∑n−1i=0aibi=a0∗b0+a1∗b1+⋯+an−1∗bn−1dot(a,b)=∑i=0n−1aibi=a0∗b0+a1∗b1+⋯+an−1∗bn−1, where aiai is the iith element of aa.

Notice that this function takes in the a stride as a variable for each of the two vectors, make sure you’re considering this when calculating your memory addresses. We’ve described strides in more detail in the background section above, which also contains a detailed example on how stride affects memory addresses for vector elements.

Also note that we do not expect you to handle overflow when multiplying. This means you won’t need to use the `mulh` instruction.

For a closer look at dot products, see this [Wikipedia page](https://en.wikipedia.org/wiki/Dot_product#Algebraic_definition).

```assembly
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
```

```assembly
.import ../../src/dot.s
.import ../../src/utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
	mv a0, s0
    mv a1, s1
    li a2, 9
    li a3, 1
    li a4, 1

    # Call dot function
	jal dot    

    # Print integer result
	mv a1 a0
    jal print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Exit
    jal exit
```

### Task 3.2: Matrix Multiplication

Now that we have a dot product function that can take in varying strides, we can use it to do matrix multiplication. In `matmul.s`, implement the `matmul` function to compute the matrix multiplication of two matrices.

```assembly
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
```

## Part B: File Operations and Main

### Task 1: Read Matrix

In `read_matrix.s`, implement the `read_matrix` function which uses the file operations we described above to read a binary matrix file into memory. If any file operation fails or doesn’t return the expected number of bytes, you must exit the program with specify exit codes.

```assembly
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
```

```assembly
.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    li a0, 4
    jal malloc
    mv s1, a0
    li a0, 4
    jal malloc
    mv s2, a0
    
    la a0, file_path
    mv a1, s1
    mv a2, s2
    jal read_matrix
	mv s0, a0

    # Print out elements of matrix
    mv s0, a0
	lw a1, 0(s1)
    lw a2, 0(s2)
    jal print_int_array

    # Terminate the program
	jal exit
```

### Task 2: Write Matrix

In `write_matrix.s`, implement the `write_matrix` function which uses the file operations we described above to write from memory to a binary matrix file. The file must follow the format described in the background section above. Like with `read_matrix`, iff any file operation fails or doesn’t return the expected number of bytes, you must exit the program with specify exit codes.

```assembly
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


```

```assembly
.import ../../src/write_matrix.s
.import ../../src/utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8, 9 # MAKE CHANGES HERE TO TEST DIFFERENT MATRICES
file_path: .asciiz "outputs/test_write_matrix/student_write_outputs.bin"

.text
main:
    # Write the matrix to a file
    la a0, file_path
    la a1, m0
    li a2, 3
    li a3, 3
   	jal write_matrix

    # Exit the program
	j exit
```

### Task 3: Putting it all Together

In `classify.s`, implement the `classify` function. This will bring together everything you’ve written so far, and create a basic sequence of functions that will allow you to classifiy the preprocessed MNIST inputs using the pretrained matrices we’ve provided. You may need to malloc space when reading in matrices and computing the layers of the network, but remember to always free all data allocated at the end of this process. More information about the `free` function is available in `utils.s` and the background section above. The classify function will be wrapped by the `main.s` file meaning you still must follow calling convention! The `main.s` file, in what we gave you, is a dummy main which will directly call your `classify` function (and pass in the command line arguments) though it could always do more than that!

```assembly
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
    

```

