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

- [ ] **How to figure out number of weights**:  $\text{num\_weights} = \text{in\_feats} \times \text{out\_feats}$
- [ ] Read HE paper
- [ ] out_feats: means  the number of nodes (neurons) in the layers output
- [ ] Each layer in a neural net get's its own initialization


## How `readBigEndianInt` works



## Links





%% kanban:settings
```
{"kanban-plugin":"board","list-collapse":[null,null,false]}
```
%%