## Prevention of condition 1 (Mutual Exclusion)
- Can't really prevent since some resources are inherently non-sharable
- <span style="color:rgb(112, 48, 160)">Analogy:</span> Think of a printer, when printing someone is printing only they can print so one at a time basically
- So if designed a computer system to without mutual exclusion, then multiple people could print at the same time making it really hard to find your output, since everything would be jumbled together. 
- Another example of why this can't really work is if 2 process write a file, we don't want them both writing to the same file at the same time since we could get different outputs.

## Prevention of Condition 3 (No Preemption)
- Now we can interrupt process's while doing work
- So now if printing and half way through printing process B takes control of the printer, the first process (A). This doesn't really work since the output would be pretty messy
## Prevention of Condition 2 (Hold and Wait)
- Can we design a system that doesn't need hold and wait
- So we can kind of by pre-allocation
- So think of this like a shopping cart/list where we have a list of all the items we want to put in the shopping cart. So what the OS is going to do is it's going to go around the computer system which will take time but when a resource becomes available and it's on your list, the OS is going to put that resource in your shopping cart. Now don't run yet, since we have to wait until we have all the items/resources from the list.
- Another way to think is instead of having traffic on the free way we only let one person go on the free way during rush hour, so that person is really happy since they get the freeway all to themselves but the other 10,000 people aren't happy since they have to wait for that person to be done using the freeway
- So this is sequential basically and very inefficient but technically it is a solution 
	- Meaning each process must wait until all of it's resources are available
	- This is wasteful since resources only used for a short period of time must be allocated to the process for the entire jobs life time 
	- Some resources unavailable for long periods of time

## Prevention of Condition 4 (Circular wait)
- Yes we can technically prevent this but it's not practical
- This is called hierarchical or standard allocation pattern. 
	- Basically a one way street
- Label all the resources and the we set a rule that process's can only access other processes in ascending order. 
- It's also like you can't go backwards only forward

<span style="color:rgb(192, 0, 0)">NO REAL PRARTICAL SOLUTION TO THIS</span> 
[[DeadLock]]
