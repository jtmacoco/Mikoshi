## Consistency of Heuristics
- Main idea: estimate heuristic costs <= actual costs
	- Admissibility:
		- Heuristic cost <= actual cost a nearest goal
		- $H(A) \leq$ actual cost from A to G
	- Consistency:
		- Heuristic "arc" $cost \leq$ actual cost for each arch $h(A)- h(C) \leq cost$ (A to C)
- For 2 neighbors, X and Y:
- $h(X)-h(Y) \leq cost(X \  to \ Y)$
- $h(X) \leq cost(X to Y)+h(Y)$
- $cost(S \ to \ X) + h(X) \leq cost(S \ to \ X) + cost (X \ to \ Y) + h(Y)$
- $f(X) \leq f(Y)$
- Consider what $A^*$ does with a consistent heuristic:
	1. $A^*$ expands nodes in increasing total f value (f-contours)
	2. <span style="color:rgb(192, 0, 0)">Missed</span> 
---
## Optimality of $A^*$ Search
- Tree search
	- $A^*$ is optimal if heuristic is admissible
	- UCS is a special case (H = 0 is admissible)
- Graph Search
	- $A^*$ is optimal if heuristic is consistent
	- UCS is a special case (h= 0 is consistent)
- <span style="color:rgb(192, 0, 0)">Consistency implies admissibility </span> 
- In general, most natural admissible heuristics tend to be consistent, especially if they are derived from relaxed problems 

---
## Properties of $A^*$
---
## UCS vs $A^*$
- uniform-cost expands equally in all directions 
---
## Complexity of  $A^*$
- Depends on the heuristic!
- Worst case null heuristic) same complexity as UCS
	- Time complexity $O(b^{C^*/e})$
	- Space complexity $O(b^{C^*/e})$
---
## $A^*$ Recap
- $A^*$ uses both backward costs and (estimates of ) forward costs
- $A^*$ is optimal with admissible and consistent
---
## Creating admissible Heuristics
- Most of the work in solving hard search problems optimally is in coming up with admissible heuristics
- Often, admissible heuristics are exact solutions to relaxed, easier problems 
- Inadmissible heuristics are often useful too - suboptimal is sometimes ok
----
## Heuristics
- How about using the actual cost as a heuristic?
	- <span style="color:rgb(0, 176, 240)">Would it be admissible</span>
		- Yes
	- <span style="color:rgb(0, 176, 240)">Would we save on nodes expanded</span>
		- Yes
		-
	- <span style="color:rgb(0, 176, 240)">What's wrong with it?</span>
		-<span style="color:rgb(192, 0, 0)"> If using actual cost requires to actually solve the problem </span>
- With $A^*$: a trade-off between quality of estimate and work per node
	- As heuristic get closer to the true cost we'll expand fewer nodes but usually do more work per node to compute the heuristic itself 

  
[[CS156]]