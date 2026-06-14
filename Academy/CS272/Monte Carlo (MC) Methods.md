- Only require experience
	- Sample sequences of states, actions, and rewards from actual or
	- Simulated interaction with the environment
- No prior knowledge of the environment's dynamics
- Yet can still attain optimal behavior
- <span style="color:rgb(192, 0, 0)">MC is Incremental Implementation from MAB</span>
- Main idea: <span style="color:rgb(192, 0, 0)">Solving the reinforcement learning problem based on averaging sample returns</span>
	- which involves an agent learning to make decisions in an environment to maximize a cumulative reward

- A true value function: the expected returns of states averaged over ALL possible episodes
- MC: The expected returns of states averaged over all "sampled" episodes
	- Simply average the returns observed after visits to that state
	- As more returns are observed, the average should converge to the expected value
	- So this is the average reward from a state based on the episodes you've actually seen (samples)
	- You just average the rewards that came after visiting that state
	- The more you play and gather data, the closer your average gets to the true value
	- This is like an <span style="color:rgb(0, 176, 240)">Incremental implementation </span>
## The Prediction and Control Problems
- <span style="color:rgb(192, 0, 0)">The prediction problem</span>
	- Estimate the value functions given a policy
- The control problem
	- Approximate optimal policies
## MC Prediction
- The same state may appear multiple times in an episode
- We can call each appearance a visit to the state
- We can update the value function of the state
	- when it is the first time visit (first-visit MC)
	- Or each time when it's visited (every -visit MC)
- Basically 
![[mc-prediction.png]]

## Effectively Computing the Average
- Each time  step gives you a sampled return
- You need to compute the average $\mu_k$ until the step k
- A naive way:
	- Store all returns ${R_1,R_2,...,R_k}$
	- Sum them up
	- Divide the sum by k
- Incremental average
- The mean $\mu_1,\mu_2,...$ of a sequence $x_1,x_2,...$ can be computed incrementally
	- $\mu_k=\frac{1}{k}\sum_{j=1}^kx_j$
	- $=\frac{1}{k}(x_k+\sum_{j=1}^{k-1}x_j)$
	- $=\frac{1}{k}(x_k+(k-1)\mu_{k-1})$
	- $=\mu_{k-1}+\frac{1}{k}(x_k-\mu{k-1})$
## MC Control
- If a model is not available, it is particularly useful to estimate action values rather than state values
- With a model,
	- One simply looks ahead to one step and chooses whichever action leads to the best combination of reward and next state
- Without a model,
	- One must explicitly estimate the value of each action values
	- Thus, a goal for Monte Carlo methods is to estimate action values
### <span style="color:rgb(112, 48, 160)">Analogy: Theme Park Ride Reviews</span>
Imagine you're trying to figure out how **fun** a certain ride is at a theme park (like Disneyland), but you're not allowed to see a ride's specs or hear official ratings — only the **experiences of actual riders**.
### Here’s how MC Prediction fits:
- Every day, **a few people** ride the ride (an episode).
- After each ride, you **ask them to rate it from 0 to 10** (this is the **return**, or total reward).
- Each time you gather a new rating, you **average it** with all the previous ratings for that ride.
- Over time, as more people ride and rate it, your **average rating gets closer to the true experience** of the ride.
> <span style="color:rgb(192, 0, 0)">You're not modeling the ride — you're learning **just from experience**.</span>

Now, let’s say you’re doing this for **every ride in the park**, and you want to know how fun each one is **on average**. That’s **MC Prediction** in action.
## MC Control
- MC Control
	- Take a greedily best action from each state to update the policy? <span style="color:rgb(192, 0, 0)">NO</span>	
- Learn an optimal policy from scratch using only sampled experience (no environment model)
- It does 2 things at once:
	1. Estimates the action-value function $Q(s,a)$ - the expected return for taking action $a$ in state $s$
	2. Improves the policy - by choosing better actions over time based on those estimates (usually greedily)
- Over many episodes:
	- It samples episodes using the current policy
	- It updates $Q(s,a)$ using the average return following that action in that state
	- It improves the policy by making it greedy with respect to the current $Q(s,a)$
