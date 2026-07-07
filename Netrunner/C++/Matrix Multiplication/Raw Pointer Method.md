---
title: Raw Pointer Method
source: "[[C++]]"
tags:
  - cpp
  - matrix-multiplication
type: reference
created: 2026-07-06
---

## What is Raw Pointer Method

C style for performing matrix multiplication, using manual memory allocation 

---

## Example / Usage

```c++ 
float **matmul2(float **A, float **B, int N){
	float **C = new float *[N];
	for (int i = 0; i < N; i++){
		C[i] = new float[N]();
	}
	for(int row = 0; row < N; row++){
		for(int col = 0; col < N; col++){
			float sum = 0;
			for(int k = 0; k < N; k++){
				sum+=A[row][k] * B[k][col];
			}
			C[row][col] = sum;
		}
	}
	return C;
}
int main(){
	int N = 2;
	float **C = new float*[N];	
	C[0] = new float[N]{1.0f,2.0f};
	C[1] = new float[N]{3.0f,4.0f};

	float **D = new float*[N];	
	D[0] = new float[N]{5.0f,6.0f};
	D[1] = new float[N]{7.0f,8.0f};

	float **res2 = matmul2(C,D,N);
	for(int i = 0; i < N; i++){
		for(int j = 0; j < N; j++){
			printf("%f ",res2[i][j]);
		}
		printf("\n");
	}
}
```

---

## When to Use

Mainly use for quick prototypes

---

## Watch Out For

- Pointer arithmetic can mess up on
- Dangling pointers
- Clean up memory 




