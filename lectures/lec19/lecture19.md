**Virtual Memory**

**Address Space**

![image-20220904150049702](lecture19.assets/image-20220904150049702.png)



# Address Translation

Given a request for an address (virtual) we have to locate the data in physical memory.

The process of converting a virtual address to a physical address is called address translation!

 ![image-20220904153145603](lecture19.assets/image-20220904153145603.png)

![image-20220904153604544](lecture19.assets/image-20220904153604544.png)



**Page Table Entry Format**

- Contains either PPN or indication not in main memory
- Dirty = Page has been modified recently
- Valid = Valid page tale entry
  - 1 -> virtual page is in physical memroy
  - 0 -> OS needs to fetch page from disk Page Fault
- Access Rights checked on every access to see if allowed 
  - Read
  - Write 
  - Executable: Can fetch instructions from page
  - Protection Fault

![image-20220904154105880](lecture19.assets/image-20220904154105880.png)



![image-20220904160212420](lecture19.assets/image-20220904160212420.png)

![image-20220904160512254](lecture19.assets/image-20220904160512254.png)

![image-20220904160559206](lecture19.assets/image-20220904160559206.png)

![image-20220904160848590](lecture19.assets/image-20220904160848590.png)

![image-20220904161058171](lecture19.assets/image-20220904161058171.png)



Build a separate cache for the page table

- For historical reasons, cache is called a Translation Lookaside Buffer (TLB)
- Notice that what is stored in the TLB is NOT memory data, but the VPN -> PPN mappings

![image-20220904161631881](lecture19.assets/image-20220904161631881.png)

![image-20220904161806683](lecture19.assets/image-20220904161806683.png)

![image-20220904171755385](lecture19.assets/image-20220904171755385.png)

![image-20220904171909274](lecture19.assets/image-20220904171909274.png)

 ![image-20220904172411185](lecture19.assets/image-20220904172411185.png)

![image-20220904172658171](lecture19.assets/image-20220904172658171.png)

![image-20220904173133418](lecture19.assets/image-20220904173133418.png)

![image-20220904173249552](lecture19.assets/image-20220904173249552.png)