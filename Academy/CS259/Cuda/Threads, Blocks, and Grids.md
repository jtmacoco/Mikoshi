- <span style="color:rgb(0, 176, 80)">Grids </span>are a collection of thread blocks started by a kernel(NOT ACTUAL KERNEL)
- <span style="color:rgb(0, 176, 80)">Thread Block (Block)</span> is a collection of threads that run on a single SM
## Built in Variables:
- <span style="color:rgb(0, 176, 80)">threadIdx:</span> the rank or index of the thread in its thread block
- <span style="color:rgb(0, 176, 80)">blockDim:</span> the dimensions, shape, or size of the thread blocks
- <span style="color:rgb(0, 176, 80)">blockIdx:</span> the rank or index of the block within the grid
- <span style="color:rgb(0, 176, 80)">gridDim:</span> the dimensions, shape, or size of the grid
- All of these types have 3 fields x, y, z

## Block vs Grid Dimensions
- Block Dimensions 
	- is the number of threads inside a block
	- controls the parallelism within a block
- Grid Dimensions:
	- Then number of blocks within a grid
	- controls the parallelism across blocks
- <span style="color:rgb(192, 0, 0)">All blocks must have the same dimensions</span>	
- <span style="color:rgb(192, 0, 0)"> CUDA requires that thread blocks be independent</span>
	- Basically one thread block must be able to complete its execution, regardless of the state of the other thread blocks
- Dim3 is a CUDA datatype 

>[!about] Mental Model
> - A thread does one tiny piece of work
> - Threads are grouped into blocks
> - Blocks are grouped into a grid
> - Both blocks and grids can be described in 1d, 2d, or 3d using `dim3`

# How to think about using dimensions

-  1D index (only x) is like giving every apartment one long number
	- apartment `0`
	- apartment `1`
	- apartment `2`
	- etc ... apartment `999`
	- Think like one story apartment but really long like a caterpillar 
- 2D index is like having multiple floors, hallways, rooms
	- floor = `y`
	- room = `x`
- 3D is like building sections
	- building section = `z`
	- floor = `y`
	- room = `x`
	
- **Grid = entire city**
- **Block = neighborhood**
- **Thread = house**

[[CS259]]