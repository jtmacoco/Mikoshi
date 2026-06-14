- MDPs involve delayed reward and the need to tradeoff immediate and delayed rewards
- A Markov Decision Process is a tuple < S, A, P, R, $\gamma$>
	- <span style="color:rgb(0, 176, 80)">S: A finite Set of states </span>
		- So a finite area like a board game since it has a finite set of moves you can play
	- <span style="color:rgb(0, 176, 80)"> A: A finite set of actions</span>
		-  So moving up, down, left, right, etc.
	- <span style="color:rgb(0, 176, 80)">P: A state transition probability matrix</span>
		- $P[S'|s,a]$ 
			- This means the probability of transition to state $s'$ from state $s$ taking action $a$
	- <span style="color:rgb(0, 176, 80)">R: A reward function</span>
		- $R(s,a,s')$
	- $\gamma$: Discount factor in $[0,1]$ range

## A Policy
- A policy is a distribution over actions given states
	- $\pi(a|s)=P[a|s]$
	- A policy fully defines the behavior of an agent
	- <span style="color:rgb(192, 0, 0)">MDP policies depend on the current state (not the history of sequence of actions as this is a property of Markov Chains which MDP builds off of)</span>

## Why MDPs are ideal
- Allow agents to:
	- Act over time
	- See how choices affect future outcomes
- They allow for theoretical guarantees
	- Since MDPs are mathematically well-defined
	- Can prove things like convergence and optimality
	- Algorithms like Q-learning or Value iteration work under MDP assumptions
- So they're ideal because they provide:
	- Structure for learning from rewards over time
	- A balance of realism and mathematical simplicity
	- A foundation for designing and analyzing RL algorithms
## Policy vs Transition Probability
- Policy defines which action to take
	- Intentional
	- You have control over it
	- Better policy gives better rewards
- Transition decides where to go
	- Given to by the environment
	- <span style="color:rgb(192, 0, 0)">You don't have control over this</span>
	- A better policy should be selected guessing this probability 
	- So this basically is saying if your in State A and take action X, what's the chance you'll end up in state B
	- Ex:
		- Action A moves you forward with **90% chance**, but sometimes drops you back.
		- Action B moves you sideways with **50% chance** and does nothing the rest of the time.
	- If you **know or estimate** these probabilities, you’ll **choose the action (policy)** that leads to better long-term outcomes.

## The probability of Moving from s to $s'$
- How can we compute the probability of moving from $s$ to $s'$, given a policy $\pi$
	- $P_pi[s'|s] = \sum_{a\in A}\pi(a|s)P[s'|s,a]$
- So to find the chance of reaching state $s'$ from s under policy $\pi$,  you average over all actions, weighting each by:
	- how likely your policy is to pick that action and
	- how likely that action is to take you to $s'$

## The Markov Property
- The future states of a stochastic process are influenced only by the present, not the past, meaning that the past can be disregarded once the present is known
	- $P[S_{t+1}|S_t] = P[S_{t+1}|S_1,...,S_t]$
## The Reward Hypothesis
- All of what we mean by goals an purposes can be well though of as the maximization of the expected value of the cumulative sumo of a received scalar signal (called the reward)
- Utility theory
	- Explaining individuals' choices and measures their level of satisfaction from consuming a good or service
- <span style="color:rgb(192, 0, 0)">The reward is meant  to  communicate what we want the robot or agent to achieve not how we want it achieved</span>

## Returns and Episodes
- A reward
	- An immediate feedback signal for an action of the agent
- Our objective
	- To maximize the cumulative reward it receives in the long run
- An episode
	- A sequence of state s, action a, and reward r
- (0,0,) U, -1 (0,1), R, -1, (1,1), R, -1, (2,1), U, 10, (Goal) (this is the episode)
	- U: up
	- R: right
- What is the return of G in the episode above
	- G = -1 + -1+ -1 + 10
- Formally, a return from state $S_t$ is
	- $G_t \stackrel{\cdot}{=} R_{t+1} + R_{t+2}+ R_{t+3}+...+R_{T}$

## Episodic vs. Continuing Tasks
- Each episode ends in a special state called the terminal state,
	- The task is called "episodic"
	- Finite length of actions always bring the agent to the end of a trial
- The agent-environment interaction does not break naturally into identifiable episodes, but goes on continually without limit
- The agent-environment interaction does not break naturally into identifiable episodes, but goes on continually without limit
	- The task is called "continuing"
	- Infinite length of actions
	- Ex: Self driving cars are continuous
## A Discounting Factor
- A discount factor determines the present value of future rewards
- $G_t \stackrel{\cdot}{=} R_{t+1} + R_{t+2}+ R_{t+3}+...+R_{T} = \sum_{k=0}^\infty \gamma^k R_{t+k+1}$
- If $\gamma = 0$, the agent is myopic (short sighted)  
	- So only cares about the immediate reward
- if $\gamma$ is close to 1, then the agent is far-sighted
## Why Discount Factor Needed
- <span style="color:rgb(192, 0, 0)">How much we value future rewards</span>
- Many situations a reward now is more valuable than reward later
	- Think like getting $10 now vs getting $10 in a year
- Helps avoid infinite rewards in continuous tasks
	- Without a discount, if an agent keeps receiving rewards forever, the total reward would be infinite, making the learning unstable
- Reflects uncertainty about the future
	- The farther away a reward is, the less certain the agent is about actually receiving it
- Analogy
- <span style="color:rgb(112, 48, 160)">Analogy: Money Now vs. Money Later</span>
	- Imagine you have two choices:
	- **Option 1:** Get **$100 today**.
	- **Option 2:** Get **$110 a year from now**.
	- Which one would you pick?
		- If you **discount the future** (like γ < 1), you might prefer $100 now because waiting a year is uncertain.
		- If you **don’t discount much** (γ ≈ 1), you might wait for the extra $10 because future money is almost as good as present money.
	- In RL, the agent faces similar choices:
		- Should it take a small reward now?
		- Or wait for a bigger reward later?  
		    The discount factor helps it decide.

## The Returns
- A return represents a long-term feedback for a sequence selected by your actions
	- Basically the total accumulated reward an agent receives, staring from a particular time step and going into the future
## Value Functions
- <span style="color:rgb(192, 0, 0)">Tells us how good a state is basically </span>
## The State Value Function
- When you want to evaluate states it is NOT enough to use the return from a single trial
- We need to asses the average return from the state
- $v_\pi(s) \stackrel{\cdot}{=}\mathbb{E}_\pi[G_t|S_t=s]$
	- which equals = $\mathbb{E}[ \sum_{k=0}^\infty\gamma^k+R_{t+k+1}|S_t=s]$
	- K in this function is the step counter, so how far into the future a reward is
- <span style="color:rgb(0, 176, 240)">A state value basically just tells us how good it is to be in a certain state, assuming we act in a certain way following a policy</span>
- <span style="color:rgb(192, 0, 0)">Measures how good a state s is under policy </span>$\pi$
- Ex:
	- Imagine you're playing a game, and you're currently in a certain situation (a "state"). 
	- The **value of that state** is the **average amount of points (or rewards)** you expect to get **from now on** if you play the game the usual way.
## The Action Value Function
- Similar to the value of state, we can define the average return from a state taking an action
- $q_\pi(s,a)\stackrel{\cdot}{=}\mathbb{E}_\pi[G_t|S_t=s,A_t=a]$
	- which equals $\mathbb{E}[ \sum_{k=0}^\infty\gamma^k+R_{t+k+1}|S_t=s,A_t=a]$
- This is basically telling you how good it is to take action a in state s if I follow this policy afterward
- <span style="color:rgb(192, 0, 0)">Measures how good a state-action pair (s,a) is under policy </span>$\pi$

## Optimal Policies and Optimal Value Functions
- Solving a reinforcement learning task
- = finding a policy that achieves a lot of reward over the long run
- The bellman expectation equation (the values of states) depends on a policy 
- We want to find an optimal policy
	- A policy X is said to be better than a policy Y
	- if its expected return is greater than or equal to that of Y's expected return
	- $\pi \geq \pi'$ if and only if $v_\pi(s)\geq v_\pi'(s)$ <span style="color:rgb(192, 0, 0)">for all states</span>
## The Bellman Optimality Equation
- Expresses the fact that the value of a state under an optimal policy must equal the expected return for the best action from that state
- If you're in the best possible state, and you always make the best possible action, the the value of being in that state equals to:
	- the reward you get now plus what you expect to get int he future if you keep making the best choices
### Think of it like this:
- You're playing a game and want the highest score.
- From your current position (state), you look at all the possible moves (actions).
- The **best move** gives you the **highest expected total points**, now and later.
- The Bellman Optimality Equation captures this logic mathematically.



[[CS272]]