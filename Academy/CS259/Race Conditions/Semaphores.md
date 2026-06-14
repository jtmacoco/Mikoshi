
## <span style="color:rgb(112, 48, 160)">Analogy:</span> 
- A semaphore can act like a gate into a restricted area
- Status of the gate is either open(raised) or closed(lowered)
- When a process needs access, it executes a P operation
	- If gate is open, process enters and closes the gate behind it
	- Otherwise, if the gate is closed, process must wait until gate is reopened. 
- Once process has entered, used shared var, and exits the critical section, it calls V
	- V opens the gate and allows (signals) one waiting process to enter
	- If no processes waiting, gate is left open for the next process needing access
## History
- Dutch words for 'wait' and 'signal' have initials letters P and V respectively.

Once process starts running critical section code it's guaranteed  to go through non interrupting
This is achieved by the OS as it turns off interrupts right before starting P operation and turns them back on again right afterwards

Basically to avoid race conditions global vars should be atomic


The image is from class and shows what P and V are in terms of gates and logic behind them
## Using Semaphores for Rendezvous
- No matter which process reaches the rendezvous point first, it will wait for the other process to catch up before proceeding. 
- This technique allows the two processes to re-synchronize
- two semaphores are required, SEM1 and SME2 both initialized to 0
EX: Rendezvous

| Time | Process | Action  | Waiting | SEM1 | SEM2 |
| ---- | ------- | ------- | ------- | ---- | ---- |
|      |         |         |         | 0    | 0    |
| 1    | A       | V(SEM1) |         |      |      |
|      |         |         |         | 1    | 0    |
| 2    | A       | P(SEM2) |         |      |      |
|      |         |         | A       | 1    | -1   |
| 3    | B       | V(SEM2) |         |      |      |
|      |         |         |         | 1    | 0    |
| 4    | B       | P(SEM1) |         |      |      |
|      |         |         |         | 0    | 0    |

[[CS259]]
![[259_image.jpg]]