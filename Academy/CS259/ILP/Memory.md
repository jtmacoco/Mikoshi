- The majority of the time, if not all, we are bound by memory. The CPU can process data very quickly, but if the memory is not where we need it to be, we spend time searching for and retrieving the required data
- Memory is hard to make larger cheaper and faster
- try to have what the CPU needs in the cache

<span style="color:rgb(146, 208, 80)">Spatial Locality Reference</span>:  The next item needed by the CPU will probably be very close in address

- 2 different ways can map a matrix in memory
	- Row Major 
	- Column Major
- Cache is expensive dues to the design of the cache
	- Uses active flip flop gates

- RAM is dynamic cheaper, and simplifier. But it's slower
### <span style="color:rgb(112, 48, 160)">Analogy RAM:</span> 
- Imagine have a cup of water, the cup can hold water but eventually the water will evaporate.
	- In order to check if the cup has any water in it we must dump the cup, so if water came out of the cup then we know it had water else no water came out so the cup was empty
	- Ram is also volatile  since the the water evaporates
	-  Need to top of the cup if at least 3/4 water left in cup so cup is never empty
	- Ram is destructive reading
[[CS259]]