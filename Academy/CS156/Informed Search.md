## Recap
- Uniformed search strategies 
- DFS
- BFS
- Iterative Deepening
- Uniform-Cost Search
---
## Uniformed Search
- Explores the search tree in a systematic way:
	- top down
	- left to right,
	- cheapest cost
---
## Informed Search
- key idea
	- In addition to everything else that our uniformed search was doing, we have something that tells us if we're getting hotter or colder. 
- We are able to answer not just whether a state is a goal state or not but <span style="color:rgb(0, 176, 240)">how close to the goal a state is</span> 
---
## Search Heuristics
- A heuristic is:
	- A function that estimates how close a state is to a goal
	- Designed for a particular search problem
	- Examples: Manhattan distance, Euclidean distance for pathing
- <span style="color:rgb(192, 0, 0)">Cannot exceed the actual cost to the goal, so an optimistic estimate</span>
---
## Greedy Search
- Strategy:
	- Expand most promising node on the fringe first
- Implement the fringe as a PQ
- Priority: heuristic
 ---
 ## $A^*$ Search
 - A star basically compares UCS and Greed algorithm 
 - Shakey the robot
- only as good as the heuristic you use with it
---
## Idea: Admissibility
- <span style="color:rgb(0, 176, 80)">Inadmissible (pessimistic) heuristics</span>
	- Break optimality by trapping good plans on the fringe
- <span style="color:rgb(0, 176, 80)">Admissible(optimistic) heuristics </span>
	- slow down bad plans but never outweight true costs
---
## Admissible Heuristics


[[CS156]]