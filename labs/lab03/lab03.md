## Exercise 1: Familiarizing yourself with Venus

Paste the contents of `ex1.s` in Venus and record your answers to the following questions. Some of the questions will require you to run the RISC-V code using Venus’ simulator tab.

1. *What do the `.data`, `.word`, `.text` directives mean (i.e. what do you use them for)? Hint: think about the 4 sections of memory.*

   `.data`  is a section to put static data

   `.word` tells that the data size is word

   `.text`  is a section to push code

2. *Run the program to completion. What number did the program output? What does this number represent?*

   34

   fib(9) = 34

3. *At what address is `n` stored in memory? **Hint**: Look at the contents of the registers.*

   0x10000010

4. *Without actually editing the code (i.e. without going into the “Editor” tab), have the program calculate the 13th fib number (0-indexed) by manually modifying the value of a register. You may find it helpful to first step through the code. If you prefer to look at decimal values, change the “Display Settings” option at the bottom.*

   f(13) = 233

## Exercise 2: Translating from C to RISC-V

- The register representing the variable `k`.

  t0

- The register representing the variable `sum`.

​		s0	

- The registers acting as pointers to the `source` and `dest` arrays.

  S1, s2

- The assembly code for the loop found in the C code.

```assembly
loop:
# ...
```



- How the pointers are manipulated in the assembly code.

```assembly
slli s3, t0, 2             
add t1, s1, s3   
```

## Exercise 3: Factorial

In this exercise, you will be implementing the `factorial` function in RISC-V. This function takes in a single integer parameter `n` and returns `n!`. A stub of this function can be found in the file `factorial.s`.

You will only need to add instructions under the `factorial` label, and the argument that is passed into the function is configured to be located at the label `n`. You may solve this problem using either recursion or iteration.

```assembly
.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    addi t0, x0, 1
    addi t1, x0, 1
loop: 
	mul t1, t1, t0
    addi t0, t0, 1
    ble t0, a0, loop
    
    add a0, x0, t1
    ret
```

## Exercise 4: RISC-V function calling with `map`

This exercise uses the file `list_map.s`.

In this exercise, you will complete an implementation of [`map`](https://en.wikipedia.org/wiki/Map_(higher-order_function)) on linked-lists in RISC-V. Our function will be simplified to mutate the list in-place, rather than creating and returning a new list with the modified values.

You will find it helpful to refer to the [RISC-V green card](https://inst.eecs.berkeley.edu/~cs61c/sp21/resources-pdfs/riscvcard.pdf) to complete this exercise. If you encounter any instructions or pseudo-instructions you are unfamiliar with, use this as a resource.

Our `map` procedure will take two parameters; the first parameter will be the address of the head node of a singly-linked list whose values are 32-bit integers. So, in C, the structure would be defined as:

```
struct node {
    int value;
    struct node *next;
};
```

Our second parameter will be the **address of a function** that takes one int as an argument and returns an int. We’ll use the `jalr` RISC-V instruction to call this function on the list node values.

Our `map` function will recursively go down the list, applying the function to each value of the list and storing the value returned in that corresponding node. In C, the function would be something like this:

```
void map(struct node *head, int (*f)(int))
{
    if(!head) { return; }
    head->value = f(head->value);
    map(head->next,f);
}
```

If you haven’t seen the `int (*f)(int)` kind of declaration before, don’t worry too much about it. Basically it means that `f` is a pointer to a function, which, in C, can then be used exactly like any other function.

There are exactly nine (9) markers (8 in `map` and 1 in `main`) in the provided code where it says `YOUR CODE HERE`.

### Action Item

Complete the implementation of `map` by filling out each of these nine markers with the appropriate code. Furthermore, provide a sample call to `map` with `square` as the function argument. There are comments in the code that explain what should be accomplished at each marker. When you’ve filled in these instructions, running the code should provide you with the following output:

```
9 8 7 6 5 4 3 2 1 0
81 64 49 36 25 16 9 4 1 0
```

The first line is the original list, and the second line is the modified list after the map function (in this case square) is applied.

```assembly
.globl map

.text
main:
    jal ra, create_default_list
    add s0, a0, x0  # a0 = s0 is head of node list

    #print the list
    add a0, s0, x0
    jal ra, print_list

    # print a newline
    jal ra, print_newline

    # load your args
    add a0, s0, x0  # load the address of the first node into a0

    # load the address of the function in question into a1 (check out la on the green sheet)
    ### YOUR CODE HERE ###
    la a1, square

    # issue the call to map
    jal ra, map

    # print the list
    add a0, s0, x0
    jal ra, print_list

    # print another newline
    jal ra, print_newline

    addi a0, x0, 10
    ecall #Terminate the program

map:
    # Prologue: Make space on the stack and back-up registers
    ### YOUR CODE HERE ###
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)

    beq a0, x0, done    # If we were given a null pointer (address 0), we're done.

    add s0, a0, x0  # Save address of this node in s0
    add s1, a1, x0  # Save address of function in s1

    # Remember that each node is 8 bytes long: 4 for the value followed by 4 for the pointer to next.
    # What does this tell you about how you access the value and how you access the pointer to next?

    # load the value of the current node into a0
    # THINK: why a0?
    ### YOUR CODE HERE ###
    lw a0, 0(s0)

    # Call the function in question on that value. DO NOT use a label (be prepared to answer why).
    # What function? Recall the parameters of "map"
    ### YOUR CODE HERE ###
    jalr ra, s1, 0

    # store the returned value back into the node
    # Where can you assume the returned value is?
    ### YOUR CODE HERE ###
    sw a0, 0(s0)

    # Load the address of the next node into a0
    # The Address of the next node is an attribute of the current node.
    # Think about how structs are organized in memory.
    ### YOUR CODE HERE ###
    lw a0, 4(s0)

    # Put the address of the function back into a1 to prepare for the recursion
    # THINK: why a1? What about a0?
    ### YOUR CODE HERE ###
    add a1, x0, s1

    # recurse
    ### YOUR CODE HERE ###
    jal ra, map

done:
    # Epilogue: Restore register values and free space from the stack
    ### YOUR CODE HERE ###
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    jr ra # Return to caller

square:
    mul a0 ,a0, a0
    jr ra

create_default_list:
    addi sp, sp, -12
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)
    li  s0, 0       # pointer to the last node we handled
    li  s1, 0       # number of nodes handled
loop:   #do...
    li  a0, 8
    jal ra, malloc      # get memory for the next node
    sw  s1, 0(a0)   # node->value = i
    sw  s0, 4(a0)   # node->next = last
    add s0, a0, x0  # last = node
    addi    s1, s1, 1   # i++
    addi t0, x0, 10
    bne s1, t0, loop    # ... while i!= 10
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    addi sp, sp, 12
    jr ra

print_list:
    bne a0, x0, printMeAndRecurse
    jr ra       # nothing to print
printMeAndRecurse:
    add t0, a0, x0  # t0 gets current node address
    lw  a1, 0(t0)   # a1 gets value in current node
    addi a0, x0, 1      # prepare for print integer ecall
    ecall
    addi    a1, x0, ' '     # a0 gets address of string containing space
    addi    a0, x0, 11      # prepare for print string syscall
    ecall
    lw  a0, 4(t0)   # a0 gets address of next node
    jal x0, print_list  # recurse. We don't have to use jal because we already have where we want to return to in ra

print_newline:
    addi    a1, x0, '\n' # Load in ascii code for newline
    addi    a0, x0, 11
    ecall
    jr  ra

malloc:
    addi    a1, a0, 0
    addi    a0, x0 9
    ecall
    jr  ra
```



