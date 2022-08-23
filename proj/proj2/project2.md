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

