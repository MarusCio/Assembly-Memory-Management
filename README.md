# Assembly-Memory-Management

This project simulates memory management in two cases: **one-dimensional memory** (a linear vector of blocks) and **two-dimensional memory** (a matrix of blocks).

It emulates how an operating system manages files on a disk by implementing key operations:

- **Add** -> inserts a file into the first continuous free memory section.
- **Get** -> retrieves the memory interval of a file.
- **Delete** -> removes a file and frees its memory blocks.
- **Defragmentation** -> compacts data to eliminate empty spaces.
  - Before Defragmentation: 110000022203
  - After Defragmentation: 112223000000

  
