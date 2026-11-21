#include "kernel.cuh"

// SAXPY: y[i] = a * x[i] + y[i]   for 0 <= i < n
__global__ void saxpy(int n, float a, const float* x, float* y) {
    // TODO: your kernel body.
    //       Remember: n is deliberately NOT a multiple of any block size.
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    if (idx < n)
        y[idx] = a * x[idx] + y[idx];
}

void launch_saxpy(int n, float a, const float* d_x, float* d_y) {
    // TODO: choose a block size and compute a grid size that covers all n elements.
    int threads_per_block = 256;  // TODO
    int num_blocks        = (n+threads_per_block-1)/threads_per_block;  // TODO

    saxpy<<<num_blocks, threads_per_block>>>(n, a, d_x, d_y);
    // (main.cu checks cudaGetLastError() right after this call.)
}
