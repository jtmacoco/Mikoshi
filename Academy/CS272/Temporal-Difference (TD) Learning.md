## MC VS. TD(0)
-  Target value
	- <span style="color:rgb(0, 176, 240)">MC: A sampled return G</span>
	- <span style="color:rgb(0, 176, 240)">TD(0): A sampled reward and the action value </span>$R + Q(S',A')$
- Update
	- MC: Wait until the return following the visit is known
	- TD(0): Wait only until the next time step (<span style="color:rgb(192, 0, 0)">bootstrapping</span>)
		- Bootstrapping is instead of waiting until the end of an episode to see the final return like MC methods, TD methods bootstrap by using the current estimate of the value of the next state to update the current state's value
		- At time $t+1$ they immediately form a target and make a useful update using the observed reward
		- Basically use the immediate estimate rather than the episode and update using thate 

## Ex: Driving Home

| State                       | Elapsed Time (mins) | Predicted Time to Go | Predicted Total Time |
| --------------------------- | ------------------- | -------------------- | -------------------- |
| Leaving office, Friday at 6 | 0                   | 30                   | 60                   |
| Reach car, raining          | 5                   | 35                   | 40                   |
| Exiting highway             | 20                  | 15                   | 35                   |
| 2ndary road, behind truck   | 30                  | 10                   | 40                   |
| Entering home street        | 40                  | 3                    | 43                   |
| Arrive home                 | 43                  | 0                    | 43                   |
- The rewards in this example are the elapsed times on each leg of the journey
- No Discounting
- The value of each state is the expected time to go

![[td.png]]
- One on left is MC
- One on right is TD(0)
- So TD(0) suggests updates at each time step (even before the actual travel time gets know)
- Is it reasonable to suggest updates even on the way?
	- You become stuck in a massive traffic jam
	- 25 minutes after leaving the office, you are still bumper-to-bumper on the highway
- As you wait in traffic, you already know that your initial estimate of 30 minutes was too optimistic
	- MC: Still wait until the end to update the state value (expected waiting time)
	- TD(0): Learn immediately, shifting your initial estimate

## Advantages of TD(0)
- Naturally implemented in an online, fully incremental fashion
	- Some applications have a very long episodes, so that delaying all learning until the end of the episode is too slow
	- Other applications are continuing tasks and have no episodes at all (MC can't be used for these)
- <span style="color:rgb(192, 0, 0)">TD has a low variance, some bias</span>
- <span style="color:rgb(192, 0, 0)"> MC has high variance, zero bias</span>
- <span style="color:rgb(0, 176, 80)">Variance: How much your estimate fluctuates due to randomness in data</span>
- <span style="color:rgb(0, 176, 80)">Bias: Error introduced approximating a complex problem with a simpler model</span>
## SARSA

![[sarsa.png]]
- This is an example of TD learning SARSA
- <span style="color:rgb(0, 176, 80)">SARSA stands for state action reward state action</span>
- This is on policy since $a'$ is the actual action taken in state $s'$, chosen using the same behavior policy like epsilon greedy
- This means we're learning about the same policy we're following

## Q-learning
![[q-learning.png]]
- This an example of off policy and using TD
- So the reason this is off policy is because we don't use the action you actually took in $s'$
- Instead, we assume we would have acted greedily in $s'$, even if we didn't'
- So we learn about the optimal (greedy) policy, even if we're behaving using epsilon greedy
- Jonathan this is what you wrote at some point in notes:
	- In q-learning it basically chooses an action use e-greedy, then takes that action, then it updates it's q values using the arg max q value from the next state, i.e. the state it got from taking the action using e-greedy. This makes it off policy since it's following the e-greedy but updating the q values which is the policy using the argmax


![[q-learing_vs_sarsa.png]]

- This is a visual difference between the 2


## The Maximization Bias
- SARSA with the epsilon-greedy (involving a max operation)
- Q-learning with a max operation
- These maximization in their policy gives positive bias to the estimation of the value function
- Basically it will learn the optimal policy much slower since it will make slight inaccuracy and overestimate some actions due to noise
- To fix use double q-learning

## Mitigating the Maximization Bias
- Using the same samples (plays) both to determine the maximizing action and to estimate its value
- We divide the plays in two sets and used them to learn two independent estimates: $Q_1(s,a)$ and $Q_2(s,a)$
- Coin-flip after each experience
	- If the coin comes up heads, the update is on $Q_1$
	- Otherwise, on $Q_2$
- This concept is called double learning
- Double learning means using two separate value estimates to reduce bias caused by always taking the maximum over noisy estimates
	- So instead of relying on one estimate for both
		- Selecting the best action
		- Evaluating the value of that action
	- We split the job across two independent estimators
- Basically double learning reduces overestimation bias by decoupling action selection and action evaluation across two independent value estimators, like having 2 q-tables
![[double-q-learning.png]]

[[CS272]]