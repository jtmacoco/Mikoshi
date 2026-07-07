---
title: Row Major Flat Array
source: "[[C++]]"
tags:
  - "#cpp"
  - matrix-multiplication
type: reference
created: 2026-07-06
---

## What is Row Major Flat Array

2D matrix stored as a 1D flat array.
Access element at row i, col j via : `A[i * N + j]`


---

## Example / Usage

```c++
float *matmul3(float *A, float *B, float *C, int M, int K, int N){
	for (size_t i = 0; i < M; i++){
		for (size_t k = 0; k < K; k++){
			float a_val = A[i * K + k];
			for (size_t j = 0; j < N; j++){
				float b_val = B[k * N + j];
				C[i * N + j] += a_val * b_val;
			}
		}
	}
	return C;

}
```

---
## Why it's faster

- Data is contiguous in memory
- CPU prefetcher loads next elements automatically
- No pointer chasing unlike Raw pointer method
- Cache lines are used efficiently

---

## When to Use

- Performance critical applications
- GPU/CUDA prep (this is how CUDA expects matries)
- Large matrix operations

---

## Watch Out For

- Manual index match `i * N + j` 
- No bounds checking
- Must track dimensions separately 




