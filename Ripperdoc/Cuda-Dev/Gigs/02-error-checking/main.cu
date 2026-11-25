// Harness for 02-error-checking. You don't need to edit this file.
//
// Usage: ./errlab <case 1-6>
// Builds inputs with a fixed seed, runs the case, checks c against the CPU,
// and prints PASS/FAIL. Output is also saved to test_output.txt.

#include <cmath>
#include <cstdarg>
#include <cstdio>
#include <cstdlib>
#include <random>
#include <vector>

#include "cases.cuh"

static FILE* g_log = nullptr;

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

using CaseFn = void (*)(const std::vector<float>&, const std::vector<float>&, std::vector<float>&);

struct Case {
    CaseFn fn;
    int    n;
    bool   pipeline;  // case 3 computes 2 * (2a + b)
};

static const Case CASES[] = {
    {case1, 1000000, false},
    {case2, 1000, false},
    {case3, 1 << 24, true},
    {case4, 1000000, false},
    {case5, 1000000, false},
    {case6, 1000000, false},
};

int main(int argc, char** argv) {
    int k = (argc > 1) ? std::atoi(argv[1]) : 0;
    if (k < 1 || k > 6) {
        fprintf(stderr, "usage: %s <case 1-6>\n", argv[0]);
        return EXIT_FAILURE;
    }
    const Case& c = CASES[k - 1];

    g_log = fopen("test_output.txt", "a");
    out("=== case %d (n = %d) ===\n", k, c.n);

    std::mt19937 rng(42);
    std::uniform_real_distribution<float> dist(1.0f, 2.0f);   // never 0, so garbage stands out
    std::vector<float> h_a(c.n), h_b(c.n), h_c(c.n, -12345.0f), ref(c.n);
    for (int i = 0; i < c.n; ++i) {
        h_a[i] = dist(rng);
        h_b[i] = dist(rng);
        ref[i] = c.pipeline ? 2.0f * (2.0f * h_a[i] + h_b[i]) : h_a[i] + h_b[i];
    }

    c.fn(h_a, h_b, h_c);

    int bad = 0;
    for (int i = 0; i < c.n; ++i) {
        float tol = 1e-5f * std::fabs(ref[i]);
        if (!(std::fabs(ref[i] - h_c[i]) <= tol)) {
            if (bad < 5) out("  mismatch at i=%d: expected %.6g, got %.6g\n", i, ref[i], h_c[i]);
            ++bad;
        }
    }
    if (bad) out("  %d / %d elements wrong\n", bad, c.n);
    out("  result: %s\n", bad ? "FAIL" : "PASS");
    out("  (reached the end of main normally)\n\n");
    if (g_log) fclose(g_log);
    return bad ? EXIT_FAILURE : EXIT_SUCCESS;
}
