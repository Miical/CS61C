# Calculate the sum of 1 to 100.
addi s0, x0, 100
addi s1, x0, 0
addi t0, x0, 1
loop_start:
	bgt t0, s0, loop_end
	add s1, s1, t0
    addi t0, t0, 1
	j loop_start
loop_end:
	
