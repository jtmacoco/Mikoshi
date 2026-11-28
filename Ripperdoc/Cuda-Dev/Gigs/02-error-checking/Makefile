# 02-error-checking — RTX 3060 (sm_86)
NVCC      ?= nvcc
ARCH      ?= sm_86
NVCCFLAGS := -O3 -lineinfo -std=c++17

TARGET := errlab
SRCS   := main.cu cases.cu
HDRS   := cases.cuh check.cuh
C      ?= 1          # which case: make run C=3

.PHONY: all run run-all memcheck initcheck blocking case5 clean

all: $(TARGET)

$(TARGET): $(SRCS) $(HDRS)
	$(NVCC) $(NVCCFLAGS) -arch=$(ARCH) -o $@ $(SRCS)

# Run one case. Output is appended to test_output.txt.
run: $(TARGET)
	-./$(TARGET) $(C); echo "  exit code: $$?"

# Run cases 1-4 and 6, one after another
run-all: $(TARGET)
	-@for c in 1 2 3 4 6; do ./$(TARGET) $$c; echo "  exit code: $$?"; echo; done

# Tools for locating bugs (pick the case with C=N)
memcheck: $(TARGET)
	-compute-sanitizer --tool memcheck ./$(TARGET) $(C)

initcheck: $(TARGET)
	-compute-sanitizer --tool initcheck ./$(TARGET) $(C)

# Every launch becomes synchronous, so errors surface at the launch that caused them
blocking: $(TARGET)
	-CUDA_LAUNCH_BLOCKING=1 ./$(TARGET) $(C); echo "  exit code: $$?"

# Case 5: the same code, but built for a different GPU architecture
# FIX: Fixed by change arch to sm_86
case5: $(SRCS) $(HDRS)
	$(NVCC) $(NVCCFLAGS) -arch=sm_86 -o $(TARGET)_sm90 $(SRCS)
	-./$(TARGET)_sm90 5; echo "  exit code: $$?"

clean:
	rm -f $(TARGET) $(TARGET)_sm90 test_output.txt
