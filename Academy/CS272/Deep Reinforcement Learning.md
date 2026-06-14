- Book: Deep Reinforcement Learning in Action by Alexander Zai, Brandon Brown
--- 
## Q Function Approximation
- The Q function could be any function that
	- Accepts a state and action
	- Returns the value of taking that action given that state
--- 
## Point 1. Design of NN-based Q Function
- In DQN, the Q function is implemented in a way to compute the Q values for all actions, given a state
- The vector-valued Q function is more efficient since you only need to compute the function once for all the actions 

## An Example : Grid World
- The agent (A) must navigate along the shortest path to the goal tile (+) and avoid falling into the pit (-)
- Here, we use a 4x4x4 tensor to represent a state, where each frame (4x4) indicates
	- The agent
	- The goal
	- The pit
	- The wall
![[grid-world-ex.png]]
---
## A neural network as the Q function
- An input layer that can accept a 64-length game state vector (4x4x4)
- Some hidden layers
- An output layer that produces a 4-length vector of Q values for each action
![[nn-q-function.png]]
---
## Tsitsiklis and Van Roy's Counter example
- Each state is described by a single scalar feature $\varphi$ (phi)
	- $\varphi(s1)=1$ and $\varphi(s2)=2$
- The value function is approximated with a linear function $v(s,w)=wx\varphi(s)$
- All rewards are 0s
	- The true value function gives ZERO to all states $(w^*=0)$
- Theoretically, the following DP should represent the optimal updates
- When $\gamma\gt\frac{5}{6-4\epsilon}$ and $w_0\neq0$, the sequence of updates diverges
- That seems quite possible (e.g. gamma = 0.89 with epsilon = 0.1)
- <span style="color:rgb(192, 0, 0)"> This example shows that the approximation methods bring instability in the learning process with particular settings</span>
- Basically using neural net's doesn't follow the TD(0) idea that it will always converge to some policy, as neural nets will cause some instability, so TD(0) will really only guarantee converges using tabular methods
--- 
## The Divergence Issue with Deep RL
- Empirically, we actually find the unbounded divergence is rare with Deep RL
- More common are value explosions that recover after an initial phase
- This phenomenon is also referred to as "soft-divergence"
---
## Deadly Triad
- <span style="color:rgb(0, 176, 80)">Function apprximation:</span> A powerful, scalable  way of generalizing from a state space much larger than the memory and computational resources (e.g., linear function approximation or ANNs)
- <span style="color:rgb(0, 176, 80)">Bootstrapping:</span> Update targets that include existing estimates (as in dynamic programming or TD methods) rather than relying elusively on actual rewards and compute return (as in MC methods)
- <span style="color:rgb(0, 176, 80)">Off-policy training:</span> Training on a distribution of transitions other than that produced by the target policy. Sweeping through the state space and updating all states uniformly, as in dynamic programming, does not respect the target policy and is an example of off-policy training
--- 
## The Deadly Triad
- The instability and divergence are
	- NOT due to control or generalized policy iterations (The issue happens even with the simpler prediction tasks)
	- NOT due to learning or uncertainties about the environment (The issue occurs just as strongly in planning methods (DP) in which the environment is completely known)
- <span style="color:rgb(192, 0, 0)"> If any two elements of the deadly triad are present, then instability can be avoided</span>
- It is natural, to go through the three and see if there is any one that can be given up

- Function approximation:
	- It is impossible to give this up for the scalability 
- Bootstrapping:
	- Maybe, but the data efficiency will be sacrificed by going back to MC
	- Also, MC is computationally expensive
- Off-policy training:
	- If you can use SARSA instead of Q-learning, go for it
	- But many practical problems, we use samples collected by other agents with other policies
- In conclusion, it is not always possible to give up these things in many practical situations
- We need to solve the divergence issue with another technique
---
## Another Issue: Catastrophic Forgetting
- The divergence issue is a common problem among the approximation methods
- The catastrophic forgetting is associated with gradient descent-based training methods in online training
- e.g. Assume that we generate different settings of the grid world game and train the DQN agent

![[catastrophic-forgetting.png]]
- Game 1
	- The agent takes RIGHT action and receives a positive reward
- Game 2
	- The agent takes RIGHT action and receives a negative reard
- A push-pull between very similar state actions (but with divergent targets) that results in this inability to properly learn anything
---
## Point 2. Experience Replay
- Instead of discarding a single experience after the gradient update,
- Store multiple experiences in a replay buffer
- Update the weights based on experiences sampled from the buffer
![[experience-replay.png]]

![[experience-replay-code.png]]

---
## Point 3. Target Net
- We can address this in our deep RL agent using a freezed target network
	- Hold the parameters used to compute the bootstrap targets
	- Only update them periodically (every few hundreds or thousands of updates)
--- 
### Why freeze
 - If you bootstrap using the same network you're updating, you create a feedback loop: your current update depends on the your current weights. This can amplify errors and lead to divergence
 - By freezing the target network for many steps (e.g. 1000 updates), you break that feedback loop
 - "It's like chasing something that is moving basically"
 
