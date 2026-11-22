#include <cstdio>

__global__ void peek(const float* x) {
    const float4* x4 = reinterpret_cast<const float4*>(x);  // same bytes, viewed 4 floats at a time
    int j = threadIdx.x;                                     // thread j owns float4 #j
    float4 v = x4[j];                                        // ONE 16-byte load
    printf("thread %d: x4[%d] = {%.0f, %.0f, %.0f, %.0f}  (= x[%d..%d])\n",
           j, j, v.x, v.y, v.z, v.w, 4*j, 4*j+3);
}

int main() {
    const int n = 10;
    float h[n]; for (int i = 0; i < n; i++) h[i] = i;        // x = 0,1,2,...,9
    float* d; cudaMalloc(&d, n * sizeof(float));
    cudaMemcpy(d, h, n * sizeof(float), cudaMemcpyHostToDevice);
    printf("cudaMalloc address %% 16 = %zu (0 means float4-aligned)\n", (size_t)d % 16);
    peek<<<1, n / 4>>>(d);        // 10 / 4 = 2 threads; x[8], x[9] are the tail, NOT read here
    cudaDeviceSynchronize();
    cudaFree(d);
}
