---
title: Profiling
source: "[[Cuda]]"
tags:
  - cuda
type: reference
created: 2026-08-02
---
## What is Profiling

- Profiling = measuring *where time and resources actually go* in a program, 
  as opposed to guessing/assuming from reading code.
- For GPU work specifically: figure out whether you're bound by the CPU, 
  the GPU, memory bandwidth, or compute — because the fix is completely 
  different depending on which one it is.
- Two-tool workflow: nsys (wide-angle, system-level) → ncu (microscope, 
  single-kernel). Don't skip straight to ncu — it's expensive to run and 
  you need nsys to tell you *which* kernels are worth the cost.

## Step 1: nsys — where is time going overall?

Order of questions to ask, in order:

1. **Is the GPU even busy, or is this a CPU-bound problem?**
   - Compare cuda_api_sum vs cuda_gpu_kern_sum totals.
   - Huge cudaLaunchKernel time + tiny avg kernel size = launch-overhead-bound,
     not compute-bound. Look at call count, not just %.

2. **Filter out one-time startup noise.**
   - cuLibraryLoadData, first cudaMalloc, initial cudaMemcpy = JIT/context 
     setup/weight load. Happens once — don't chase it as a per-iteration cost.

3. **In cuda_gpu_kern_sum, read shape not just %:**
   - High % + high call count + low stddev → aggregate/fusion problem 
     (many small kernels; fix = fuse kernels or reduce call count).
   - High % + low call count + high per-call cost → single-kernel problem 
     (fix = profile it with ncu).
   - High stddev within one kernel name → shape/branch-dependent 
     (variable seq length, padding) → profile fast vs slow instance separately.

4. **Check memory tables for anything unexpected.**
   - Big one-time H2D copy = weight load, ignore.
   - Repeated large memset = check if it repeats needlessly per-iteration 
     (e.g. KV-cache zeroing).

→ Output of this step: a short list of specific kernel names worth 
  running through ncu.

## Step 2: ncu — why is this specific kernel slow?

Read in this order, every time:

1. **GPU Speed of Light** (read first, always):
   - Memory Throughput vs Compute (SM) Throughput.
   - One near 100%, other low → bound by the high one. This determines 
     the entire category of fix.
   - >80% on either → ncu will literally tell you which one to dig into next.

2. **Occupancy** — sanity check, not the main story:
   - Achieved ≈ Theoretical → scheduler is fine, no launch config issue.
   - ncu's "Est. Local Speedup" from raising occupancy is often *real but 
     secondary* — weigh it against Speed of Light. Raising occupancy barely 
     helps if you're already memory-bound; it mainly helps hide compute/
     latency stalls.

3. **Launch Statistics** — sanity check the shape:
   - Grid/block size, waves per SM. Just confirms nothing pathological 
     (e.g. 1 block total).

4. **Memory Workload Distribution**:
   - L1 → L2 → DRAM throughput escalation. If requests fall through cache 
     to DRAM, low reuse — expected for e.g. GEMV (read-once, low reuse).
   - Tells you *why* it's memory-bound, not just *that* it is.

5. **Run multiple instances / compare**:
   - Consistent times across instances = simple bottleneck.
   - High variance = compare fast vs slow instance directly (ncu has a 
     baseline/compare feature) to find what differs (shape, tile size).

## Mental model: why more threads/occupancy doesn't always help

- Low arithmetic intensity = lots of bytes read, little compute per byte 
  (classic GEMV / decode-step pattern).
- DRAM bandwidth is a hardware ceiling — more warps just queue up waiting 
  on the same saturated bus.
- Analogy: one loading dock (DRAM bandwidth), big workshop floor (SMs). 
  More workers doesn't unload trucks faster.

## Fixes, roughly in order of effort → payoff

1. **Quantization** (fp32→fp16/bf16/int8) — lowest effort, self-contained, 
   immediate win. Halves/quarters bytes moved for memory-bound kernels. 
   Good first move to validate the "memory-bound" diagnosis.
2. **Batching** — turns GEMV into GEMM, low arithmetic intensity → high. 
   Bigger structural win, but system-level change (serving loop, 
   continuous/in-flight batching), not just a kernel swap.
3. **Kernel fusion** — cuts both launch overhead *and* redundant DRAM 
   round-trips between adjacent small kernels (bias+activation+residual 
   fused vs 3 separate reads/writes to DRAM).
4. **Algorithmic/architectural** — speculative decoding, paged/grouped-query 
   attention — attacks the memory-bound nature of autoregressive decode 
   at the model/system level.
5. **Data layout / coalescing** — smaller kernel-level wins, check 
   Memory Workload Analysis for uncoalesced access warnings.

**Rule of thumb:** quantize first (low risk, validates hypothesis, quick), 
then batch (structural fix, bigger payoff). Re-profile after *each* 
change — don't assume gains stack linearly, and batching especially can 
change kernel shapes entirely (new bottlenecks can appear).