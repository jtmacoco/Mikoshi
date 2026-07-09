---
title: Streaming Multiprocessor (SM)
source: "[[Cuda]]"
tags:
  - "#sm"
  - cuda
type: concept
created: 2026-07-08
---

## What is a Streaming Multiprocessor (SM)

An SM is the core processing unit on a GPU — think of it as a mini-processor that actually runs your threads. A GPU is made up of many SMs (e.g. dozens to over a hundred, depending on the chip), and each SM contains its own compute cores, registers, shared memory, and warp schedulers.

- Blocks get assigned to SMs; an SM can hold multiple blocks at once if it has enough resources.
- Each SM has multiple warp schedulers, which pick ready warps and issue instructions to them every cycle.
- All the parallelism in CUDA ultimately comes down to how many warps an SM can keep busy at once.

---

## Example / Usage

```c
cudaDeviceProp prop;
cudaGetDeviceProperties(&prop, 0);

printf("Number of SMs: %d\n", prop.multiProcessorCount);
printf("Max threads per SM: %d\n", prop.maxThreadsPerMultiProcessor);
printf("Shared memory per SM: %zu bytes\n", prop.sharedMemPerMultiprocessor);
printf("Registers per SM: %d\n", prop.regsPerMultiprocessor);
```
This just queries how many SMs your GPU has and what resources each one offers — useful for reasoning about occupancy (how many blocks/warps can actually fit on an SM at once).

---

## When to Use (i.e. when to *think* about SMs)

- Sizing your kernel launch: total blocks should be enough to keep all SMs busy (rule of thumb: several blocks per SM, not just one block per SM).
- Reasoning about occupancy: how many warps/blocks can fit on one SM depends on that block's shared memory and register usage.
- Debugging performance: if your grid has fewer blocks than there are SMs, some SMs sit idle.

---

## Watch Out For

- **Occupancy limits**: an SM has a fixed amount of registers and shared memory. If each block uses too much of either, fewer blocks can run concurrently on that SM — even if you meant to run more.
- **Too few blocks**: if your grid launches fewer blocks than the GPU has SMs, some SMs get nothing to do — wasted hardware.
- **Not all SMs are "full" all the time**: an SM might be running fewer warps than its max, either due to resource limits or just not enough blocks left to schedule.
- **Architecture differences**: SM count, warp scheduler count, and max threads/warps per SM all vary by GPU generation — always check `cudaGetDeviceProperties` rather than assuming.