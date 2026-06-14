- A problem solving agent is a special type of goal based agent operating in an environment that is
	-  Fully observable
	- Discrete
	- Deterministic
	- Single agent
- <span style="color:rgb(0, 176, 240)">A problem solving agent uses an atomic representation of the world</span> 
- A problem solving agent uses <span style="color:rgb(192, 0, 0)">search</span> to find a solution
- The solution is a sequence of actions that will achieve the goal
---
## Evaluating problem solving agents
- Optimal vs Complete
	- <span style="color:rgb(0, 176, 80)">Complete:</span> the agent is guaranteed to fin a solution
	- Optimal: <span style="color:rgb(192, 0, 0)">FORGOT</span>  go back here
---
## Problem Solving Agent Design
1. Formulate the problem
2. Search for a solution
3. Execute the solution
---
## Search Problems
- A search problem consists of:
	- A state space: a set of possible states that the environment can be in. 
- Need to define successor function: an abstraction that models how we think the world works, how it evolves in response to given actins. It includes actions and costs. It represents our transition model
- A solution is a sequence of actions( a plan) which takes us from the start state to a state that satisfies the goal first
---
## Search Problems Are Models
- The real world is absurdly complex
- The state space must be abstracted for problem solving
- We only include relevant details
---
## Ex: Taveling in Romania
- State Space
	- Must be able to support the goal test:
	- in Bucharest? since agent trying to get to Bucharest
- Succesor function:
	- Use Roads: Go to adjacent city with cost = distance
- Solution:
	- Sequence of actions that take our agent from Arad to Bucharest
---
## What's in a State Space
- The world state includes every last detail of the environment 
- A search state keeps only the details needed for the search
	- <span style="color:rgb(192, 0, 0)">Problem: Pathing</span> 
- State: (x,y) location  
- Actions NSEW
- Goal test: (x,y) == END
---
## What's in a State Space
- A world state includes every last detail of the environment
- A search state keeps only the details needed for the search
- Problem: Eat-ALL-DOTS
- State ((x,y),dots)
- Actions: NSEW
- Successor: update location and possibly dots
- Goal test: Are all the dots eaten 
---
## State Space Graphs
Stat space graph: A mathematical representation of a search problem
- States are (abstracted) world configuration
- Arcs represent successors (action results)
- The goal test is a set of goal state (maybe only one)
- markov hidden chains/models
---
## Search Trees
- Nodes show state, but correspond to PLANS that achieve those state
- For most problems, we can never actually build the whole tree
---
## Searching with a search Tree
Search:
- Expand out potential (tree nodes)
- Maintain a fringe/frontier of partial plans under  consideration
---
## Graph Search
- <span style="color:rgb(192, 0, 0)">Never expand a state twice</span>
- How to implemented:
- Tree search : set of expanded states ("closed set")
---
## Uniformed search strategies
- DFS
- BFS
- Iterative Deepening
- Uniform cost search 
- <span style="color:rgb(192, 0, 0)">Resolve ties alphabetically </span>
---
## Evaluating Search Strategies
- Complete: Guaranteed to find a solution if one exists?
- Optimal: Guaranteed to find the least cost path
- Time Complexity: $O(b^m)$
- Space complexity:

- Cartoon of search tree:
	- b is the branching factor
	- m is the maximum depth
	- solutions at various depths
---
## Depth First Search(DFS) properties
- Is it complete 
	- if m is finite (graph search, no cycles), it is complete
- Is it optimal?
	- No, it finds the "leftmost" solution 
---
## Breadth-First Search
- Strategy:
	- Expand shallowest node on the fringe first
- Implementation:
	- Implement the fringe as a FIFO queue
- Time Complexity:
- what nodes does BFS expand
	- Process all nodes above shallowest solution  
- Search takes time complexity $O(b^s)$
- Has roughly the last tier, so $O(b^s)$
- Is it complete

	- <span style="color:rgb(192, 0, 0)">s must be finite if a solution exists, so yes</span> 
- Is it optimal
	- <span style="color:rgb(192, 0, 0)"> Only if costs are all 1 then it is optimal</span> 
---
## DFS vs BFS
- Pacman DFS worse
- Pacman BFS better 
- So it's dependent on the maze/problem 
- When will BFS outperform DFS
- When will DFS outperform BFS
- <span style="color:rgb(192, 0, 0)">Consideration: depth solution, space limitation, branching factor</span> 
---
## Iterative Deepening
- Idea: Get DFS space advantage with BFS time/shallow-soluiotn advantages
- Run a DFS with depth limit 1. If no solution 
- Run a DFS with depth limit 2. If no solution 
- Generally most work happens in the lowest level searched, so not so bad
- Optimality
---
## Cost-Sensitive Search
- BFS finds the shortest path in terms of number of actions
- It does not find the least cost path
- We will now cover a similar algorithm that finds the least cost path
---
## Uniform Cost Search
- Expand Cheapest node on the fringe first implementation:
- Implement the fringe as a priority queue
- Priority: cumulative cost (from root)
- <span style="color:rgb(0, 176, 240)">For hw 1 use the priorityqueue class</span>
- <span style="color:rgb(0, 176, 240)">Time Complexity:</span> What nodes does UCS expand
	- <span style="color:rgb(192, 0, 0)">Process all nodes with cost less than cheapest solution</span> 
- If that solution cost $C^*$ and arcs cost at least $e$ then the effective depth is roughtly $C^*/e$
- Tames time $O(b^{c^*/e})$
- <span style="color:rgb(0, 176, 240)">Space Complexity:</span> 
	- Missed go back
- Is it complete
	- Assuming best solution has finite cost then yes
- Is it optimal
	- Yes
- UCS explores increasing cost contours 
	- Good
	- UCS is complete and optimal
- The bad:
	- Explores options in every direction
	- No information about goal location 
---
The One Queue
- All of theses search algorithms are the same except for fringe strategies
- Conceptually, all fringes are priority queues (collection of nodes with attached priorities)
- Practically , for DFS and BFS, we avoid the log(n) overhead)
[[CS156]]