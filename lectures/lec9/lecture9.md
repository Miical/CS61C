![image-20220822131838900](lecture9.assets/image-20220822131838900.png)

## Compiler

- Input: Higher-level language (HLL) code 
- Output: Assembly Language Code
- Note that the output may contain pseudo-instructions
- In reality, there's a preprocessor step before this to handle #directives but it's not very exciting



## Assembler

- Input: Assembly language code
- Output: Object code
- Read and uses directives
- Replaces pseudo-instructions
- Produces machine language



**Assembler Directives**

- .text: Subsequent items put in user text segment
- .data: Subsequent items put in user data segment
- .globl sum: declares sim global and can be referenced from other files
- .asciiz str: Store the string str in memory and null-terminates it 
- .word w1...wn: Store the n 32-bit quantities in successive memory words

![image-20220822133016722](lecture9.assets/image-20220822133016722.png)

![image-20220822133626590](lecture9.assets/image-20220822133626590.png)

![image-20220822134514837](lecture9.assets/image-20220822134514837.png)

![image-20220822134731403](lecture9.assets/image-20220822134731403.png)

![image-20220822134756681](lecture9.assets/image-20220822134756681.png)



![image-20220822135004135](lecture9.assets/image-20220822135004135.png)



## Linker

- Input: Object Code files, information tables
- Output: Executable Code
- Combines several object files into a single executable
- Enables separate compilation of files
  - Changes to one file do not require recompilation of whole program
  - Old name "Link Editor" from editing the "links" in jump and link instructions

![image-20220822141709834](lecture9.assets/image-20220822141709834.png)

![image-20220822141831788](lecture9.assets/image-20220822141831788.png)

![image-20220822142038242](lecture9.assets/image-20220822142038242.png)

![image-20220822142213657](lecture9.assets/image-20220822142213657.png)

![image-20220822142243373](lecture9.assets/image-20220822142243373.png)

## Loader

- Input: Executable Code
- Output: <program is run>



1) Reads executable file's header to determine size of text and data segments
2) Creates new address space for program large enough to hold text and data segments, along with a stack segment
3) Copies instructions and data from executable file into the new address space
4) Copies arguments passed to the program onto the stack
5) Initializes machine registers
   1) Most registers cleared, but stack pointer assigned address of 1st free stack location
6) Jumps to start-up routine that copies program's arguments from stack to register and sets the PC
   1) If main routine returns, start-up routine terminates program with the exit system call

 