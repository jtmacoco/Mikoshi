- This typically happens when have global variable or multiple threads/processes try to access this global/shared variable
## <span style="color:rgb(0, 176, 80)">Definition:</span> 
- A potential IPC Problem when 2 ore more processes interact via shared data
- <span style="color:rgb(0, 176, 80)">IPC: </span>  Interprocess communication

## Example:
- You have a bank account with a balance of 100 dollars
- 2 ATMS (ATM1 and ATM 2) try to withdraw 80 dollars at the same time
- Both ATMS try to withdraw at the same time
- So they both read 100 dollars is in the bank
- Now they Both ATMS with draw the 80 dollars since they both read 100 dollars is in the bank account
- So they both write back 20 dollars
- Technically 160 dollars was withdrawn which is bad for the bank
To avoid race conditions need mutually exclusive access to the data

## Solution for race conditions must ensure (Dijkstra)
- No 2 processes can be inside their critical sections at the same time
- No assumptions needed about relative process speeds or number of CPUs
	- This is smart since one of these days since multi-core should be efficient no matter how many CPUs a machine has
- No process stopped outside its critical section can block other processes
- No process can be indefinitely postponed from entering its critical section

## <span style="color:rgb(0, 176, 80)">Critical Section</span>
- when globally shared information is being read or written to or by more than one process
- Should also have termination housekeeping
	- So if something goes wrong we have a way out think of like last resort kind of or fire escape if something goes wrong

[[CS259]]


