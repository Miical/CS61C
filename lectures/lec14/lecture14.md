# RISC-V Pipeline

# Hazards

![image-20220828210703835](lecture14.assets/image-20220828210703835.png)

## Structural

**Problem:** Two or more instructions in the pipeline compete for access to a single physical resource

**Solution 1:** Instructions take turns using resource, some instructions have to stall 

**Solution 2:** Add more hardware to machine 

![image-20220828211002790](lecture14.assets/image-20220828211002790.png)

Double Pumping: split RegFile access in two! Prepare to write during 1st half, write on falling age, read during 2nd half of each clock cycle

- Will save us a cycle later
- Possible because RegFile access is very fast (takes less than half the time of ALU stage)

![image-20220829101916350](lecture14.assets/image-20220829101916350.png)

![image-20220829103032096](lecture14.assets/image-20220829103032096.png)

![image-20220829102604115](lecture14.assets/image-20220829102604115.png)



## Data

### R-type instructions

![image-20220829104521277](lecture14.assets/image-20220829104521277.png)

 

![image-20220829104649530](lecture14.assets/image-20220829104649530.png)

![image-20220829104808704](lecture14.assets/image-20220829104808704.png)

![image-20220829105920459](lecture14.assets/image-20220829105920459.png)

### Load

![image-20220829124427900](lecture14.assets/image-20220829124427900.png)

![image-20220829124447134](lecture14.assets/image-20220829124447134.png)

 ![image-20220829125825162](lecture14.assets/image-20220829125825162.png)

## Control

![image-20220829130438111](lecture14.assets/image-20220829130438111.png)

  ![image-20220829131720462](lecture14.assets/image-20220829131720462.png)

![image-20220829131918221](lecture14.assets/image-20220829131918221.png)

![image-20220829132538509](lecture14.assets/image-20220829132538509.png) 

# Superscalar processors

![image-20220829133529911](lecture14.assets/image-20220829133529911.png)

![image-20220829133730055](lecture14.assets/image-20220829133730055.png)