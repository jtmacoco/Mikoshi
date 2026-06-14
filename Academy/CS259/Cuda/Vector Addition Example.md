```c++ title:vector-addition
#include <stdio.h>
#include <cuda.h>
__global__ void Vec_add(const float x[], const float y[], float z[], const int n){
    int my_elt = blockDim.x*blockIdx.x+threadIdx.x;
    if(my_elt<n){
        z[my_elt] = x[my_elt] + y[my_elt];
    }

}
```
- So line 4 computes a unique global rank basically
	- needs to be globally unique since if we have multiple blocks, each block has it's own amount of threads, these threads on different blocks can have the same id, so we create a global id to avoid any collisions 
- line 5 ensures prevents out of bound memory access
	- If the total number of threads is bigger than n(number of elements in the array) then we have extra threads those threads would access memory out of bounds
	- An example of the table for global unique ranks is below, which should help clarify this check

|            | ThreadId.x |     |     |     |     |
| ---------- | ---------- | --- | --- | --- | --- |
| blockIdx.x | 0          | 1   | 2   | 3   | 4   |
| 0          | 0          | 1   | 2   | 3   | 4   |
| 1          | 5          | 6   | 7   | 8   | 9   |
| 2          | 10         | 11  | 12  | 13  | 14  |
| 3          | 15         | 16  | 17  | 18  | 19  |

- In the table this would be as if having 4 blocks each with 5 threads. 
- Notice how if N(number of elements) was only 18 then threads 18 (0 indexing) and 19 when trying to access the array x and y would be out of bounds so essentially what line 5 does is make sure that this won't happen
- So to re-iterate basically line 5's check is a memory bound
- The function cudaMallocManaged() allocates for both the host and device
- The function cudaMalloc only allocates memory on the device


[[CS259]]