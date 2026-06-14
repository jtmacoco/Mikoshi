## Generalization
- We want to apply the problems with arbitrarily large state/action spaces
	- More memory needed for large tables
	- Longer time and more data needed to fill the tables accurately
- In many of our target tasks, almost every state/action encountered will never have been seen before
- It is necessary to generalize from previous encounters with different states that are in some sense similar to the current one 
- How can experience with a limited subset of the state space be usefully generalized to produce a good approximation over a much larger subset
--- 
## Function Approximation
- The kind of generalization we require is often called function approximation 
- It takes examples for a desired function (e.g., a value function) and attempts to generalize from them to construct an approximation of the entire function
- Function approximation is an instance of supervised learning
---
## Approximate Value Function
- The approximate value function is represented not as a table but as a parameterized functional form with weight vector
	- $\hat{v}(s,w)\approx v_\pi(s)$
- We can choose any method to approximate the function
	- Linear function: Simple but limited
	- Neural Networks (Deep reinforcement learning): Complex but potentially more powerful
	- Decision Trees
- <span style="color:rgb(192, 0, 0)">Note already have notes in deep learning folder</span>
--- 
## Finding the best weight parameters
- In general, it's infeasible to find the best weights by random trials
- Define a loss function
	- <span style="color:rgb(192, 0, 0)">This function represents how close the approximate function is based on the given data points
</span>
- Solve the minimization problem with the loss function
---
## Finding the best weight parameters 
- A loss function: Difference between
	- A true value function and
	- An approximate function with the current weight vector w
		- $J(w)\stackrel{\cdot}{=}\sum_{s\in S}[v_\pi(s)-\hat{v}(s,w)]^2$
	- In an RL loop, the true value function is not available
	- We can approximate the sampled returns many times to obtain the true value function (same thing from the tabular methods)
--- 
## Target Values by methods
- Monte Carlo
	- $S_t\rightarrow G_t$
- Temporal Difference Learning (TD)
	- $S_t\rightarrow R_{t+1} +\gamma\hat{v}(S_{t+1},w_T)$
- Dynamic Programming
	- $s\rightarrow \mathbb{E}_\pi[R_{t+1} + \gamma\hat{v}(S_{t+1},w_t)|S_t=s]$
---
## Benefits of Approximation
- Assume an agent experiences an experience (s,a,r,s')
- In (tabular) Q-learning, how much impact does this experience have to the value function?(How many states will be updated?)
- In Q-learning with linear approximation, how much impact does it have?

- q(s,a) will be updated (one state-action pair)
- w will be updated. Then all q values will change (all state-action pairs) 
---
## Coarse Coding
- A task in which the natural representation of the states is a continous two-dimensional space
- Features corresponding to circles in the state space
- Each element of a state vector corresponds to a circle (0 or 1)
![[coarse-coding.png]]



[[CS272]]