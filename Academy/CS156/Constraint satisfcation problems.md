## CSPs: Identification Problems
- standard search problems
- The path to the goal is the solution
- CSP is identification problems basically
---
## CSPS: Representation
- Standard search problems:
	- State is like a black box: any data structure that supports goal test and successor function
	- State is atomic, indivisible
- Constraint satisfaction problems (CSPs):
	- Factored representation 
	- State is defined by a set of variables $X_i$ with values from a domain $D_i$
	- Goal test is a set of constraints C specifying what's allowed
---
## Constraint satisfcation problems
- A constraint satisfaction problem (CSP) consists of:
- X: a set of variables ${x_1,...x_n}$
- D: a set of domains ${D_1,D_n}$, one for each variable
- Each domain $D_i$ is a set of allowable values for variable $X_i$
- Each state in a CSP is defined by an assignment of values to some or all of the variables
- A consistent (or legal) assignment is an assignment that does not violate any contraints
- A complete assignment is one where each variable is assigned
- <span style="color:rgb(192, 0, 0)">Goal state must be consistent and complete</span>
- A solution is a consistent complete assignment
---
## Example: Map Coloring
- This is a colored map of Australia 
- Variables
	- Regions 
- Domains:
	- The colors
---
## Constraint Graphs
- Binary CSP: Each constraint relates at most 2 variables
---
## Ex: Cryptarithmetic 
- Variables
	- The letters
	- T, W, O, F, U, R, $C_1$,$C_2$,$C_3$
- Constraints
	- $o+o=r+10*c_1$
	- $C_1+W+W=U+10*c_2$

---
## Varieties of CSPs
- Discrete variables
- Finite domains
	- Size of d means $O(d^n)$ complete assignments (n variables)
	- Boolean CSPs, including boolean satisfiability (NP- complete)
- Infinite domains (integers, strings, etc)
	- For example job scheduling with no time limit
	- We can no longer use explicit constraints
- Continuous Variables
	- For example start/end time for hubble telescope 
---
## Varieties of Constraints
- Unary constraints involve a single variable: $T \ne \ blue$
- Binary constraints involve pairs of variables
- Higher order constraints involve 3 or more variables
- Preferences (soft constraints):
	- red is better than green
	- Often representable by a cost for each variable assignment
	- Gives constrained optimization problems - not CSP
---
## Unary Constraints and Node Consistency
- Unary constraints involve a single variable
- Applying node consistency: apply the unary constraints to reduce domains:
---
## Standard Search Formulation of CSPs
- We'll start with the straightforward, naive approach, then improve
- States are defined by values assigned so far
- Initial state: the empty assignment, {} it has no colors
- Successor function: assign a value to an un assigned variable
- Goal test: the current assignment is complete and satisfies all constraints
--- 
## Search Methods
- BFS
	- Bad choice
- DFS
	- Go down to depth n even though failure happens much earlier
---
## Backtracking Search
- Backtracking search is the basic uniformed
- Idea 1: One variable at a time
	- Variable assignments are commutative, so fix ordering
	- Only need to consider assignments to a single variable at each step
- Idea 2: Check constraints as we go
	- Consider only values which do not conflict with previous assignments 
	- Might have to do some computation to check the constraints
	- "incremental goal test"(failure test)
- DFS with these 2 improvements is called backtracking search 
---
## Improving Backtracking
- General-purpose ideas give huge gains in speed but it's all still NP-hard
- Filtering: can we detect inevitable failure early
- Ordering:
	- Which variable should be assigned next
	- In what order should it's value be tried
	- 


[[CS156]]
