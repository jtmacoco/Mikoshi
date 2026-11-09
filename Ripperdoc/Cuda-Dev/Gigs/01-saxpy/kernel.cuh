#pragma once

// Computes y[i] = a * x[i] + y[i] for 0 <= i < n, on device pointers.
void launch_saxpy(int n, float a, const float* d_x, float* d_y);
