- Dynamic Programming (DP) refers to a collection of algorithms that can be used to compute optimal policies given a perfect model of the environment
- Classical DP algorithms are of limited utility in reinforcement learning because of
	- There assumption of a perfect model
	- Their great computational expense
- However, DP provides an essential foundation for understanding RL algorithms 
## Main Idea
- Use of value functions to organize and structure the search for good policies
- We can easily obtain optimal policies once we have found the optimal value functions
	- Therefore, we will find the optimal value function through DP
	- $v_*(s)=max\mathbb{E}[R_{t+1}+\gamma v_*(S_{t+1}|S_t=s,A_t=a]$
	- = $max\sum_{s',r}p(s',r|s,a)[r+\gamma v_*(s')]$
- So DP we use value functions to guide our search for the best way to behave by figuring out which actions lead to the most reward over time
- So instead of blindly testing every possible policy, we
	- Estimate how good each state is (using a value function) not this is just to learn not applicable irl due to hue memory constraint
	- Then choose actions that lead us to states with higher value
	- this leads to better policies over time
## Draw Backs
- Their assumption of a perfect model
- <span style="color:rgb(192, 0, 0)">So basically we need to know the complete knowledge of the environment</span> 
- Their great computational expense
## Policy Evaluation (Prediction)
- <span style="color:rgb(0, 176, 80)">The prediction problem (or policy evaluation) is to compute the state value function for a given policy</span>
- Remember the Bellman Expectation equation:
- By changing a policy the value of states will change
- In the prediction problem we fix a policy and compute the state value
## Iterative Policy Evaluation \[Key Idea]
1. Collect tentative state values of all successor states of a state s
2. Weight the tentative state value by transition x policy probabilities
3. Update the value of state s based on the Bellman expectation equation
- update rule is: $vk+1​(s)=Eπ​[Rt+1​+γvk​(S_{t+1}​)∣S_t​=s]$
- k is the iteration step
- v is the value
- gamma is the discount factor
- rest should be self explanatory 
### Simple Terms
1.  Look Ahead: For a state, check the possible next states it could go
2. Weight Outcomes: For each possible next state, multiply its current value by the chance of going there ( based on the policy and environment)
3. Update Value: Add these values up to get a better estimate for how good the current state is using the bellman expectation formula
## The Policy Evaluation to Policy Improvement
- Goal: Find an optimal policy
- <span style="color:rgb(192, 0, 0)">However, the prediction problem only examine the value of states given a policy and does not modify the policy </span>
- We need a separate policy improvement algorithm
## A Policy Improvement Algorithm
- Consider selecting $a$ and $s$ and thereafter following the existing policy $\pi$
- $q_\pi(s,a)\stackrel{\cdot}{=}\mathbb{E} [R_{t+1}+ \gamma v_{\pi}(S_{t+1}) | S_t=s,A_t=a]$
	- = $\sum_{s',r}p(s',r|s,a)[r+\gamma v_\pi(s')$
### In Plain English
- The action-value of taking a in state s is:
	- The expected reward you get right after taking action a, plus the discounted value of the next state, assuming you follow policy $\pi$ after than
- Is $q_\pi(s,a)$ greater than $v_\pi(s)$?
	- if So, it's always better to select a at s
## Policy Improvement Theorem
- Let $\pi$ and $\pi'$ be any pair of deterministic policies such that, for all states s, 
	- $q_\pi(s,\pi'(s))\geq v_\pi(s)$
- Then, the policy $\pi'$ must be as good  as or better than $\pi$ for all states s,
	- $v_{\pi'}(s) \geq v_\pi(s)$
- The theorem can be applied to the case where
	- an original deterministic policy, $\pi$, and a changed policy, $\pi'$, that is identical to $\pi$ except that $\pi'(s) = a \neq \pi(s)$
	- So everything is the same basically except at one state, where $\pi'$ takes a different action
- This is what we ant to check(i.e. Choosing a specific action $a$ from state $s$ is always better than the average performance (state value) of state $s$?)
- We want to see
	- If I only change the action at one state, does the overall policy get better?
	- This is a greedy improvement in policy iteration, making small, smart changes one step at a time
## How the condition will be realized?
- The condition of the policy improvement theorem
	- $q_\pi(s,\pi'(s))\geq(s)$
- Create the new policy $\pi'$ with the greedy policy:
	- $\pi'(s) \stackrel{\cdot}{=} \arg\max_a q_\pi(s,a)$
	- =$\arg\max_a\mathbb{E}[R_{t+1}+\gamma v_\pi(s_{t+1})|S_t=s,A_t=a]$
	- =$\arg\max_a\sum_{s',r}p(s',r|s,a)[r+\gamma v_\pi(s')]$
### In Plain English
- For each state $s$, look at each possible action $a$ and compute:
	- The expected reward right after taking the action, plus
	- The discounted value of the next state
	- Then choose the action that gives the highest total of that
## Drawback of Policy Iteration
- Iterates the entire state space
- This process may update one or very few actions

## Value Iteration
- The policy evaluation step of policy iteration can be truncated in several ways without losing the convergence guarantees
- An idea: Policy evaluation is stopped after just one sweep (one update of each state)
- Value iteration combines, in each of its sweeps, one sweep of policy evaluation and one sweep of policy improvement
### Basic Idea
- Skip the full policy improvement part of the policy iteration algorithm and extract the best policy from that
- Then it updates the policy based on the bellman optimality equation

## Policy Iteration VS Value Iteration
### Policy Iteration:
- The policy iteration breaks up into 2 parts.
1. The Policy Evaluation
	- Estimate the value function $v_\pi$ for the current policy $\pi$
	- This can take multiple sweeps
2. Policy Improvement
	- Make the policy greedy current value estimates
	- So here we are basically moving toward the optimal policy, but we're still using values derived from a specific policy, that isn't optimal yet
- They both do use the Bellman Expectation Equation, <span style="color:rgb(192, 0, 0)">but the policy iteration doesn't uses the optimality equation (so taking the argmax)</span>
### Value Iteration:
- The value iteration uses the Bellman Optimality Equation directly
- So it's not tied to any specific policy it just assumes that you'll always take the best action

## <span style="color:rgb(112, 48, 160)">Policy Iteration Analogy:</span>
- Like using a routine and then tweaking it
### Step-by-step:
1. Pick a routine (initial policy):
	- You guess a route from every neighborhood to the coffee shop. You do this for every place on the map, even if you're not sure it's the best
2. Try it out and measure (policy evaluation):
	- You follow your chosen route from each place and record how long it takes and how pleasant it is. You repeat this to get a good estimate of how good your current routine is
3. Tweak the routine (policy improvement):
	- Based on your results, you update your plan:
		- "Hmm, from downtown, the subway is faster than the bus. Let's change that part."
4. Repeat
	- You keep testing and improving your routine until there's no better route from any location 
- Summary: Policy iteration is like repeatedly trying out your full commute plan, then tweaking your routine based on experience until you can't improve it anymore
## <span style="color:rgb(112, 48, 160)">Value Iteration Analogy:</span>
- Like estimating the best route without following it fully
### Step-by-step:
1. Look ahead instead of walking the routes:
	- Instead of testing the full route, you ask:
		- If I go left from here, what's the expected time/distance based on how good the next place is?"
2. Estimate value for every location:
	- You update your opinion of each location by asking:
		- "If I could choose the best direction from here, how good could things turn out?"
3. Keep refining the values:
	- You then repeat this many times each time refining your estimates of how "valuable" each location is (how close/easy it is to reach your goal from there)
4. Once confident, extract the best route:
	- After the values stabilize you look at each place and say:
		- "Give my estimates, the best move from here is right"
- Summary: Value iteration is like repeatedly asking, "what's the best next step from here?" and updating your map without walking the full route until your confident you've figured out the best move from every place
- <span style="color:rgb(192, 0, 0)">Only updates the values of the policy not the policy it self, once the values converge as shown in the pseudo code then we extract the best policy </span>


## Summary: Generalized Policy Iteration (GPI)
- The general idea of letting policy-evaluation and policy-improvement processes interact, independent of granularity and other details of the 2 processes
- RL algorithms (called value-based RL) follow the same format
	- The policy always being improved with respect to the value function
	- The value function always being driven toward the value function for the policy
- The evaluation and improvement processes can be viewed as both competing and cooperating
	- Making the policy with respect to the value function typically makes the value function incorrect for the changed policy
	- Making the value function consistent with the policy typically causes that policy no longer to be greedy
- In the long run, however, these 2 processes interact to find a single joint solution: the optimal value function and optimal policy
## Algorithms pseudo code:
![[policy_iteration.png]]

![[value_iteration.png]]
[[CS272]]