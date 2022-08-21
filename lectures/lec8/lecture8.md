# RISC-V Instruction Formats

## Stored-Program Concept

- Instructions can be represented as bit patterns
  - Entire programs stored in memory just like data
  - Reprogramming just takes rewriting memory
    - Rather than rewiring the computer
- Known as "Von Neumann" computers after widely distributed tech report on EDVAC project

**Binary compatibility**

Programs are distributed in binary form

- Bound to a specific instruction set

New machines in the same family want to run old programs as well as programs using new instructions

- Leads to "backwards-compatible" instruction set growing over time 

![image-20220821105522523](lecture8.assets/image-20220821105522523.png)

![image-20220821105710650](lecture8.assets/image-20220821105710650.png)

![image-20220821105838213](lecture8.assets/image-20220821105838213.png)

![image-20220821110011033](lecture8.assets/image-20220821110011033.png)

## R-Format

![image-20220821110402405](lecture8.assets/image-20220821110402405.png)

![image-20220821123249766](lecture8.assets/image-20220821123249766.png)

![image-20220821123912683](lecture8.assets/image-20220821123912683.png)



## I-Format 

![image-20220821124316279](lecture8.assets/image-20220821124316279.png)

![image-20220821124552480](lecture8.assets/image-20220821124552480.png)

![image-20220821124904495](lecture8.assets/image-20220821124904495.png)

![image-20220821125237423](lecture8.assets/image-20220821125237423.png)

## S-Format

![image-20220821130250302](lecture8.assets/image-20220821130250302.png)

![image-20220821130505818](lecture8.assets/image-20220821130505818.png)

## SB-Format

- `beq, bne, beg, blt`
  - Need to specify an address to go to 
  - Also take two registers to compare
  - Doesn't write into a register (similar to stores)
- How to encode label

 ![image-20220821130735898](lecture8.assets/image-20220821130735898.png)

![image-20220821134256666](lecture8.assets/image-20220821134256666.png)

 ![image-20220821134406761](lecture8.assets/image-20220821134406761.png)



![image-20220821135154751](lecture8.assets/image-20220821135154751.png)



## U-Format

![image-20220821140709459](lecture8.assets/image-20220821140709459.png)

![image-20220821140831127](lecture8.assets/image-20220821140831127.png)

![image-20220821140906627](lecture8.assets/image-20220821140906627.png)

![image-20220821141245774](lecture8.assets/image-20220821141245774.png)

## UJ-Format

![image-20220821141401576](lecture8.assets/image-20220821141401576.png)

![image-20220821141729022](lecture8.assets/image-20220821141729022.png)

![image-20220821142907104](lecture8.assets/image-20220821142907104.png)

## Summary

![image-20220821144109622](lecture8.assets/image-20220821144109622.png)

![image-20220821144145693](lecture8.assets/image-20220821144145693.png)