- If we have multiple Warps and Warp Shuffles within a block we must have a specific warp typically 0 compute toe total operand (using sum in this case)
- So since warp 0 is going to compute the total sum of the warps it must have a blocking
	- \_\_syncthreads() function will block basically
	- so warp 0 must wait for all other warps to finish then it will calculate the sum
- when using  \_\_syncthreads() it's critical that all the threads in the block execute the function because if we don't then this will cause an infinite loop kinda and the program will hang
- <span style="color:rgb(192, 0, 0)">Note:</span> can't synchronize the threads in a general grid with \_\_syncthreads()

[[CS259]]
