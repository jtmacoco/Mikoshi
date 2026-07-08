---
title: Blocks
source: "[[Cuda]]"
tags:
  - "#parallel"
  - "#cuda"
type: concept
created: 2026-07-07
---

## What is Blocks

A block is an ordered group of threads executed by a Streaming Multiprocessor (SM). Each thread is identified by a unique ID based on the position within this block.

Blocks can never have more than 1024 threads.

---

## Example / Usage

```c
__global__ void sum(float *a)
{
        int idx = blockDim.x*blockIdx.x+threadIdx.x;
	    float val = a[idx];
     	__shared__ float shared_mem[8];
    	for (int offset = 16; offset > 0; offset /= 2) {
        	val += __shfl_down_sync(0xffffffff, val, offset);    
    	}
    	if(threadIdx.x%warpSize==0) {
        	shared_mem[threadIdx.x>>5]=val;
    	}
    	__syncthreads();
    	if (threadIdx.x<8) {
        	val=shared_mem[threadIdx.x];
        	val += __shfl_down_sync(0xffffffff, val, 4);    
        	val += __shfl_down_sync(0xffffffff, val, 2);    
        	val += __shfl_down_sync(0xffffffff, val, 1);
        	if (threadIdx.x==0) {
            	a[0]=val;
            	}
        }
}
```

---

## When to Use


---

## Watch Out For





