---
title: 02 Error Checking
source: "[[Cuda Dev]]"
tags: [cuda, level-1, exercise]
level: 1
status: done
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

| Case | Predicted: crash, error, or silent? | Predicted: what's wrong                                | Actual (no checks)                               | Error message (with checks)                                                                                                                                                                                                                                                | Reported at line | Tool that found it                     | Fix                                                                                                                       |
| ---- | ----------------------------------- | ------------------------------------------------------ | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| 1    | silent                              | To many threads per block. No sync threads             | outputs were 0                                   | CUDA Runtime Error: cases.cu:76:1 = invalid argument, cudaGetLastError()<br>  exit code: 1                                                                                                                                                                                 | line 74          | cudaGetLastError runtime               | //FIX: fixed by adjusting the number of threads<br>                                                                       |
| 2    | silent                              | no guarded checks need if statement in the global func | passed                                           | ========= Invalid __global__ read of size 4 bytes<br>=========     at vec_add_unguarded(const float *, const float *, float *, int)+0x80 in cases.cu:18                                                                                                                    | line 18          | compute-sanitizer memcheck             | //FIX: fixed by using the guarded vec_add<br>                                                                             |
| 3    | silent                              | no device sync. Kernel B broken                        | output was garbage -12345                        | Invalid __global__ write of size 4 bytes<br>=========     at vec_add_unguarded(const float *, const float *, float *, int)+0xc0 in cases.cu:18 <br><br>The issue was due to kernel B using an unguarded vec_add as well as changing the n + threads rather than 4n threads | line 109         | compute-sanitizer memcheck proved this | //FIX: by changing to n + threads instead of the original 4n threads<br>    //FIX: fixed by using the guarded vec_add<br> |
| 4    | crash                               | missing malloc for d.b only does d.a                   | output was 1.37454 since the memory was not init | Uninitialized __global__ memory read of size 4 bytes<br>=========     at vec_add(const float *, const float *, float *, int)+0xa0 in cases.cu:12                                                                                                                           | line 12          | Initcech reports uninitaialized read   | //FIX: fixed by copying d.b data<br>                                                                                      |
| 5    | error                               | architecture is wrong in make                          | Ran but used wrong architecture so got 0's       | No kernel image is available for execution                                                                                                                                                                                                                                 | line 148         | compiler/makefile                      | FIX: Fixed by change arch to sm_86<br>                                                                                    |
| 6    | silent                              | need to sync streams                                   | Got 0's, reached end normally though             | === case 6 (n = 1000000) ===<br>========= CUDA API Error: Requested dynamic shared memory size of 65536 bytes exceeds the maximum dynamic shared memory size of 49152 bytes for this launch of this function                                                               | line 164         | compute-sanitizer memcheck             | //FIX: size of smem to what the kernel uses (2 tiles of blockDim.x floats) removed the stages multipler<br>               |

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
| ---- | ------------- | -------------- | --------------- | ----- |
|      |               |                |                 |       |
