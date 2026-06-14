- This is also known as a bounded buffer system
## <span style="color:rgb(112, 48, 160)">Analogy:</span>
- Think of this like cook (producer) and server (consumer)
- So the cook makes the food and then passes that food through the hole in the wall (similar to real life)
- The server goes to the hole  in the wall and picks up the food from the platter and servers the people
- So the cook runs at his open pace (asynchronous) and will keep cooking until the plater in the middle(the hole in the wall) is full, once it's full the cook has to wait, otherwise we would have a buffer overflow
- Now say that the server is faster and servers until the plater in the middle is empty. Once the platter is empty the server must wait otherwise we will have a buffer underflow

## Why do we need 2 semaphores
- The reason we need to is because while empty+full = N in the pictures case this is 2, the semaphores actually do more than just keep track of the number of available resources to consume or not to consume
- The blocking threads independently 
- <span style="color:rgb(112, 48, 160)">Analogy:</span> Say we have a warehouse(buffer) with N shelves:
- empty is like a sign saying "available shelves: X"(producer wait if x== 0)
- full is like a sign saying "filled shelves: y" (consumers wait if y == 0)
- while x+y = n we need both x and y because
	- Workers stocking shelves(produces) only care about the empty
	- Workers picking items (consumers) only care about full
- So the problem with using one semaphore is 
	- No atomic waiting
	- Race condition
	- 
![[producer-consumer.png]]


[[CS259]]
