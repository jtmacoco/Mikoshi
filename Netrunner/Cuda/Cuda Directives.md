---
title: Cuda Directives
source: "[[Cuda]]"
tags:
  - cuda
  - cheatsheat
type: cheatsheet
created: 2026-07-07
---

## Function Execution Space Qualifiers

|Qualifier|Runs on|Callable from|Notes|
|---|---|---|---|
|`__global__`|Device|Host (or device, w/ dynamic parallelism)|Kernel entry point; must return `void`; launched with `<<<...>>>`|
|`__device__`|Device|Device only|Regular device function, inlined or not|
|`__host__`|Host|Host only|Default if no qualifier given|
|`__host__ __device__`|Both|Both|Compiler generates two versions|
|`__noinline__`|—|—|Hint: don't inline this `__device__` function|
|`__forceinline__`|—|—|Hint: force inlining|
|`__global__ void f() __launch_bounds__(maxThreads, minBlocks)`|—|—|Controls register usage / occupancy|

## Variable Memory Space Qualifiers

|Qualifier|Memory|Scope / Lifetime|
|---|---|---|
|`__device__`|Global memory|Grid / application lifetime|
|`__constant__`|Constant memory|Grid / application lifetime, read-only on device|
|`__shared__`|Shared memory|Block lifetime, shared by all threads in block|
|`__managed__`|Unified memory|Accessible from host & device, auto-migrated|
|`__restrict__`|—|Pointer aliasing hint (like C99 `restrict`)|

## Kernel Launch Syntax

```cpp
kernel<<<gridDim, blockDim, sharedMemBytes, stream>>>(args...);
```

|Param|Type|Meaning|
|---|---|---|
|`gridDim`|`int` or `dim3`|Number of blocks per grid|
|`blockDim`|`int` or `dim3`|Number of threads per block|
|`sharedMemBytes`|`size_t` (optional)|Extra dynamic shared memory per block (bytes)|
|`stream`|`cudaStream_t` (optional)|Stream to enqueue kernel on|

## Built-in Variables (inside `__global__`/`__device__`)

|Variable|Type|Meaning|
|---|---|---|
|`threadIdx`|`uint3`|Thread index within block (.x/.y/.z)|
|`blockIdx`|`uint3`|Block index within grid|
|`blockDim`|`dim3`|Block dimensions (threads per block)|
|`gridDim`|`dim3`|Grid dimensions (blocks per grid)|
|`warpSize`|`int`|Threads per warp (32 on all current GPUs)|

Common global thread index (1D):

```cpp
int idx = blockIdx.x * blockDim.x + threadIdx.x;
```

## Synchronization

|Directive|Scope|Purpose|
|---|---|---|
|`__syncthreads()`|Block|Barrier — all threads in block wait|
|`__syncthreads_count(pred)`|Block|Barrier + count threads where pred != 0|
|`__syncthreads_and(pred)`|Block|Barrier + AND of predicates|
|`__syncthreads_or(pred)`|Block|Barrier + OR of predicates|
|`__syncwarp(mask=0xffffffff)`|Warp|Barrier for threads in warp mask|
|`cudaDeviceSynchronize()`|Host call|Wait for all device work to finish|
|`cudaStreamSynchronize(stream)`|Host call|Wait for a specific stream|
|`__threadfence()`|Device|Ensures writes visible to all threads in grid|
|`__threadfence_block()`|Device|Ensures writes visible within block|
|`__threadfence_system()`|Device|Ensures writes visible to host + all devices|

## Atomic Functions (device)

```cpp
atomicAdd(&addr, val);      atomicSub(&addr, val);
atomicExch(&addr, val);     atomicMin(&addr, val);
atomicMax(&addr, val);      atomicInc(&addr, bound);
atomicDec(&addr, bound);    atomicCAS(&addr, compare, val);
atomicAnd(&addr, val);      atomicOr(&addr, val);
atomicXor(&addr, val);
```

Supported on `int`, `unsigned int`, `unsigned long long`, and (for Add) `float`/`double` on newer architectures.

## Warp-Level Primitives

|Function|Purpose|
|---|---|
|`__shfl_sync(mask, var, srcLane)`|Broadcast/read var from another lane|
|`__shfl_up_sync(mask, var, delta)`|Shift value up within warp|
|`__shfl_down_sync(mask, var, delta)`|Shift value down within warp|
|`__shfl_xor_sync(mask, var, laneMask)`|Butterfly exchange (reductions)|
|`__ballot_sync(mask, pred)`|Bitmask of lanes where pred is true|
|`__all_sync(mask, pred)`|True if pred true for all active lanes|
|`__any_sync(mask, pred)`|True if pred true for any active lanes|
|`__activemask()`|Mask of currently active lanes|

## Memory Fence / Cache Hints

|Directive|Meaning|
|---|---|
|`__ldg(ptr)`|Load through read-only data cache|
|`#pragma unroll [n]`|Unroll following loop (fully, or by n)|
|`#pragma unroll 1`|Prevent unrolling|

## Vector Types

```cpp
int2, int3, int4      float2, float3, float4
uint2, uint3, uint4    double2, double3, double4
// construct with make_TYPE(...):
float4 v = make_float4(1.0f, 2.0f, 3.0f, 4.0f);
```

## Math / Intrinsic Function Prefixes

|Prefix|Meaning|
|---|---|
|`__fadd_rn`, `__fmul_rn`, etc.|Fast, rounded intrinsic math ops|
|`__expf`, `__logf`, `__sinf`, `__cosf`|Fast approximate single-precision math|
|`__fdividef(x,y)`|Fast approximate float division|
|`__saturatef(x)`|Clamp to [0,1]|
|`rsqrtf`, `sqrtf`, `powf`|Standard precision math (slower, more accurate)|

## Error Handling (host-side)

```cpp
cudaError_t err = cudaMalloc(&d_ptr, size);
if (err != cudaSuccess) {
    printf("CUDA error: %s\n", cudaGetErrorString(err));
}
```

Common macro pattern:

```cpp
#define CUDA_CHECK(call) \
    do { cudaError_t e = (call); \
         if (e != cudaSuccess) { \
            fprintf(stderr, "CUDA error %s:%d: %s\n", \
                    __FILE__, __LINE__, cudaGetErrorString(e)); \
            exit(1); } \
    } while (0)
```

## Memory Management (host API)

|Function|Purpose|
|---|---|
|`cudaMalloc(&ptr, size)`|Allocate device global memory|
|`cudaFree(ptr)`|Free device memory|
|`cudaMallocManaged(&ptr, size)`|Allocate unified memory|
|`cudaMemcpy(dst, src, size, kind)`|Copy memory; `kind` = `cudaMemcpyHostToDevice`, `DeviceToHost`, `DeviceToDevice`, `HostToHost`|
|`cudaMemcpyAsync(...)`|Async copy on a stream|
|`cudaMemset(ptr, val, size)`|Set device memory|
|`cudaMallocHost(&ptr, size)`|Allocate pinned (page-locked) host memory|

## Compiler Pragmas / Attributes

|Directive|Purpose|
|---|---|
|`#pragma unroll`|Loop unrolling hint (see above)|
|`__align__(n)`|Force alignment of a struct/variable|
|`__launch_bounds__(maxThreads, minBlocksPerSM)`|Occupancy/register tuning on a kernel|
|`extern "C"`|Disable C++ name mangling for kernel symbols|

---

_Reference target: CUDA C++ Programming Guide (NVIDIA). Intrinsics and support vary by compute capability — check `nvcc --list-gpu-arch` / architecture docs for availability on your target GPU._