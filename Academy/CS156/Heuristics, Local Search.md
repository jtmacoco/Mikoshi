## Dominance
- Dominance: $h_a \leq h_c$  if
- If $h_a$ is admissible, what does that tell us about $h_c$
	- that $h_c$ is also admissible 
- If $h_c$ is admissible, what does that tell us about $h_a$
	-  Not much but just because $h_c$ is admissible doesn't meant that $h_a$ is admissible
---
## Heuristic form of semi-lattice
- Max of admissible heuristics:
	- $h(n) = max(h_a(n), h_b(n))$
- Maximum of 2 or more admissible heuristics is admissible: <span style="color:rgb(192, 0, 0)">useful property for creating new, better heuristics</span>  <span style="color:rgb(0, 176, 240)">keep this in mind for hw 2</span>
---
## Trivial Heuristic 
- Bottom of the lattice is the null/zero heuristic (what does this give us?)
- Top of Lattice is the exact heuristic
---
## $A^*$ Applications 
- Video games
- Path problems
- etc...
---
## Homework 2
###  Question 2:
- Single Heuristic
- So implement manhattan distance
- if goal state return 0
- Check goal state first
- use is goal state method from problem
- <span style="color:rgb(192, 0, 0)">2 relaxations </span>
### Question :3
- Implement a better heuristic that can be used
- Carrots to medal helper 
- So bring back something you took away un-relax basically
- Better heuristic should be based on carrot to medal
### Question 4:
- maze contains an arbitrary number of medal and the medals can be anywhere in the maze  
- One way to relax this complex problem is to assue that there is only one medal in the maze. For each medal you choose you get a possible admissible heuristic. How would you then pick the best one? the of a property of heuristics
---
## State vs Problem
- All the heuristics are passed 2 arguments: state and problem
- State: Sammy's current position and remaining medals
- You must use the state passed and not problem.start_state()!
---
## Other Considerations
- Implementation must be memory and time efficient: it does not store large data structures
- DRY code Do no repeat the same code
---
## What is Search For
- Assumption about the world:
	- Single agent, deterministic, fully observable, discrete
- Search problems so far:
	- The path to the goal is the solution 
	- Paths have various costs, depths
	- Heuristics give problem-specific guidance
	- Examples: pathing problems, Eight puzzle 
- For some problems:
	- We need to find a goal state
	- It does not matter how we get there

---
Iterative improvement algorithms (local search):
- Hill climbing (steepest ascent/gradient descent)
- Random restart hill climbing etc
---
## Local Search
- The search algorithms we have seen so far keep unexplored alternatives on the fringe to ensure completeness
- Local search:
	- Keep a single 'current' node (no fringe)
	- Try to improve it until we can't make it better 
- Advantages
	- Local search is generally much faster and more memory efficient
- Disadvantages
	- Incomplete and suboptimal 
---
## Example n-Queens
- Place n queens on an n x n board with no 2 queens on the same row, column, or diagonal
- Start with any configuration
- Move a queen to reduce the number of conflicts 
---
## Example: 4 Queens
States: 4 queens in 4 columns ($4^4=256$)
- Actions: move queen in column
- Goal test: no conflict
- Evaluation: $c(n)$ = number of conflicts 
- Solve n-queens problems almost instantaneously for very large n
---
## Hill Climbing 
- Going over gradient accent so how it only finds local and not global 
- Not optimal
- Yes complete
- Advantage
	- For some problems, a non optimal solution is ok
- Can we make it better?
	- Start at different positions/states
---
## Random-restart Hill Climbing
- Idea: overcome local maxima by conducting several hill climbing searches, starting from a random initial state
- We keep the best result
- This is surprisingly effective 
---
## Simulated Annealing
- Idea escape local maxima by allowing random downhill moves
- So a temperature  remember for ML
---
## Genetic Algorithms
- Genetic algorithms use a natural selection metaphor
	- Start with a population of hypotheses (candidate solutions)
- Keep best N hypotheses at each step (selection ) based on a fitness function 
- Use a pairwise crossover operators, with optional mutation to give variety
-  Start with a randomly generated states: population
- Each state (individual) is represented as a string
- Each state is rated by an objective function (fitness function)
	- Number of conflicts
	- Number of non-attacking pairs of queens =  Total pairs - conflicts 
- Use pairwise crossover operators 

[[CS156]]