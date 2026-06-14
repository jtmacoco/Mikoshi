- <span style="color:rgb(0, 176, 80)">Warp:</span> A is a set of threads with consecutive ranks belonging to a thread block 
	- Typically 32 threads within a warp
	- Different warps can execute different operations
- <span style="color:rgb(0, 176, 80)">Lane:</span> Is the rank of a thread within a warp 
	- calculated via : lane = threadIdx.x % warpSize;
- <span style="color:rgb(192, 0, 0)"> All warps should (basically must) have the same warpSize (max I think is 32 but could change)</span>
- <span style="color:rgb(0, 176, 80)">Warp shuffle functions </span>allow threads to read from registers used by another thread within the same warp
- <span style="color:rgb(0, 176, 80)">Extern</span> means we dynamically allocated shared memory for a kernel
	- This makes it much faster since reading for registers is faster than reading from shared or global memory
	- <span style="color:rgb(112, 48, 160)">Analogy: </span> 
		- Relay Race, so participants are in groups of 32(the **Warp**), each person holding a baton (representing the data stored in a register). Each participant (thread) is racing in lockstep (executing the same instruction at the same time)
		- Passing the baton, where the goal of the race is for each person to pass their baton (data) to the next person in line. However, instead of passing the baton next to them in a traditional race, each person can choose to pass the baton to any other participant in the group
		- Passing in Sync, Every participant (thread) can decide at the same time who they will pass their baton to, and they do so in sync. Each person in the race now holds the baton that was passed to them from another participant in the group
		- Participants can only exchange batons within their group
		- Results, after the baton passing, each participant has a different baton, just as each thread has a new value (the value from another thread's register). This allows threads to share data without needing to rely on slower memory access like shared or global memory.
Example:
``` c++ title:shuffle-down
__device__ float Warp_sum(float var){
    unsigned mask = 0xffffffff;
    for(int diff = warpSize/2; diff > 0; diff = diff/2){
        var+=__shfl_down_sync(mask,var,diff);
    }
    return var;
}
```
- So this loop is like reduce where it's a logarithmic reduction
	- basically /2 every time step
- Starts at diff = warpSize/2 since in a warp reduction we start by combining the results of 2 adjacent threads
- Then continue this patter so keep /2

- Across multiple blocks and using warps, an atomicAdd (if summing) is needed
- atomicAdd not needed across multiple warps
[[CS259]]