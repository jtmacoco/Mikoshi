---
title: Warp Divergence
source: "[[Cuda]]"
tags:
  - "#cuda"
  - "#warp"
  - warp-divergence
  - "#reduction"
type: concept
created: 2026-07-08
---

## What is Warp Divergence

A warp is a group of 32 threads the GPU forces to march in lockstep - they all execute the same instruction at the same time. There's no way for the hardware to  have some of them do one thing and other's do the something else, at the same time. 

---

## Example / Usage

```c hl=10-12
__global__ void reduce0(int *g_idata, int *g_odata) {
  extern __shared__ int sdata[];

  unsigned int tid = threadIdx.x;
  unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
  sdata[tid] = g_idata[i];
  __syncthreads();

  for (unsigned int s = 1; s < blockDim.x; s *= 2) {
    if (tid % (2 * s) == 0) { // divergent
      sdata[tid] += sdata[tid + s];
    }
    __syncthreads();
  }
  if (tid == 0)
    g_odata[blockIdx.x] = sdata[0];
}
```


So if an `if/else` inside a warp causes some threads to want the "if" and others to want the "else," the GPU can't run both groups in parallel. Instead it does this:

1. Run the "if" path — the threads that don't need it just sit there doing nothing.
2. Run the "else" path — now the _other_ threads sit there doing nothing.

Total time = time for path A + time for path B, even though only half the threads did useful work in each pass. That's the "divergence" — the warp's single path splits into multiple sequential passes.

---
## Full Divergence Trace of code

- `blockDim.x = 64` → **2 warps**: Warp 0 = tid 0–31, Warp 1 = tid 32–63.
- Condition: thread is **active** if `tid % (2*s) == 0`.
- Loop runs while `s < 64`, doubling each time: `s = 1, 2, 4, 8, 16, 32` → **6 rounds**.
- "Active" = does real work this round. "Idle" = masked off, contributes nothing, but the warp still has to wait for it.

**The one fact that matters:** a warp is only "cheap" when it is _entirely_ active or _entirely_ idle. The moment a warp has a mix of active and idle threads, that warp pays for a full pass regardless of how few threads are actually doing work

## Round 1 — s = 1 (2s = 2)

Active tids: `0, 2, 4, 6, 8, ...` (every even tid)

|Warp|Active tids|Idle tids|Active count|Idle count|Verdict|
|---|---|---|---|---|---|
|Warp 0 (0–31)|0,2,4,...,30|1,3,5,...,31|16|16|**DIVERGENT** — 50/50 interleaved|
|Warp 1 (32–63)|32,34,...,62|33,35,...,63|16|16|**DIVERGENT** — 50/50 interleaved|

Both warps run at half efficiency. Every warp pays the cost.

---

## Round 2 — s = 2 (2s = 4)

Active tids: `0, 4, 8, 12, ...` (every 4th tid)

|Warp|Active tids|Active count|Idle count|Verdict|
|---|---|---|---|---|
|Warp 0|0,4,8,...,28|8|24|**DIVERGENT** — active threads scattered every 4th slot|
|Warp 1|32,36,...,60|8|24|**DIVERGENT** — same pattern|

Still every warp has some active, some idle threads mixed together.

---

## Round 3 — s = 4 (2s = 8)

Active tids: `0, 8, 16, 24, 32, ...` (every 8th tid)

|Warp|Active tids|Active count|Idle count|Verdict|
|---|---|---|---|---|
|Warp 0|0, 8, 16, 24|4|28|**DIVERGENT**|
|Warp 1|32, 40, 48, 56|4|28|**DIVERGENT**|

Only 4 threads per warp doing anything, but the warp still can't skip — it has to check all 32 lanes and run the pass for the 4 that qualify.

---

## Round 4 — s = 8 (2s = 16)

Active tids: `0, 16, 32, 48`

|Warp|Active tids|Active count|Idle count|Verdict|
|---|---|---|---|---|
|Warp 0|0, 16|2|30|**DIVERGENT**|
|Warp 1|32, 48|2|30|**DIVERGENT**|

2 useful threads out of 32, in each warp. Still mixed.

---

## Round 5 — s = 16 (2s = 32)

Active tids: `0, 32`

|Warp|Active tids|Active count|Idle count|Verdict|
|---|---|---|---|---|
|Warp 0|0|1|31|**DIVERGENT**|
|Warp 1|32|1|31|**DIVERGENT**|

Just 1 thread doing work per warp. Both warps still have to be scheduled and run the branch, masking off 31 lanes each.

---

## Round 6 — s = 32 (2s = 64)

Active tids: `0` only

|Warp|Active tids|Active count|Idle count|Verdict|
|---|---|---|---|---|
|Warp 0|0|1|31|**DIVERGENT**|
|Warp 1|—|0|32|**CLEAN — fully idle, can be skipped**|

This is the _first and only_ round in the entire trace where a warp is entirely idle and the hardware can cheaply skip it. Every other round, every warp had a mix.

---

## The blunt summary

|Round|s|Active per warp|Warps with mixed active/idle|Warps fully skippable|
|---|---|---|---|---|
|1|1|16/32|2 of 2|0|
|2|2|8/32|2 of 2|0|
|3|4|4/32|2 of 2|0|
|4|8|2/32|2 of 2|0|
|5|16|1/32|2 of 2|0|
|6|32|1 or 0/32|1 of 2|1 of 2|

**5 out of 6 rounds, both warps are divergent. Zero rounds are efficient until the very last one, and even then only half the warps benefit.**

This is why `tid % (2*s)` is the textbook "bad" version — the modulo scatters active threads evenly through every warp, every round, so there is basically no round where the GPU gets to cheaply skip idle warps.

---
## Analogy

Imagine a **marching band of 32 people** who are contractually required to take the exact same step at the exact same time — left foot, right foot, in perfect sync, always.

Now you shout an instruction: **"If you're wearing red, spin around. Otherwise, clap."**

They can't do both at once — that would break the lockstep rule. So instead:

1. First, everyone takes a "spin" step together — but only the red-shirts actually spin, everyone else just stands there awkwardly pretending to move.
2. Then everyone takes a "clap" step together — but only the non-red-shirts actually clap, and the red-shirts just stand there.

Two full steps consumed to do what could've been one step if everyone agreed. That wasted "standing there pretending" time is exactly what idle/masked-off threads are doing during divergence.

---

## Watch Out For

- If statements
- Switch statements





