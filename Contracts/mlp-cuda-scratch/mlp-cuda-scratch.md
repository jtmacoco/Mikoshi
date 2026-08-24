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



## Stack / Tools

- [ ] C++
- [ ] CUDA


## Progress Log

- [ ] 2026-08-15: Contract initialized
- [ ] 2026-08-15: Working on loading the dataset
- [ ] 2026-08-16: Finished loading dataset
- [ ] 2026-08-16: Working on forward pass
- [ ] 2026-08-17: Initialized Weights finished
- [ ] 2026-08-17: Working on linear forward pass trying to make similar to pytorch
- [ ] 2026-08-18: Made linear it's own object and re-named some files and moved some functions around
- [ ] 2026-08-20: Linear function compiles and works with mlp class, haven't verified if it works
- [ ] 2026-08-20: Working on backend process


## Notes

- **How to figure out number of weights**:  $\text{num\_weights} = \text{in\_feats} \times \text{out\_feats}$
- Read HE paper
- out_feats: means  the number of nodes (neurons) in the layers output
- Each layer in a neural net get's its own initialization
- for `cross_entropy` formula returns $ln(y_i)$ since $t_i$ is 1 and the rest are 0's which zero out the rest so no need to sum (loop) over rest of values
- `log` in c++ is natural log so $ln$

### How to read data big endian

- `bytes[0]` is the _most significant_ byte in the file, so it gets shifted left by 24 bits to become the top byte of the result.
- `bytes[1]` becomes the next byte (shift 16).
- `bytes[2]` becomes the next byte (shift 8).
- `bytes[3]` is the least significant byte (no shift).

The `|` (bitwise OR) then combines all four into one `uint32_t`. This is the standard manual way to parse a big-endian 32-bit value regardless of the host machine's endianness.

## Links
