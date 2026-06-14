## HW3
- Domains
	- dict representing vars and their domains 
	- neighbors: a dict representing binary constraints
	- constraint: a function that takes arguments var, possible value, current assignment of puzzle
	
---
## Improving Backtracking
- General-purpose ideas give hug gains in speed but still np-hard
- Filtering: can we detect failure earilier
- Ordering:
	- which variable should be assigned next
	- In what order should it's value be tried
	- Structure: Can we exploit the problem structure
---
## Filtering Forward Checking
- Idea: Keep track of remaining legal values for unassigned variables
- Terminate search when any variable as no legal values
---
## Limitation: Forward Checking
- Forward checking propagates info from assigned to unassigned
---
## Better Constraint Propagation?
- Before we introduce a more effective form of constraint propagation, we need to define some terms:
	- Node consistency: apply the unary constraints to reduce the corresponding variable domains
	- Heads and tails: consider the arc x->y
		- x is called the tail
		- y is called the head(arrow)
	- Arch consistency
---
## Consistency of a single Arc
- An arc X -> Y is consistent iff for every x in the tail there is some allowed y in the head which could be assigned without violating a constraint
- <span style="color:rgb(192, 0, 0)">Always remove from the tail</span> 
- Important: if X loses a value, neighbors of X need to be rechecked
- <span style="color:rgb(192, 0, 0)">Only looks at the arcs not the whole picture basically</span> 
- <span style="color:rgb(192, 0, 0)"> No solution different from arc consistent</span> 
---
## Limitations of Arch Consistency
- After enforcing arch consistency:
	- Can have one solution left
	- Can have multiple solutions left
	- Can have no solutions left
- Arc consistency still runs inside a backtracking search
---
## Ordering: Minimum Remaining Values
- Variable Ordering: Minimum remaining values (MRV):
	- Choose the variable with the fewest legal left values in its domain
- Also called most constrained variable
- Fail fast ordering
---
## Ordering: Least Constraining Value
- Value ordering: least constraining value
	- Given a choice of variable, choose the least constraining value, the one that rules out the fewest values in the remaining variables
	- Note that it may take some computation to determine this
---
## Problem Structure
- Extreme cases: independent subproblems
	- Example: Tasmania and mainland do not interact
- Independent subproblems are identifiable as connected components of constraint graph
- Suppose a graph of n variables can be broken into k problems subproblems of c variables (k=n/c)
---
## Tree-Structured CSPs
- If the constraint graph has no loops, the CSP can be solved in $O(nd^2)$ time
- Compare to general CSPs, where worst-case time is $O(d^n)$
- Conditioning: instantiate a variable, prune its neighbors' domain
- Cut-set conditioning: instantiate (in all ways) a set of variables such that the remaining constraint graph is a tree(no cycles)
---

[[CS156]]