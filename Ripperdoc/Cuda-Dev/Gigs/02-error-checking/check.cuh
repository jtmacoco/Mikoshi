#pragma once
#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>

// TODO (you): replace this stub with a real CUDA_CHECK macro.
//
// Right now it just runs the call and throws the returned error away,
// which is exactly what code with no error checking does.
//
// Your macro should:
//   1. run `call` once and store its cudaError_t
//   2. if it isn't cudaSuccess, print the error string, the file, the line,
//      and the text of the call itself (hint: the # operator)
//   3. exit with a failure code
//   4. work safely in `if (x) CUDA_CHECK(...); else ...` (hint: do { } while (0))
//
// Then decide what to check right after a kernel launch (Q2/Q4 of the 2026-11-24 quiz).

#define CUDA_CHECK(expr_to_check)               					\
do {											\
	cudaError_t result = expr_to_check;     					\
	if (result != cudaSuccess) {							\
		fprintf(stderr, "CUDA Runtime Error: %s:%i:%d = %s, %s\n", __FILE__,    \
        		__LINE__, result, cudaGetErrorString(result), #expr_to_check);  \
        	exit(EXIT_FAILURE);					                \
	}										\
} while(0)										
