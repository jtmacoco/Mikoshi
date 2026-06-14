- Properties
	- Deterministic or stochastic
	- One, two, or more players
	- Zero sum like tic tak toe
	- Fully observable
- How are games different from search problems we've seen so far
	- So far we have been looking for a sequence of actions, that are guaranteed to succeed
	- That does not work here because we don't control our opponent
	- We need to be able to decide on a move from each state
	- We need algorithms for calculating a<span style="color:rgb(192, 0, 0)"> strategy (policy)</span> which recommends a move form each state
-  Many possible formalizations, one is
	- States: S (start at $s_0$)
	- Players/Agents: $P = {1...N}$
	- Actions: A (may depend on player/state)
	- Transition Function:$S \ x \ A \rightarrow S$
	- Terminal Test(game over?): $S \rightarrow {True,False}$
	- Terminal Utilities/Scores: $SxP \rightarrow R$
---
## Zero-Sum Games
- Agents have opposite utilities (values of outcomes)
- Lets us think of a single value that one maximizes and the other minimizes
- Adversarial, pure competition
---
## General Games
- Agents have independent utilities (values on outcomes)
- Cooperation, indifference, competition, and more are all possible
---
## Adversarial Search
- We still need to think about the consequences of our actions
- We also need to think about our opponent and how they will respond to our actions
---
## Adversarial Search (Minimax)
- Deterministic, zero-sum games:
	- Tick Tac Toe, chess
	- One player maximizes result
	- Other minimizes result
- Minimax search:
	- A state-space search tree 
	- Players alternate turns
	- Compute each node's minimax value: the best achievable utility/score against a rational (optimal) opponent)
---
## Action Selection
- To recommend an action for Max, which minimax value do we need to compute
---
## Minimax Properties
- Complete
	- Yes
- Optimal
	- Depends on mini or who we play basically
	- Against pro  a perfect opponent yes optimal
	- Against irrational opponent basically imperfect then no
- Time complexity
	- m: depth of solution - number of moves
	- Depth first search $O(b^m)$
	- Space complexity
		- $O(bm)$(depth first exploration)
	- Example: for chess, b = 35, m = 100
		- Exact solution is completely infeasible
---
## Resource Limits
- Problem: in realistic games, we cannot search full tree
---
## Alpha-Beta Pruning
- From MIN's perspective:
	- We are computing the MIN-VALUE at some node n and looping over n's children
	- n's estimate of the children's min(v) is dropping
	- Let $\alpha$ be the best value that MAX can get at any point along the current path form the root
	- If n's value (v) becomes worse that $\alpha$, MAX will avoid it, so we can stop considering n's other children 
	- $\alpha$ is the best value (to max) found so far off the current path 
	- If v is rose than $\alpha(v<\alpha)$ max will avoid it => prune the branch
	- <span style="color:rgb(192, 0, 0)">Question 2 doesn't use generator</span>
	- For action selection:
		- We need to calculate the value for all successor states
		- Return the action that corresponds to the maximum value of a successor state
	- <span style="color:rgb(192, 0, 0)">No Purning at the root</span>





[[CS156]]