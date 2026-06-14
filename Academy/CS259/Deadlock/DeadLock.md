## <span style="color:rgb(0, 176, 80)">Definition:</span> 
- A situation where two or more processes are blocked indefinitely, each waiting for a resource that is held by another process, leading to a stand sill.

Deadlock is non-deterministic
Hard to debug
No cure for deadlock

## Example
- Assume a system has 4 tape drives and 2 processes. if each process has 2 tape drives and needs a third one in order to proceed, then each will wait for the other i.e. deadlock infinite waiting.

## Four Conditions needed for Deadlock to occur
- <span style="color:rgb(0, 176, 80)">Mutual Exclusion</span>
	- Only one process at a time can use a particular resource. If another process requests that same resource, the process must wait until the resource is released by the first process
- <span style="color:rgb(0, 176, 80)"> Hold and Wait </span>
	- Processes holding resources granted earlier can request new resources. If process must wait for additional resource, it continues to hold onto the resources it currently has
- <span style="color:rgb(0, 176, 80)">No Preemption </span>
	- Resources previously granted to a process cannot be forcibly taken away from the process Resources can only be released voluntarily by the processes that are holding them. Basically can't interrupt.
- <span style="color:rgb(0, 176, 80)">Circular wait</span>
	- There must be a circular chain of 2 or more processes. Each is waiting for a resource held by the next member in the chain
-  <span style="color:rgb(192, 0, 0)">The only resource in the computer system that can be reproductive is the CPU. This allows for preemption basically </span>
- This is because  the CPU is so valuable it's so much more valuable, and much faster than everything else. So it's worth it for the operating system to swap out and swap in just to keep the CPU fully occupied
[[CS259]]