- About 9-11 questions 
- Some questions multiple parts
---
## Midterm
- Intelligent Agents
- Uniformed Search: DFS, BFS, UCS
- Informed Search Greedy and A*, heuristics
- Local Search
- Constraint Satisfaction Problems
- Adversarial Search, Expectimax,  Multi-Agent Utilities
- <span style="color:rgb(192, 0, 0)">No coding questions</span> 
---
## Study tips
- Review lectures and prepare/update cheat sheet
- Retake iClicker quizzes
- Retake questions of the week
- Review homework assignments
---
## Exam Tips
- Please read the question carefully
- <span style="color:rgb(192, 0, 0)">Make sure you answer the question that was asked - not something close</span> 
---
## Search Algorithms Questions
- Nodes expand in the order they were expanded
- Solution 
- Cost
- Heuristics
	- Admissible
	- Consistent
- Local Search
- <span style="color:rgb(192, 0, 0)">Must explain why yes why no</span>
---
## Ex: Tour de AI 
### DFS
- Node expected to give full path in addition to state so In example A2A1 while the state is A1 so the last value
- Expanded means added to closed set so if in fringe not expanded fully yet so it's still can go to basically
- DFS go left first
- <span style="color:rgb(192, 0, 0)"> DFS doesn't matter cost or direction </span>
- Cost expects a number 
- Solution expects a sequence from start state to goal state
- Nodes expanded?
	- <span style="color:rgb(192, 0, 0)">List the nodes and the order so needs to be in correct order</span>
	- <span style="color:rgb(192, 0, 0)">Don't expand the goal since we've reached the goal</span> so the goal isn't in the nodes expanded
---
## BFS
-  Solution must include goal
- Shortest Path is what BFS IS
---
## Heuristics
- A heuristic is an estimate of the cost form a given state to the goal
- We do not add  heuristics of multiple states
- If admissible only need to give one example
- If not admissible must give example why
	- So need to prove answer
	- <span style="color:rgb(0, 176, 240)"> Do this last since could take time</span>
---
## Greedy
- Greedy picks smallest heuristic
---
## A*
- Go with lowest f value 
- <span style="color:rgb(192, 0, 0)"> Don't expand goal state</span>
- Avoids the hills
---
## CSPs: Question Examples
- Domain after enforcing node consistency (UNARY)
- Domain after enforcing arch consistency
- Domain after running the AC-3 algorithm to completion
- Order (MRV, Least Constraining value)
- Structure: tree structure, CSP, cutset conditioning, smallest cutset



[[CS156]]