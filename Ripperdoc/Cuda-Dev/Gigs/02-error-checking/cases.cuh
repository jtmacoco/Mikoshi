#pragma once
#include <vector>

// Each case computes c = a + b (case 3: c = 2 * (2a + b)) and copies c back into h_c.
// Each one has at least one planted bug.
void case1(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c);
void case2(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c);
void case3(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c);
void case4(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c);
void case5(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c);
void case6(const std::vector<float>& h_a, const std::vector<float>& h_b, std::vector<float>& h_c);
