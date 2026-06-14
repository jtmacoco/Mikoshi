
- Think Assembly Line
- this  <span style="color:rgb(146, 208, 80)">Microscopic</span>
## <span style="color:rgb(112, 48, 160)">Analogy</span>
-  Say it takes 4 hours for 1 worker to pop out a car from a car factory.
	- 1hr for the frame
	- 1hr for the body
	- 1hr for the engine
	- 1hr for the seats
	- total: 4hr
- Now let's say we have 4 works who special in each area, so 1 for frame, 1 for body, 1 for engine, 1 for seat. This means that each person can constantly work on a car. So as worker 1 is working on the frame work 2 is working on the body and so on. 
- Basically all the workers are working in parallel, making it seem like to the customer that cars are popping out in 1hr.

## Pipeline
- Pipeline has K sages, breaking it up K times
- Introduce overhead when pipelining
## Overhead: Stage Imbalance 
- we want to try to cut up into equal pieces
- If one stage takes to long it will cause traffic basically
	- One stage will need to wait for the next stage to be open
	- One work has to wait for the next worker to finish his part
- bound by the slowest stage
- If the instruction stages can vary in non-pipelined <span style="color:rgb(255, 0, 0)">but</span> in pipelined version they can't and bound by slowest stage, so for example if the slowest stage was 60 in non-pipelined this would be how fast each stage is in the pipelined version since bound by the slowest stage
## Overhead: Interstage Delay
- This is the process of moving from one stage to another
- In analogy this would be like moving the car from the frame worker to the body worker
	- As the car's being moved no one can work on the car
- This action of picking up the car and moving it actually causes the total time to be longer, so even though it only takes 65 time unites per instruction(From slides 28) which seems faster the total time per instruction will be 65 * 5  which is longer than the original time of 260

## Formula
- we an instruction stream consisting of <span style="color:rgb(0, 176, 240)">N </span>instructions
- Break up this instructions into <span style="color:rgb(255, 192, 0)">K</span> **segments**  

### Non-Pipelined
- In a non-pipelined machine this would take <span style="color:rgb(0, 176, 240)">N</span> * <span style="color:rgb(255, 192, 0)">K</span> time steps since  even though we aren't using a pipeline it still technically chopped into K pieces, think 1 worker still has to build the frame, body,  engine, and seats.
### Pipelined
- In a non-pipelined machine this would take <span style="color:rgb(0, 176, 240)">N</span> * <span style="color:rgb(255, 192, 0)">K</span> time steps since  even though we aren't using a pipeline it still technically chopped into K pieces, think 1 worker still has to build the frame, body,  engine, and seats.
- Now in a pipelined machine, the **first** car/instruction must go through <span style="color:rgb(255, 192, 0)">K</span> steps since it's the first car and the assembly line is just starting. 
- Basically when first starting nothing is currently in the assembly line 
- Total time steps = <span style="color:rgb(255, 192, 0)">K</span> + (<span style="color:rgb(0, 176, 240)">N</span>-1)
- Speed up = <span style="color:rgb(0, 176, 240)">N</span> * <span style="color:rgb(255, 192, 0)">K</span> /(<span style="color:rgb(255, 192, 0)">K</span> + <span style="color:rgb(0, 176, 240)">N</span>-1)
	- This can be simplified because <span style="color:rgb(0, 176, 240)">N</span> in the denominator is so big the <span style="color:rgb(255, 192, 0)">K</span> value and -1 don't really matter <span style="color:rgb(0, 176, 240)">N</span> * <span style="color:rgb(255, 192, 0)">K</span> /<span style="color:rgb(0, 176, 240)">N</span> 
	- Another way to think is that N is infinity as it approaches infinity idk this makes sense in my head lol
- So Speed up simplified = <span style="color:rgb(255, 192, 0)">K</span> 
## Pipeline Stages
- Fetch Instruction (FI)
- Decode Instruction (DA)
- Fetch Operands (FO)
- Execute (EX)
## Pipelining Hazards
- Data hazards:
	- Instructions can't be performed until operands are available
	- So when instruction depends on the result of the previous instruction
		- RAW
		- WAW
		- WAR
- Control hazards
	- Next instruction to be executed is determined by previous instruction
		- Happens when there is branching
		- If statements cause branching so this would be a control hazards
- Resource hazards:
	- Instructions can't be performed until resources are available
	- When not enough of the right kind of hardware available
	- Typically memory
- <span style="color:rgb(146, 208, 80)">stalls</span>: Only one instruction can be executed at any one time
	- This is basically causing a bubble in the pipeline
## Minimizing hazards
- One way to minimize control hazard is to use a control bit
-  So when looping (a stereotypical behavior) since it basically does the same thing over and over, we can add a hint bit
- The hint bit basically tells us that we are still looping or not looping, so tells us what branch to take basically
- so compiler uses hint bit to ASSUME that going back to loop i.e. loop not ended
	- This minimizes the amount of flushing
- This is done by the compiler
- Compiler also has a divide check so can't divide by zero
[[CS259]]