### <span style="color:rgb(112, 48, 160)">Analogy: Bowling to Win a Prize</span>
Imagine you’re in a **bowling alley game show**, trying to win a prize. You don’t know the rules exactly, but each time you play a round (an episode), you get a **score** (return).
Each round:
- You start at the first lane (a state),
- Choose a **type of throw** (action),
- Get a total score based on all your throws (the return).
You **try different throw types in different lanes**, and over time:
- You **keep track of how well each throw type does in each lane**,
- Then you start **favoring the throw types that lead to better scores**.
Eventually, your **strategy improves** — you’re learning **which action in each state gives the highest return**.

> That’s MC Control: try stuff → track results → favor the best → repeat.

## A Challenge in MC Control
- Many state-action pairs may never be visited
- If the agent follows a deterministic policy, it will observe returns only for one of the actions from each state
	- So when gathering data (like in the MC Prediction and MC Control),
		- You will only ever see the result of that one chosen action in that state
	- You won't see what happens if you try other actions from that state
### Why this is a problem
- To learn an optimal policy, especially in MC Control, you need:
	- Estimate action-values $Q(s,a)$ for all actions in each state
	- But if you only ever try one action , you can't estimate the others
	> So you can't say which action is the best if you never try anything else

### Moving on in slides
- With no returns to average, the Monte Carlo estimates of the other actions will not improve with experience
- The purpose of learning action values is to help in choosing among the actions available in each state
- To compare, alternatives we need to estimate the value of all the actions from each state, not just the one we currently favor
- <span style="color:rgb(192, 0, 0)">Maintaining Exploration</span>
## A Soft Policy
- A policy is soft if and only if 
	- $\pi(a|s) \gt 0$ for all state s and all action a
- An agent uses a soft policy to maintain exploration and gradually shifts closer and closer to a deterministic optimal policy
- A very famous soft policy is epsilon-greedy method
- Just look up pseudo code Jonathan

## Epsilon-greedy Algorithm
- All nongreedy actions are given the minimal probability of selection
	- $\frac{\epsilon}{|A(s)|}$
	- In simple terms a soft policy is one that never completely rules out any action in any state
	- <span style="color:rgb(0, 176, 240)">So no matter what state you're in, the agent has some chance (even if small) of choosing every action</span>
- The remaining bulk of is given to the greedy action
	- $1-\epsilon + \frac{\epsilon}{|A(s)|}$
- This is a soft policy when $\epsilon \gt 0$
- Also, this is close to the greedy algorithm
![[on-policy-mc-control.png]]

## Keeping a Running Mean of Returns
- MC Prediction update with a learning rate $\alpha$
- $Q(S_t,A_t) \leftarrow A(S_t,A_t) + \alpha[G-Q(S_t,A_t)]$
- Forgets older episodes
- Effective for non-stationary problems


## On-policy vs Off-policy
- <span style="color:rgb(0, 176, 80)">On-policy:</span>
	- Estimate the value of a policy while <span style="color:rgb(0, 176, 240)">using it for control</span>
	- i.e., A single policy function to generate episodes and to update
- <span style="color:rgb(0, 176, 80)">Off-policy:</span>
	- Two separate policies for the episode generation and update
	- Behavior policy: The policy used to generate behavior
	- Target policy: The policy evaluated and improved
- An Advantage of this separation is that the target policy may be deterministic (e.g. greedy), while the behavior policy can continue to sample all possible actions
## Importance Sampling
- Can we use any policy as the behavior policy b?
- <span style="color:rgb(192, 0, 0)">NO!</span>
	- Every action taken under the target policy is also taken, at least occasionally, under the b (<span style="color:rgb(192, 0, 0)">the assumption of convergence</span>)
- Weighting returns according to the relative probability of their trajectories occurring under the target and behavior policies (<span style="color:rgb(192, 0, 0)">the importance-sampling ratio</span>)
### Simplified
- You can't learn about actions that you never try
- So the behavior policy must try every action the target policy might take
- If the behavior policy never tries some actions, you'll have no data about those, so you can't estimate their value
- Tink of it like trying to learn how good chocolate cake is, but your diet (behavior policy) never lets you eat chocolate cake, you'll never know if it's good
### Back to lecture n Temporal-Difference (TD) Learning notes
- Recall that we wish to estimate the expected returns (values) under the target policy
- But all we have are returns G due to the behavior policy
- These returns have the wrong expectation $\mathbb{E}[p_{t:T-1}G_t|S_t=s]=v_\pi(s)$

[[CS272]]



