Flynn's 4 classes based on number of instruction and data handled
## SISD: Single Instruction, Single Data
- This would be like **<span style="color:rgb(255, 0, 0)">sequential</span>**
- Single instruction and single data where data is a set of data not just one data sample
ex: 
```c++ 
//a and b and c don't really matter what data type the are
int c;
for(int i = 0; i < 100; i++){
c = a[i]+b[i]
}
```
So in the code example this would take 100 clock cycles, essentially sequential

## SIMD: Single Instruction, Multiple Data
- Same instruction is performed on many pieces of different data
- Has one control unit since using the exact same instruction on different data streams
Ex: If we have 100 processors and 100 data sets, and we wanted to add from 0 - 100 each processor could take on a pair (sorry if numbers might be a bit off this is from the image). So similar to the ex above but instead would have something like this:
``` c++
c1 = a1+b1
c2 = a2+b2
...
cN= aN+bN
```
So basically if we have 100 function units that can all add, where each add takes add function unit takes 1 function cycle, then we could add numbers 0-100 in 1 cycle. The reason is because each unit takes 1 function cycle and if they all run in parallel that equates to 1 cycle overall.

## MISD: Multiple Instruction, Single Data
- This is seen as useless or non-sensible
- So different instruction but all on the same data at the same time
	- this is why it's seen as useless
-  Speculative computation could be useful using MISD
Ex: Imagine a video game awaiting 1 of 4 possible user inputs up, down, left, right, we could pre-compute all 4 alternatives on 1 quad-core processor, this would be faster than waiting for the input. BASICALLY just compute all 4 potential inputs and which ever the gamer chooses that input is already computed so it's faster. The reason we do this is because we already have 4 core's and if didn't do this then we would have 3 of the cores sitting idle doing nothing.

Typically done when cores are super cheap

## MIMD: Multiple Data, Multiple Data
- Have multiple cores that can handle multiple data sets
- So each core handles different data sets 
###  Memory MIMD
- We basically have a shared memory system where all processors have direct access to all of the memory. 
- This reduces costs
- Also easier for the programmer, since multiple cores need a value of X they know where X is since shared memory. One copy of x
- <span style="color:rgb(255, 0, 0)">Memory Bottleneck</span> since one memory is shared between all
### Distributed Memory MIMD
- Every processor has their on memory cell (individual memory)
- This is easier on the hardware guy since every process gets it's own memory there is less of a bottleneck 
- But this causes hardship on the programmer, since each process has there memory they will each have their own value of x. Now the programmer doesn't know where x is
- So MPI is used to pass messages between each process.
	- now synchronization problems etc..
- More of the weight to actually get the program running properly relies on this MPI due to lack of shared memory
### Combination Shared & Distributed Memory MIMD
- So we have a cache implemented
	- data cache
	- instruction cache
- Then we have a shared Unified Cache
[[CS259]]