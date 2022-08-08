# Basic C Concepts

## Complilation

C is a compiled language

- Execellent run-time performance
- Fair compilation time: enhancements in compilation procedure (Makefiles) allow us to recompile only the modified files

## Variable Types

**Unions in C**

```c
union foo {
  int a;
  char b;
  union foo *c;
}
// provides enough space for the largest element
```

![image-20220808102158779](lecture2.assets/image-20220808102158779.png)

# C Syntax and Control Flow

![image-20220808102248941](lecture2.assets/image-20220808102248941.png)

We use "C99" or "C9x" std

Use option "gcc -std=c99" at compilation

**Highlights:**

- <inttypes.h> for explicit integer types
- <stdbool.h> for boolean logic definition

# Pointers

Careful