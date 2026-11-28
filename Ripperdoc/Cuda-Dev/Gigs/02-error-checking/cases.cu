// 02-error-checking: six small programs, each with planted bugs.
// Your job (see README): predict, run, add error checking, locate, fix.
// Mark each fix with a short comment, e.g. // FIX: ...

#include "cases.cuh"
#include "check.cuh"

// ---------------------------------------------------------------- kernels

__global__ void vec_add(const float* a, const float* b, float* c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) c[i] = a[i] + b[i];
}

// "The grid is sized exactly, so no guard is needed."
__global__ void vec_add_unguarded(const float* a, const float* b, float* c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    c[i] = a[i] + b[i];
}

__global__ void scale(float* x, float s, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) x[i] *= s;
}

// Stages a and b through dynamic shared memory (pointless here, but it uses smem).
__global__ void vec_add_staged(const float* a, const float* b, float* c, int n) {
    extern __shared__ float smem[];        // 2 * blockDim.x floats
    float* sa = smem;
    float* sb = smem + blockDim.x;
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    sa[threadIdx.x] = (i < n) ? a[i] : 0.0f;
    sb[threadIdx.x] = (i < n) ? b[i] : 0.0f;
    __syncthreads();
    if (i < n) c[i] = sa[threadIdx.x] + sb[threadIdx.x];
}

// ---------------------------------------------------------------- helpers

struct Buffers {
    float *a = nullptr, *b = nullptr, *c = nullptr;
    size_t bytes = 0;
};

static Buffers alloc_and_upload(const std::vector<float>& h_a, const std::vector<float>& h_b) {
    Buffers d;
    d.bytes = h_a.size() * sizeof(float);
    CUDA_CHECK(cudaMalloc(&d.a, d.bytes));
    CUDA_CHECK(cudaMalloc(&d.b, d.bytes));
    CUDA_CHECK(cudaMalloc(&d.c, d.bytes));
    CUDA_CHECK(cudaMemcpy(d.a, h_a.data(), d.bytes, cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d.b, h_b.data(), d.bytes, cudaMemcpyHostToDevice));
    return d;
}

static void download_and_free(Buffers& d, std::vector<float>& h_c) {
    CUDA_CHECK(cudaMemcpy(h_c.data(), d.c, d.bytes, cudaMemcpyDeviceToHost));
    CUDA_CHECK(cudaFree(d.a));
    CUDA_CHECK(cudaFree(d.b));
    CUDA_CHECK(cudaFree(d.c));
}

// ---------------------------------------------------------------- cases

// Case 1: vector add, n = 1,000,000.
void case1(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c) {
    int n = (int)h_a.size();
    Buffers d = alloc_and_upload(h_a, h_b);

    //FIX: fixed by adjusting the number of threads
    int threads = 256;
    int blocks  = (n + threads - 1) / threads;
    vec_add<<<blocks, threads>>>(d.a, d.b, d.c, n);
    
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    download_and_free(d, h_c);
}

// Case 2: vector add, n = 1000.
void case2(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c) {
    int n = (int)h_a.size();
    Buffers d = alloc_and_upload(h_a, h_b);

    int threads = 256;
    int blocks  = (n + threads - 1) / threads;
    //FIX: fixed by using the guarded vec_add
    vec_add<<<blocks, threads>>>(d.a, d.b, d.c, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    download_and_free(d, h_c);
}

// Case 3: three-kernel pipeline, n = 2^24.  c = 2 * (2a + b)
void case3(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c) {
    int n = (int)h_a.size();
    Buffers d = alloc_and_upload(h_a, h_b);

    int threads = 256;

    int blocks_a = (n + threads - 1) / threads;
    scale<<<blocks_a, threads>>>(d.a, 2.0f, n);                       // kernel A
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    //FIX: by changing to n + threads instead of the original 4n threads
    int blocks_b = (int)((n + threads - 1) / threads);
    //FIX: fixed by using the guarded vec_add
    vec_add<<<blocks_b, threads>>>(d.a, d.b, d.c, n);       // kernel B
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    int blocks_c = (n + threads - 1) / threads;
    scale<<<blocks_c, threads>>>(d.c, 2.0f, n);                       // kernel C
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    download_and_free(d, h_c);
}

// Case 4: vector add, n = 1,000,000. Uploads by hand instead of using the helper.
void case4(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c) {
    int n = (int)h_a.size();
    Buffers d;
    d.bytes = h_a.size() * sizeof(float);
    CUDA_CHECK(cudaMalloc(&d.a, d.bytes));
    CUDA_CHECK(cudaMalloc(&d.b, d.bytes));
    CUDA_CHECK(cudaMalloc(&d.c, d.bytes));
    CUDA_CHECK(cudaMemcpy(d.a, h_a.data(), d.bytes, cudaMemcpyHostToDevice));
    //FIX: fixed by copying d.b data
    CUDA_CHECK(cudaMemcpy(d.b, h_b.data(), d.bytes, cudaMemcpyHostToDevice));


    int threads = 256;
    int blocks  = (n + threads - 1) / threads;
    vec_add<<<blocks, threads>>>(d.a, d.b, d.c, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    download_and_free(d, h_c);
}

// Case 5: plain correct vector add, n = 1,000,000.
// The code is fine. Build and run it with `make case5` (see the Makefile).
void case5(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c) {
    int n = (int)h_a.size();
    Buffers d = alloc_and_upload(h_a, h_b);

    int threads = 256;
    int blocks  = (n + threads - 1) / threads;
    vec_add<<<blocks, threads>>>(d.a, d.b, d.c, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    download_and_free(d, h_c);
}

// Case 6 (stretch): vector add staged through shared memory, n = 1,000,000.
void case6(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c) {
    int n = (int)h_a.size();
    Buffers d = alloc_and_upload(h_a, h_b);

    //FIX: size of smem to what the kernel uses (2 tiles of blockDim.x floats) removed the stages multipler
    int threads = 256;
    int blocks  = (n + threads - 1) / threads;
    size_t smem = 2 * threads * sizeof(float);
    vec_add_staged<<<blocks, threads, smem>>>(d.a, d.b, d.c, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    download_and_free(d, h_c);
}
