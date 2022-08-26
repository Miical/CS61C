**Today's goal:**

Create a "circuit" of logic elements that, when given an assembly instruction, perform the action the instruction describe

CPU: Central Processing Unit



# What's a CPU?

Your CPU in two parts

- Datapath: contains the hardware necessary to perform operations required by the processor
  - Reacts to what the controller tells it! (Ie. "I was told to do an add, so I'll feed these arguments through an adder")
- Control: decides what each piece of the datapath should do
  - What operation am I performing? Do I need to get info from memory? Should I write to register? Which register? 
  - Has to make decisions based on the input instruction only!

![image-20220826132808196](lecture12.assets/image-20220826132808196.png)



# Building from what we know

## R-Type

```assembly
add a0, a1, a2
```

![image-20220826133808059](lecture12.assets/image-20220826133808059.png)

![image-20220826134852509](lecture12.assets/image-20220826134852509.png)

 ![image-20220826135145647](lecture12.assets/image-20220826135145647.png)

## Arithmetic I-Type

 ![image-20220826135558708](lecture12.assets/image-20220826135558708.png)

![image-20220826135733039](lecture12.assets/image-20220826135733039.png)

## Load I-Type

![image-20220826151339835](lecture12.assets/image-20220826151339835.png)

![image-20220826151158242](lecture12.assets/image-20220826151158242.png)

![image-20220826151654638](lecture12.assets/image-20220826151654638.png)

![image-20220826152426604](lecture12.assets/image-20220826152426604.png)

## S-Type

![image-20220826153216711](lecture12.assets/image-20220826153216711.png)



## SB-Type

![image-20220826153632986](lecture12.assets/image-20220826153632986.png)

![image-20220826160124723](lecture12.assets/image-20220826160124723.png)

![image-20220826160228300](lecture12.assets/image-20220826160228300.png)

## Jumping I-Type

![image-20220826160651985](lecture12.assets/image-20220826160651985.png) 

## J-Type

![image-20220826161101769](lecture12.assets/image-20220826161101769.png)

![image-20220826161128162](lecture12.assets/image-20220826161128162.png)

# Our CPU

![image-20220826161258163](lecture12.assets/image-20220826161258163.png)



# Processor Design Principles

![image-20220826161452595](lecture12.assets/image-20220826161452595.png)

