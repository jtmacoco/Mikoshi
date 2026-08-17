---
title: mlp-cuda-scratch
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-15
status: on-contract
client: personal
deadline:
stack: c, cuda
---

## Objective

Develop an MLP from scratch using C++ and CUDA for the MNIST dataset

## Stack / Tools

- C++
- CUDA

## Progress Log

- 2026-08-15: Contract initialized
- 2026-08-15: Working on loading the dataset
- 2026-08-16: Finished loading dataset
- 2026-08-16: Working on forward pass

## Notes

### How `readBigEndianInt` works

```c
bytes[0] = 0x00 → 0x00 << 24 = 0x00000000 bytes[1] = 0x00 → 0x00 << 16 = 0x00000000 bytes[2] = 0x08 → 0x08 << 8 = 0x00000800 bytes[3] = 0x03 → 0x03 = 0x00000003 ---------- OR = 0x00000803 ✓ matches the expected magic number
```



## Links


