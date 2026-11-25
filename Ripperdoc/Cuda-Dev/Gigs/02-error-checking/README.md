---
title: 02 Error Checking
source: "[[Cuda Dev]]"
tags: [cuda, level-1, exercise]
level: 1
status: not started
created: 2026-11-24
---

# 02 · Error Checking

## Why this gig
The 2026-11-24 quiz showed three gaps. This gig drills all three:
- What a broken program actually does. Most CUDA bugs **don't crash**. They print plausible garbage and exit normally.
- The two kinds of error and how to catch each one: launch errors with `cudaGetLastError()`, execution errors with a sync.
- How to find the line that **caused** an error, when it gets reported somewhere else.

There's no performance target this time. The kernels are trivial; the point is the tools. This should take 30–45 minutes.

## Spec
`cases.cu` holds six small programs. Each one computes `c = a + b` (case 3 computes `c = 2 * (2a + b)`), and each has at least one planted bug. `main.cu` checks the result against the CPU and prints PASS or FAIL.

You'll edit:
- `check.cuh`: write a real `CUDA_CHECK` macro. Right now it's a stub that throws errors away.
- `cases.cu`: add error checks, then fix each bug. Mark each fix with `// FIX: ...`.

Don't edit `main.cu`.

## Steps
1. **Predict first.** Read `cases.cu` and fill in the left half of the table below. Don't run anything yet.
2. **Run with no error checking:** `make run-all`. Note which cases fail, and which ones *pass* even though they're wrong.
3. **Write `CUDA_CHECK`** in `check.cuh`, and add the right checks after every kernel launch. Run `make run-all` again and note which line each error is reported at.
4. **Locate each bug** with the tools, not by staring at the code:
   - `make memcheck C=N`: out-of-bounds reads and writes, with the exact source line
   - `make initcheck C=N`: reads of device memory that was never written
   - `make blocking C=N`: runs with `CUDA_LAUNCH_BLOCKING=1`
   - `make case5`: builds and runs case 5 differently (read the Makefile to see how)
5. **Fix every case.** All six should print PASS, and `make memcheck` and `make initcheck` should be clean for each one.

## Predictions and findings

| Case | Predicted: crash, error, or silent? | Predicted: what's wrong | Actual (no checks) | Error message (with checks) | Reported at line | Tool that found it | Fix |
|---|---|---|---|---|---|---|---|
| 1 | | | | | | | |
| 2 | | | | | | | |
| 3 | | | | | | | |
| 4 | | | | | | | |
| 5 | | | | | | | |
| 6 | | | | | | | |

For case 3 also answer: **which of the three kernels is broken**, and how you proved it.

## Build & run
```bash
make                 # build
make run C=3         # run one case (output appended to test_output.txt)
make run-all         # cases 1-4 and 6
make memcheck C=2    # compute-sanitizer memcheck
make initcheck C=4   # compute-sanitizer initcheck
make blocking C=3    # CUDA_LAUNCH_BLOCKING=1
make case5           # case 5 build + run
make clean
```

## Stretch goals
1. **Sticky errors:** in case 3, after the failing call, try one more `cudaMalloc` and print what it returns. Then do the same after case 1's error. Why does one recover and the other doesn't?
2. **A launch-check macro:** write `KERNEL_CHECK()` that always calls `cudaGetLastError()`, but only syncs when built with `-DDEBUG_SYNC`. Why would you not want a sync after every launch in production code?
3. **Make case 6 work as written,** keeping all 8 stages. Look up `cudaFuncSetAttribute` and `cudaFuncAttributeMaxDynamicSharedMemorySize`. What's the most dynamic shared memory one block can get on sm_86?
4. Run `make initcheck C=1` *before* fixing case 1. What does it report, and why does that make sense?

## Results
| Date | Cases passing | memcheck clean | initcheck clean | Notes |
|---|---|---|---|---|
| | | | | |
