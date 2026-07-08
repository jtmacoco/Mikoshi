---
title: Flynn's Taxonomy
source: "[[Parallel]]"
tags:
type: concept
created: 2026-07-07
---
## What is Flynn's Taxonomy
Four classes of computer architecture based on number of
instruction streams and data streams handled simultaneously.

---

## SISD — Single Instruction Single Data
One instruction, one data stream — purely sequential.

```cpp
int c;
for(int i = 0; i < 100; i++){
    c = a[i] + b[i];  // one operation per cycle = 100 cycles total
}
```
- Traditional single core CPU behavior
- 100 additions = 100 clock cycles

---

## SIMD — Single Instruction Multiple Data
Same instruction applied to many data streams in parallel.

```cpp
c1 = a1+b1   // processor 1
c2 = a2+b2   // processor 2
cN = aN+bN   // processor N — all in 1 cycle
```
- One control unit, many function units
- 100 additions with 100 function units = 1 cycle
- How GPUs and vector instructions (AVX) work

---

## MISD — Multiple Instruction Single Data
Different instructions on the same data simultaneously.
- Generally considered impractical
- **Speculative execution** is the real use case:
  - Game awaiting input (up/down/left/right)
  - Pre-compute all 4 outcomes on 4 cores
  - Whichever input arrives is already computed
  - Useful when cores are cheap and would otherwise sit idle

---

## MIMD — Multiple Instruction Multiple Data
Multiple cores each handling different instructions and data.
Most modern multicore systems fall here.

### Shared Memory MIMD
- All processors access one unified memory
- Cheaper, easier for programmer (one copy of X, everyone knows where it is)
- **Bottleneck:** one memory bus shared across all cores

### Distributed Memory MIMD
- Each processor has its own private memory
- Less hardware bottleneck
- **Harder for programmer:** each process has its own copy of X
- Requires MPI to pass messages between processes
- Synchronization complexity shifts to programmer

### Hybrid Shared + Distributed MIMD
- Each core has its own L1/L2 cache (data + instruction)
- Shared unified L3 cache across cores
- Best of both — reduces bottleneck while keeping some shared state
- Most modern CPUs work this way

---

## When to Use (as mental model)
- Classifying a new architecture or hardware → where does it fall?
- Interview question about parallelism → start with Flynn's
- Deciding CPU vs GPU → SIMD vs MIMD tradeoff

---

## Watch Out For
- MISD is almost never a real answer — mention speculative execution if asked
- MIMD shared memory bottleneck is why cache hierarchies exist
- GPU warps are SIMT (Single Instruction Multiple Threads) — a variant of SIMD
