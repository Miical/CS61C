# Arrays

**Pointing to Different Size Objects**

- we actually want "word alignment"

  - some processors will not allow you to address 32b values without being on 4 byte boundaries
  - Others will just be very slow if you try to access "unaligned" memory.

  ![image-20220810135713027](lecture3.assets/image-20220810135713027.png)



**Struct Alignment**

![image-20220810135905225](lecture3.assets/image-20220810135905225.png)

![image-20220810135913495](lecture3.assets/image-20220810135913495.png)

![image-20220810140933044](lecture3.assets/image-20220810140933044.png)



**Arrays and Functions**

![image-20220810141537600](lecture3.assets/image-20220810141537600.png)