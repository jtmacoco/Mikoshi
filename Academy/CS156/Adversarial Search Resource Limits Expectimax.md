- <span style="color:rgb(192, 0, 0)">Need to start on left side</span> 
- <span style="color:rgb(192, 0, 0)">will be pruning question on mid-term</span>
---
## Alpha-Beta Pruning Properties
- Good child ordering improves effectiveness of pruning
- with "perfect ordering":
	- Time complexity drops to $O(b^{m/2})$
	- Doubles solvable depth
	- Full search of chess, is still hopeless
---
## Depth Limited Search
- Problem in realistic games, we cannot search to leaves
- Solution : Depth limited search
	- Only search to a limited depth in the tree
	-  Replace terminal utilities with an evaluation function for non-terminal positions 
- Guarantee of optimal play is gone
- More plies (going deeper in the tree) makes a BIG difference
- Use iterative deepening for an anytime algorithm 
	- start with depth 1, then depth 2, etc
	- When we run out of time, we have a move
	- the more time we get, the better our move gets
---
## Depth Matters
- Evaluation functions are always imperfect
- The deeper in the tree the evaluation function is buried, the less the quality of the evaluation function matters
- Tradeoff between complexity of the function and quality of estimate 
---
## Evaluation Functions
- Evaluation functions score non-terminals in depth-limited search
- An evaluation function takes a state and returns a number that is an estimate of the minimax value
- Ideal functions: returns the actual minimax value of the state
- In practice: typically weighted linear sum of features
---
## Tic Tac Toe Evaluation Function
- min_count: rows/columns/diagonals that min can still win
- max_count:rows/columns/diagonals that max can still win 
- Evaluation function: max_count - min_count
- 8
---
## Homework 4 - Minimax
- Implement minimax function 
	- Action that max will take at this point in the game
	- This is the move max will make 
- <span style="color:rgb(192, 0, 0)">Only use eval in third part of assignment</span>
### Evaluation Functoin
- Evaluation: function: max_count - min_count
- Can we still use -1 and + 1 as the utility for terminal states
	- NO!
	- Winning terminal states must have a value > any non terminal states
	- <span style="color:rgb(192, 0, 0)">Important: these values depend on the size of the game</span>
---
## uncertain Outcomes
---
## Worst Case vs Average Case
- Idea uncertain outcomes controlled by chance, not an adversary
---
## Expectimax Search
- Why wouldn't we know what the result of an action will be
	- Explicit randomness: rolling dice
- Unpredictable opponents
- Actions can fail: when moving a robot wheels might slip
- Values should now reflect average-case(expectimax) outcomes, not worst-case(minimax)
- Expectimax search:<span style="color:rgb(192, 0, 0)"> compute the average score under optimal play</span>
	- Max nodes as in minimax search
	- Chance nodes are like min nodes but the outcome in uncertain
	- Calculate their expected utilities
---
## Dangers of Optimism and Pessimism
- <span style="color:rgb(0, 176, 240)">Dangerous Optimism:</span> Assuming chance when the world is adversarial
- <span style="color:rgb(0, 176, 240)">Dangerous Pessimism:</span> Assuming the worst case when it's not likely
---
## Mixed Layer Types
- Expectiminimax:
- Environment is an extra random agent player that moves after each min/max agent
- Each node computes the appropriate combination of it's children
--- 
## Multi-Agent Utilities
- What if the game is not zero-sum, or has multiple players
- Generalization of minimax
- Terminals: utility tuples
- Node values: utility tuples
- Each player maximizes its own component
- Can give rise to cooperation and competition dynamically
--- 
## What Utilities to Use
- For worst-case minimax reasoning, terminal function scal does not metter
	- We just want better states to have higher evaluations ( get the ordering right)
	- We call this insensitivity to monotonic transformations
---
## Utilities Beyond Games
- Utilities are functions from outcomes (states of the world) to real numbers that describe an agent's preferences
- Where do utilities come from
- In a game, may be simple (+1/-1)
- Utilities summarize the agent's goal
- In AI, we set the utilities and let behaviors emerge
- We don't let agents pick utilities
- We don't prescribe behaviors
- 


[[CS156]]