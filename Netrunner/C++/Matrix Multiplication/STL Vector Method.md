---
title: STL Vector Method
source: "[[C++]]"
tags:
  - cpp
  - matrix-multiplication
type: concept
created: 2026-07-06
---

## What is STL Vector Method

C++ style for performing matrix multiplication

---

## Example / Usage

```c++
#include <iostream>
#include <vector>
using namespace std;

using Matrix = vector<vector<float>>;

Matrix matmul1(const Matrix &A, const Matrix &B){
	int N = A.size();
	Matrix C(N, vector<float>(N,0.0f));
	for(int row = 0; row < N; row++){
		for(int col = 0; col < N; col++)
		{
			float sum = 0.0f;
			for(int k = 0; k < N; k++){
				sum+=A[row][k]*B[k][col];
			}
			C[row][col] = sum;
		}
	}
	return C;
}
int main(){
	cout<<"C++ STYLE"<<endl;
	Matrix A = {
		{1.0f, 2.0f},
		{3.0f, 4.0f},

	};
	Matrix B = {
		{5.0f, 6.0f},
		{7.0f, 8.0f},

	};
	Matrix res1 = matmul1(A,B);
	for(int i = 0; i < res1.size();i++){
		for(int j = 0; j < res1.size();j++){
			cout<<res1[i][j] << " ";
		}
		cout<<endl;
	}
}
```

---

## When to Use

Use this when doing simple prototyping in C++

---

## Watch Out For

- Make sure indexing is correct





