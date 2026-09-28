---
title: unlikely
source: "[[kernel]]"
tags:
  - linux
  - kernel
  - kernel-macro
type: reference
created: 2026-09-27
---
## What is unlikely

`unlikely` is a non-standard macro (popularized by the Linux kernel) that tells the compiler a condition is expected to be false most of the time. It's built on the GCC/Clang builtin `__builtin_expect`, and the compiler uses the hint to lay out code so the common path runs as straight-line fall-through and the rare path is moved out of the way.

## Example / Usage

```c
#include <stdio.h>
#include <stdlib.h>

#if defined(__GNUC__) || defined(__clang__)
  #define likely(x)   __builtin_expect(!!(x), 1)
  #define unlikely(x) __builtin_expect(!!(x), 0)
#else
  #define likely(x)   (x)
  #define unlikely(x) (x)
#endif

int main(void) {
    int *buf = malloc(100 * sizeof *buf);
    if (unlikely(buf == NULL)) {      // allocation failure is rare
        fprintf(stderr, "out of memory\n");
        return 1;
    }
    // hot path continues here
    free(buf);
    return 0;
}
```

## When to Use

Use it on branches that are true only rarely, like error checks, allocation failures, invalid input, or rare edge cases, in performance-sensitive code such as tight loops, kernels, or low-level libraries. It's most worthwhile when profiling shows that branch layout actually matters.

## Watch Out For

A wrong hint can make code slower, so only apply it when the branch is heavily skewed. It isn't standard C and MSVC doesn't support `__builtin_expect`, so wrap it in a portable fallback as shown above. The gains are usually small because modern CPUs predict branches at runtime, and profile-guided optimization (`-fprofile-use`) often beats manual hints. Keep the `!!(x)` so pointers and non-0/1 integers compare correctly against `0` or `1`. Scattering it everywhere also hurts readability without adding speed.