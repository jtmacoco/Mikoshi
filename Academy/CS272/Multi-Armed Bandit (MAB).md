## Evaluative feedback vs. Instructive feedback
- What distinguishes reinforcement learning from other types of learning
- The use of training information that evaluates the actions taken rather than instructs by giving correct actions
	- <span style="color:rgb(0, 176, 80)">Evaluate feedback:</span> Indicates how good the action taken was, but not whether it was the best or worst action possible 
	- Instructive feedback indicates the correct action to take, independently of the action actually taken (supervised learning)
- We are going to analyze the fundamental characteristics of evaluative feedback using the Multi-Armed Bandit problem 
## The Bandit
- Assume: k slot machines in front of you
- You will select one of the machines to bet at each round
- After each choice, you receive a numerical reward chosen from a stationary probability distribution
- Goal: find a best slot machine to bet on average
- If you are given the underlying distribution, you win!
- In practice, the distribution is unavailable 
- A key is to find out the true expected reward
## The value of an Action
- Similar to the state values, we can define the value of action (slot machine)
	- $q_*(a)\stackrel{\cdot}{=}\mathbb{E}[R_t|A_t=a]$
	- q val only for action
- Only way to estimate the value is to collect more rewards
- <span style="color:rgb(0, 176, 80)">Exploiting:</span> Repeat good actions based on your current knowledge of the values of the actions Repeat good actions but don't try anything  new, so don't know if there are better options
- <span style="color:rgb(0, 176, 80)">Exploring:</span> Try new actions or bad actions to improve your estimate of the actions' values
- How do you balance the two?
## $\epsilon$-greedy method
- Choose a random action with the probability $\epsilon$
- Use a greedy action with probability $1-\epsilon$
- If epsilon 1 or closer to 1 explore more 
- If epsilon is small then explore less and exploit more
## Incremental Implementation
- To compute the average after i-th action, a naive implementation requires a list of rewards
	- $Q_n\stackrel{\cdot}{=}\frac{R_1+R_2+...+R_{n-1}}{n-1}$
- The memory and computational requirements would grow over time as more rewards are seen
### Key Idea: Keep a running average so you don't need to remember everything
- So keep a running average of the average reward over time
## Optimistic Initial Values
- Exploration depends to the initial action-value estimates (biased by the initial values)
- Initial action values can also be sued as a simple way to encourage exploration 
- e.g. An initial estimate of +5 is wildly optimistic (based on the previous diagram)
- This optimism encourages action-value methods to explore
- The learner switches to other actions, being "disappointed" with the rewards it is receiving
## Key Idea: Start off overly confident so you're force to explore

## Upper-Confidence-Bound (UCB)
-  Is there anyway to quantify the accuracy of the value estimate
- In a stationary scenario, more samples should give better estimates (Law of Large Numbers)
- We will define the UCB of each arm so that 
	- It becomes larger if the arm that has not been visited to many times
- Action selection can be greedy based on the current estimate and the UCB
	- $a_t=\arg\max_{a \in A}(\bar{Q}_t(a)+U_t(a))$
	- $\bar{Q}$ means the average reward received so far for taking action a
## Comparing UCB and Epsilon-greedy
- In practice, the epsilon-greedy method works really well (but may require some tuning)
- UCB is a safe choice as it has theoretical guarantee to perform well in general (not necessarily the best)
[[CS272]]