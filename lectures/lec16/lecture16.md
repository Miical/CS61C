**Write Hits**

- Wirte-Through Policy
- Write-Back Policy 
  - Dirty bit

**Write misses**

- Write Allocate (paired with write-back)
- No Write Allocate policy (paired with write-through)



## Direct-Mapped Caches

- Each memory block is mapped to exactly one slot in the cache (direct-mapped)
  - Every block has only one "home"
  - Use hash function to determine which slot
- Comparison with fully associative
  - Check just one slot for a block (faster)
  - No replacement policy necessary 
  - Access pattern may leave empty slots in cache

![image-20220902111923910](lecture16.assets/image-20220902111923910.png)

![image-20220902112154453](lecture16.assets/image-20220902112154453.png)

![image-20220902112333797](lecture16.assets/image-20220902112333797.png)

![image-20220902113439771](lecture16.assets/image-20220902113439771.png)

![image-20220902113530311](lecture16.assets/image-20220902113530311.png)

## Set Associative Caches

`N-way set-associative`: Divide $ into sets, each of which consists of N slots

- Memory block maps to a set determined by index field and is placed in any of the N slots of that set 
- Call N the associativity
- Replacement pollicy applies to every set

![image-20220902114104447](lecture16.assets/image-20220902114104447.png)



