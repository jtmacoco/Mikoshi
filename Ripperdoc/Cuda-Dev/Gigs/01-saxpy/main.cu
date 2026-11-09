// Test + benchmark harness for 01-saxpy. You don't need to edit this file.
//
// Usage: ./saxpy [n] [--profile]
//   n          problem size for the benchmark (default 2^27 + 13)
//   --profile  skip edge-case tests and timing; launch the kernel exactly once (for ncu)

#include <algorithm>
#include <cmath>
#include <cstdarg>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <random>
#include <vector>

#include <cuda_runtime.h>
#include "kernel.cuh"

static constexpr double PEAK_BW_GBS = 360.0;  // RTX 3060 spec (progress.md)
static constexpr int    WARMUP_RUNS = 3;
static constexpr int    TIMED_RUNS  = 20;
static constexpr float  A           = 2.5f;

static FILE* g_log = nullptr;

// Print to stdout and test_output.txt.
static void out(const char* fmt, ...) {
    va_list args;
    va_start(args, fmt);
    vprintf(fmt, args);
    va_end(args);
    if (g_log) {
        va_start(args, fmt);
        vfprintf(g_log, fmt, args);
        va_end(args);
        fflush(g_log);
    }
}

#define CUDA_CHECK(call)                                                      \
    do {                                                                      \
        cudaError_t err_ = (call);                                            \
        if (err_ != cudaSuccess) {                                            \
            out("CUDA error: %s\n  at %s:%d\n  in  %s\n",                     \
                cudaGetErrorString(err_), __FILE__, __LINE__, #call);         \
            if (g_log) fclose(g_log);                                         \
            std::exit(EXIT_FAILURE);                                          \
        }                                                                     \
    } while (0)

static void cpu_saxpy(int n, float a, const float* x, float* y) {
    for (int i = 0; i < n; ++i) y[i] = a * x[i] + y[i];
}

static bool verify(const std::vector<float>& ref, const std::vector<float>& got, int n) {
    int bad = 0;
    for (int i = 0; i < n; ++i) {
        float e = ref[i], g = got[i];
        float tol = 1e-5f * std::fabs(e) + 1e-6f;  // GPU may fuse into FMA; CPU may not
        if (!(std::fabs(e - g) <= tol)) {           // written this way so NaN fails
            if (bad < 10) out("  mismatch at i=%d: expected %.7g, got %.7g\n", i, e, g);
            ++bad;
        }
    }
    if (bad) out("  %d / %d elements wrong\n", bad, n);
    return bad == 0;
}

// Runs one problem size. Returns true if the result is correct.
static bool run_case(int n, bool timing) {
    std::mt19937 rng(42);
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);
    std::vector<float> h_x(n), h_y(n), h_ref(n), h_out(n);
    for (int i = 0; i < n; ++i) { h_x[i] = dist(rng); h_y[i] = dist(rng); }
    h_ref = h_y;
    cpu_saxpy(n, A, h_x.data(), h_ref.data());

    size_t bytes = size_t(n) * sizeof(float);
    float *d_x = nullptr, *d_y = nullptr, *d_y0 = nullptr;
    CUDA_CHECK(cudaMalloc(&d_x, bytes));
    CUDA_CHECK(cudaMalloc(&d_y, bytes));
    CUDA_CHECK(cudaMalloc(&d_y0, bytes));  // pristine copy of y, to reset between timed runs
    CUDA_CHECK(cudaMemcpy(d_x, h_x.data(), bytes, cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_y0, h_y.data(), bytes, cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_y, d_y0, bytes, cudaMemcpyDeviceToDevice));

    // Correctness run
    launch_saxpy(n, A, d_x, d_y);
    CUDA_CHECK(cudaGetLastError());       // launch-configuration errors
    CUDA_CHECK(cudaDeviceSynchronize());  // errors during execution
    CUDA_CHECK(cudaMemcpy(h_out.data(), d_y, bytes, cudaMemcpyDeviceToHost));
    bool ok = verify(h_ref, h_out, n);
    out("  n = %-11d %s\n", n, ok ? "PASS" : "FAIL");

    if (ok && timing) {
        cudaEvent_t start, stop;
        CUDA_CHECK(cudaEventCreate(&start));
        CUDA_CHECK(cudaEventCreate(&stop));
        std::vector<float> times;
        for (int r = 0; r < WARMUP_RUNS + TIMED_RUNS; ++r) {
            CUDA_CHECK(cudaMemcpy(d_y, d_y0, bytes, cudaMemcpyDeviceToDevice));  // not timed
            CUDA_CHECK(cudaEventRecord(start));
            launch_saxpy(n, A, d_x, d_y);
            CUDA_CHECK(cudaEventRecord(stop));
            CUDA_CHECK(cudaGetLastError());
            CUDA_CHECK(cudaEventSynchronize(stop));
            float ms = 0.0f;
            CUDA_CHECK(cudaEventElapsedTime(&ms, start, stop));
            if (r >= WARMUP_RUNS) times.push_back(ms);
        }
        std::sort(times.begin(), times.end());
        float med = times[times.size() / 2];
        double moved = 3.0 * double(bytes);  // read x, read y, write y
        double gbs = moved / (med * 1e-3) / 1e9;
        out("\n  Timing (median of %d runs, %d warm-up):\n", TIMED_RUNS, WARMUP_RUNS);
        out("    time        %.3f ms   (min %.3f, max %.3f)\n", med, times.front(), times.back());
        out("    bytes moved %.3f GB\n", moved / 1e9);
        out("    bandwidth   %.1f GB/s  = %.1f%% of %.0f GB/s peak\n", gbs, 100.0 * gbs / PEAK_BW_GBS,
            PEAK_BW_GBS);
        CUDA_CHECK(cudaEventDestroy(start));
        CUDA_CHECK(cudaEventDestroy(stop));
    }

    CUDA_CHECK(cudaFree(d_x));
    CUDA_CHECK(cudaFree(d_y));
    CUDA_CHECK(cudaFree(d_y0));
    return ok;
}

int main(int argc, char** argv) {
    int n = (1 << 27) + 13;
    bool profile = false;
    for (int i = 1; i < argc; ++i) {
        if (std::strcmp(argv[i], "--profile") == 0) profile = true;
        else n = std::atoi(argv[i]);
    }
    if (n <= 0) { fprintf(stderr, "n must be positive\n"); return EXIT_FAILURE; }

    g_log = fopen("test_output.txt", "w");
    cudaDeviceProp prop;
    CUDA_CHECK(cudaGetDeviceProperties(&prop, 0));
    out("Device: %s (sm_%d%d, %d SMs)\n", prop.name, prop.major, prop.minor, prop.multiProcessorCount);

    bool all_ok = true;
    if (profile) {
        out("Profile mode: single launch, n = %d\n", n);
        all_ok = run_case(n, false);
    } else {
        out("\nEdge-case sizes:\n");
        for (int m : {1, 31, 256, 257, 1000003}) all_ok &= run_case(m, false);
        out("\nBenchmark size:\n");
        all_ok &= run_case(n, all_ok);  // only time it if everything passed
    }

    out("\n%s\n", all_ok ? "ALL TESTS PASSED" : "TESTS FAILED");
    if (g_log) fclose(g_log);
    return all_ok ? EXIT_SUCCESS : EXIT_FAILURE;
}
