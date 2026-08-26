---
title: Cuda-Matrix-Mult
source: "[[cuda]]"
tags:
  - cuda
  - matrix-multiplication
type: concept
created: 2026-08-24
---

## What is Cuda-Matrix-Mult

Matrix multiplication with cuda using tiles

---
## Tiling Setup Visualization 

![[Cuda-Matrix-Mult-20260824220402943.svg]]

```html-embed
Mikoshi/Netrunner/Cuda/Cuda_Assets/matmul_tile_animation.html
800

```
- Issue with launching threads right now as will have memory issue with shared memory since more threads than the size of the tile block