---
- More stable targets to compute the TD error
- This breaks the feedback loop that sits at the heart of the deadly triad
--- 
### Soft Update 
- Also, we can do soft update
	- $\theta^{Q'}\leftarrow \tau+\theta^Q+(q-\tau)\theta^{Q'}$
- Instead of copying the weights every few thousands steps (a "hard update"), you can slowly update the target network every step
![[target_net.png]]
---
## Further improvement: Deep Double Q-learning
- Q-learning has an overestimation bias, that can be corrected by double Q-learning
- Great combinations with target networks
	- We can use frozen params as $\theta^-$
---
## Further Improvement : Prioritized Replay
- DQN samples uniformly from the replay bufer
- Idea: Prioritize transitions on which we can learn much
- Basic Implementation:
	- Priority of sample i = (TD error)
- Sample according to priority
---
## Further Improvement: Multi-step Control
- Define the n-step Q-learning target
- The Return is partially on-policy and the bootstrapping is off-policy 
- A well-defined target: "On-policy for n steps, and then act greedy"
- Multi-step targets allow to trade-off bias and variance
--- 
## Asynchronous Advantage Actor-Critic (A3C)
- Deep RL algorithms that can train deep neural network policies reliably and with out large resource requirements (like GPU)
- Main Features:
	- <span style="color:rgb(0, 176, 240)"> Asynchronous Gradient descent </span> for optimization of deep neural network
	- <span style="color:rgb(0, 176, 240)"> Multiple actors-learners</span> (CPU threads) in parallel explore different parts of the environment and perform gradient updates independently and asynchronously
![[a3c-idea.png]]

![[a3c-code.png]]
- Actor-learners can have different exploration policies
- By running different exploration policies in differnt threads, the overall changes being made to the parameters by multiple actor-learners applying online updates in parallel are likely to be <span style="color:rgb(0, 176, 240)">less correlated in time</span>
	- <span style="color:rgb(0, 176, 240)">We don not use a replay memory and rely on parallel</span>
	- We are able to use on-policy reinforcement learning methods (since formally the replay buffer requires an off-policy method)
- Multiple parallel actors-learners reduce training time that is roughly linear in the number of parallel actor-learners
--- 
## Trust Region Policy Optimization (TRPO)
- In the normal policy gradient, we needed to choose a very small step size to keep new and old policies close in the <span style="color:rgb(0, 176, 240)">parameter space</span>
- Why? Even seemingly small differences in parameter space can have very large differences in performance
- However, this sacrifices the sample efficiency 
- TRPO updates policies by taking the largest step possible to improve performance, <span style="color:rgb(0, 176, 240)">while satisfying a special constraint on how close the new and old policies are allwed to be</span>
- The constraint is expressed in terms of KL-Divergence, a measure of (something like, but not exactly) distance between probability distributions
- 2 key concepts
	- Surrogate advantage (a measure of how the current policy $\theta$ performs relative to the old policy $\theta_k$)
	- KL- divergence ( a measure of how one probability distribution is different from a second)
## Surrogate Advantage
- The probability of taking action $a$ at state $s$ in the current policy divided by the previous one
	- If $\gt1$, the current policy chooses this action $a$ more than the previous policy
	- If $\lt1$, the current policy less likely chooses this action $a$ 
- A measure of the difference between two policies
- The advantage function 
	- $A(s,a) = Q(s,a)-V(s,a)$
- $A(s,a)$ indicates how good this specific action $a$, compared to the average performance of all actions possible at state $s$
	- If $\gt0$, action $a$ is better than the average
- Maximizing this ensures to improve the policy with a largest step
---
## Proximal Policy Optimization (PPO)
- PPO-Clip doesn't have a KL-divergence term the objective (as a constraint)
- Instead, PPO uses a ratio that will indicates the difference between the current and old policies and clip this ration from a specific range $[1-\epsilon,1+\epsilon]$
	ration = new_policy/old_policy
- When the advantage is positive
- <span style="color:rgb(0, 176, 240)">Compare the policy deviation ration and the upper bound defined by the hyperparam epsilon </span>
- Choose the smaller update (thus, bounded by the upper ceiling)

- When the advantage is negative
- Compare the policy deviation ration and the lower bound defined by the hyperparam epsilon
- Choose the smaller update (thus, bounded by the lower floor)
![[ppo.png]]
### What is the point of PPO?
- The goal of PPO is to make the agent learn better policies but to do it in a stable and reliable way
### Why not just update the policy directly
- In policy gradient methods, we try to improve the policy by making it favor good actions more. But if we update the policy to aggresively:
	- It can change to much
	- The new policy might become worse
	- Learning becomes unstable and can collapse
### How does PPO fix that?
- PPO says: "Lets improve the policy- but only a little at a time"
- This is done by:
	- Comparing the new policy to the old policy via a ratio
	- Clipping that ratio so updates don't change the policy to much
	- This ensures that good actions are reinforced, but not to aggressively


[[CS272]]


