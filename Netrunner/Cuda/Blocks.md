---
title: Blocks
source: "[[Cuda]]"
tags:
  - "#parallel"
  - "#cuda"
type: concept
created: 2026-07-07
---
# What is a Block

A block is a group of threads that run together on one SM. Each thread in a block has a unique ID (`threadIdx`), and blocks themselves have an ID too (`blockIdx`), so every thread can figure out its position in the whole grid.

- A block always runs on exactly one SM (it never gets split across SMs).
- Threads in the same block can share data through `__shared__` memory and sync with `__syncthreads()`.
- Blocks can never have more than 1024 threads.
- Blocks run independently of each other — you can't rely on a specific order between blocks, or on one block "seeing" another block's data (unless you go back through global memory).

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
This example sums values within a block: each warp reduces its own values with `__shfl_down_sync`, writes one partial sum to shared memory, then the first warp reduces those partial sums into a single total.

---

## When to Use

- Whenever you launch a kernel — you always think in terms of blocks and grids (`kernel<<<numBlocks, threadsPerBlock>>>`).
- Pick a block size when threads need to cooperate (share data via `__shared__` memory, or sync via `__syncthreads()`), since only threads in the same block can do that.
- Use multiple blocks to scale your work across the whole GPU — more blocks means more SMs can be kept busy in parallel.

---

## Watch Out For

- **Max 1024 threads per block** — hardware limit, kernel launch fails if you exceed it.
- **No guaranteed order between blocks** — don't write code that assumes block 0 finishes before block 1 starts.
- **No syncing across blocks** — `__syncthreads()` only works within a block; there's no built-in way to sync all blocks in a grid (would need a new kernel launch, or cooperative groups).
- **Block size should be a multiple of 32** — otherwise the last warp in the block wastes lanes (ties back to your Warps notes).
- **Resource limits per block** — shared memory and register usage per block limit how many blocks can run concurrently on one SM.

