``` cpp {9} title=cuda-hello-world 
#include <stdio.h>
#include <cuda.h>
__global__ void Hello(void){
    printf("Hello from thread %d! \n",threadIdx.x);
}
int main(int argc, char * argv[]){
    int thread_count;
    thread_count = strtol(argv[1],NULL,10);
    Hello<<<1,thread_count>>>();
    cudaDeviceSynchronize();
    return 0;
}
```
- The <<< syntax is the execution configuration for cuda on line 9
- CUDA will handle thread termination automatically
- CUDA kernels are identified by the key word *<span style="color:rgb(192, 0, 0)">__global__</span>
- The way function works is it creates multiple threads that each run the same function the, Hello function in this case, but each thread runs independently with it's own thread id
	- Think of this like multiple works working on the same the same task, but each worker has a different piece of data
- the 1 in the highlighted code section is the number of SM's
	- So we run num of thread_count on 1 SM
	- This is also called a thread block so we would have 1 thread blocks
	


[[CS259]]