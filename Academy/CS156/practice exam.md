1. A rational agent is an agent that makes decisions to maximize it's performance measure. The performance measure is what a rational agent depends on in order to be rational. So the better the performance measure is like the better the reward system is at describing what it's goal is the better the agent will be at making the most rational moves.
2. SEARCH ALGORITHMS
	a. UCS is the only one to find the optimal path as it will find the path with the lowest costs. Now this is assuming that the heuristic is admissible as if it's not then UCS won't find the optimal path. 
	b. The reason it's optimal is because UCS is going based on the minimum heuristic so as long as the heuristic is admissible then it should find the optimal path
	c. The reason DFS and BFS will be sub optimal is due to DFS only expanding the leftside of the tree first so the path found is the deepest on the left side leaving it to no be optimal. BFS is suboptimal since the cost's are all not 1 or 0. For BFS it will search the tree layer by layer so it won't find the optimal path but it will find the shortest path. 
3. Search Sim
	a. The solution path BFS returns is the shortest path so A2B2C2D2E2
	b. The total path cost is 13
	c. DFS path would be different as it would go down the left side of the tree, and basically zig-zag across the grid
4. 
	a. No this heuristic is not admissible since at Node B the true cost is 5 and the h(n) value is 7
	b. No
	c. Since it's not admissible it can't be consistent
5. A search
	a. A2A1B1
	b. The reason is because A2 has already been expanded so we can't expand it A2A1 has also already been expanded. And A2B2 f value is higher than A2A1B1 so we don't expand it
	
6. Constraint
	a. Domain A = {2,4,6} Domain B = {1,2,3,4,5,6}
	b. Domain A = {2, 4} Domain B = {1,2,3,4,5,6}
	c. Domain A = {2,4} Domain B = {1,2,3,4} 
	d. There are 6 solutions
7. 
	a. MRV is where you choose the variable with the fewest legal values in it's domain
	b. This helps because given a choice of variable, we choose the least constraining value, the one that rules out the fewest values, so when backtracking we are less likely to be stopped or have to back track since we are choosing a value that is less likely to have a conflict
8. 
	a. It is 5
	b. Choose the Right Branch
	c. We can't prune any nodes 
9. 
	a. Expectimax takes the average instead of using the min node. So we have probabilities of for getting to a nodes value. Then we take the node with the best/highest average. MiniMax has this back and forth between Max and Min, which means we won't find the optimal solution when playing a non optimal player. So Expectimax helps with this.
	b. Can't apply alpha bet pruning to Expectimax because each branch contributes the the average.
	c. An example would be when playing against a non-optimal/professional player. As they may make some mistakes so it's best to average out the probability making certain moves using a probability
[[CS156]]