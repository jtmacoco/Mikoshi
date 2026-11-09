# 01-saxpy — RTX 3060 (sm_86)
NVCC      ?= nvcc
ARCH      ?= sm_86
NVCCFLAGS := -O3 -lineinfo -std=c++17 -arch=$(ARCH)

TARGET := saxpy
SRCS   := main.cu kernel.cu
N      ?=            # optional: make run N=1000000

.PHONY: all run check profile profile-full ptxas clean

all: $(TARGET)

$(TARGET): $(SRCS) kernel.cuh
	$(NVCC) $(NVCCFLAGS) -o $@ $(SRCS)

# Edge-case tests + benchmark; output also saved to test_output.txt
run: $(TARGET)
	./$(TARGET) $(N)

# Out-of-bounds / invalid access check (smaller n: the sanitizer is slow)
check: $(TARGET)
	compute-sanitizer --tool memcheck ./$(TARGET) 1000003

# Key ncu sections printed to the terminal
profile: $(TARGET)
	ncu --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy \
	    -k regex:saxpy ./$(TARGET) $(N) --profile

# Full report saved to saxpy.ncu-rep (open with ncu-ui)
profile-full: $(TARGET)
	ncu --set full -k regex:saxpy -o saxpy -f ./$(TARGET) $(N) --profile

# Registers / shared memory / spills per kernel
ptxas:
	$(NVCC) $(NVCCFLAGS) -Xptxas -v -c kernel.cu -o /dev/null

clean:
	rm -f $(TARGET) *.ncu-rep test_output.txt
