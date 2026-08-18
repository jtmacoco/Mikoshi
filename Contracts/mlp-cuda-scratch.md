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
- 2026-08-17: Initialized Weights finished
- 2026-08-17: Working on linear forward pass trying to make similar to pytorch

## Notes

- **How to figure out number of weights**:  $\text{num\_weights} = \text{in\_feats} \times \text{out\_feats}$
- Read HE paper
- out_feats: means  the number of nodes (neurons) in the layers output
- Each layer in a neural net get's its own initialization
```cpp title=example-init
Linear layer1(784, 128);   // initWeights() called ONCE → gives layer1 its own random weights
Linear layer2(128, 64);    // initWeights() called ONCE → gives layer2 its own DIFFERENT random weights
```

- Every layer needs its own initialization since each layer has a completely different set of weights

>[!important] rule of thumb
> Each **weight tensor** (i.e. each layer) gets initialized **exactly once**, at the moment that layer is created — never once per forward pass, but exactly once per layer that exists in your network.


### How `readBigEndianInt` works

```c
bytes[0] = 0x00 → 0x00 << 24 = 0x00000000 bytes[1] = 0x00 → 0x00 << 16 = 0x00000000 bytes[2] = 0x08 → 0x08 << 8 = 0x00000800 bytes[3] = 0x03 → 0x03 = 0x00000003 ---------- OR = 0x00000803 ✓ matches the expected magic number
```



## Links


