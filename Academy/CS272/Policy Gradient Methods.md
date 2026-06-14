## Types of RL Algorithms
- So far, we have covered so-called "action-value" methods (e.g. Q-learning)
- They learned the values of actions and then selected actions based on their estimated action value
- Is there any other way
- Yes, policy Gradient methods
- Learn a parameterized policy that can select actions without consulting a value function
## Parameterized Policy
- What is a policy
- A policy is a function to map state-action pair to a probability to choose the action at the state
- Again, can we approximate the policy function
	- $\pi(a|s)=Pr\{A_t=a|S_t=s,\theta_t=\theta\}$
![[policy-function.png]]


## Policy Gradient Methods: General Schema
1. Define a performance function $J(\theta)$ that indicates the performance of the policy parameterized by $\theta$
2. Solve a maximization problem of the performance function by taking gradient ascent steps
	- $\theta_{t+1}=\theta_t+\alpha\nabla J(\theta_t)$
	- Maximization problem basically just trying to maximize reward
## How do you solve a maximization problem
- A simple mathematical Solution
	- $J(w)=-w^2$
- Differentiate J with respect to w
- It is not always possible with a complex objective function 
- Also, it tends to be computationally expensive
- Gradient Ascent (GA)
	- Starting from an initial point $w_0$
	- Always find another point $W_{t+1}$ that the corresponding function value increases, compared to the one at the previous point $w_t$
		- $J(w_{t+1})\ge J(w_t)$
- The gradient $\nabla J(w)$ of a scalar-valued differentiable function $J$ at a point w
- Basically this is the opposite as gradient descent take a look in deep learning for more info on this

## Softmax in action preferences
- Assume: the action space is discrete and not too large
- Define parameterized numerical preferences ( a larger value indicates that the state action pair is more preferred)
	$h(s,a,\theta)$
	- This is called the preference function or action preference score
	- Basically taking the softmax over all actions in a given state, where each action's "score" is computed using $h(s,a,\theta)$
## Gaussian Distribution
---
### Imagine a Cupcake Shop…
Let’s say you measure how many cupcakes people buy when they come in:
- Most people buy **about 3 cupcakes**.
- Some buy **2 or 4**.
- Fewer people buy **1 or 5**.
- Very few buy **0 or more than 6**.
If you draw a graph of how many people bought each amount, it looks like a **hill**—highest at 3, and lower as you go further out.  
That **hill shape** is the **Gaussian distribution**, also known as the **normal distribution** or **bell curve**.
###  Key Concepts:
- **Mean (μ)** = the average (center of the hill)
- **Standard Deviation (σ)** = how spread out the data is
---
- Instead of computing learned probabilities for each of the many actions, we can learn statistics of the probability distribution
- For example, when we assume that there is a set of similar actions that perform well, we can use a Gaussian distribution
- The probability density function
	- $p(x)\stackrel{\cdot}{=} \frac{1}{\sigma\sqrt{2\pi}}exp(-\frac{(x-\mu)^2}{2\sigma^2}$
- Therefore, the parametric policy function 
	- $\pi(a|s,\theta)\stackrel{\cdot}{=} \frac{1}{\sigma(s,\theta)\sqrt{2\pi}} exp(-\frac{(a-\mu(s,\theta))^2}{2\sigma(s,\theta)^2}$
--- 
### In English the above function means:
- The policy says: Given a state s, the action a is sampled from a normal distribution whose mean and standard deviation are computed from the state using the policy parameters $\theta$
-  $μ(s,θ)$ = the **most likely (mean) action** to take in state s.
- $σ(s,θ)\sigma(s, \theta)σ(s,θ)$ = how **uncertain** or **random** the action choice is (spread of the distribution).
- The equation says: "actions close to the mean are more probable; actions far from the mean are less probable."
---
- In a parameter vector, one part to be used for the approximation of the man and one part for the approximation of the standard deviation
	- $\theta=[\theta_\mu,\theta_\sigma]^\top$
- e.g., The mean can be approximated as a linear function; the standard deviation must always be positive and is better approximated as the exponential of a linear function
	- $\mu(s,\theta)\stackrel{\cdot}{=}\theta_\mu\top x_\mu(s$) and $\sigma(s,\theta)\stackrel{\cdot}{=}exp(\theta_\sigma\top x_\sigma(s))$

## Policy Performance Function J
- In an ergodic 
	- Where the steady-state distribution $\mu(s)\theta)\stackrel{\cdot}{=}lim_{t\rightarrow\infty}pr\{S_t=s|A_{0:t}~\pi\}$ exists and is independent of $S0$
	- I.e., the starting state of any early decision made by the agent can have only a temporary effect; in the long run of the  expectation of being in a state depends only on the policy and the MDP transition probabilities
## The Policy Gradient Theorem
- Provides analytic expression for the gradient of performance J with respect to the policy parameter $\theta$
- When sampling episodes, the distribution of state visits should be represented in the simple average based on the current policy

## REINFORCE: Monte Carlo Policy
- Similarly, we can replace the sum over all actions a with a sampled $At$ in an experience
- Based on the previous derivation if $\nabla J(\theta)$,
	- $\theta_{t+1}\stackrel{\cdot}{=} \theta_t+\alpha G_t \frac{\nabla\pi(A_t|S_t,\theta_t)}{\pi(A_t|S_t,\theta_t)}$
- The update increases the parameter vector in this direction
	- proportional to the return (it causes the parameter to move most in the directions that favor actions that yield the highest return)
	- Inversely proportional to the action probability (otherwise actions that are selected frequently are at an advantage \[the updates will be more often in their direction] and might win out even if they do not yield the highest return)
		- Basically if the policy assigns low probability to the action $a$, the log probability is very negative, and its gradient is a large magnitude
		- In REINFORCE, the policy gets updated more strongly when a surprising (low-probability) action results in high reward
		- This is what it means to be inversely proportional to the action probability - low probability, high-reward actions lead to bigger updates
![[REINFORCE.png]]

## Advantage of Policy Approximation
1. The policy may be simpler function to approximate
	- Action-value methods may over complicate the approximation by estimating individual Q values
2. The softmax enable the selection of actions with arbitrary probabilities
	- An optimal policy could be stochastic
	- Action-value methods can not produce it
	- E.g. Bluffing in poker
3. You can inject prior knowledge about the desired form of the policy
	- Initialization and the function form can provide a bias (in a good way if designed well)
4. Stronger convergence guarantees are available
	- A series of intermediate policies show the continuity
## Note REINFORCE suffers with large action spaces due to high variance 
## Notes on REINFORCE
- (By construction) the expected update over an episode is in the same direction as the performance gradient
- This assures
	- An improvement in expected performance for sufficiently small step size (alpha)
	- Convergence to a local optimum under standard stochastic approximation conditions for decreasing step size
- However, as REINFORCE may be of high variance (due to the MC concept) and thus produce slow learning

## REINFORCE with Baseline
- We subtract a baseline function b(s) from the policy gradient
- Intuition: A smaller value function makes the gradient smaller (and more stable updates)
- The baseline can be any function, even a random variable, as long as it does not vary with action a
- One natural choice for the baseline is an estimate of the state value $\hat{v}(S_t,w)$
- Basically trying to reduce amount of variance
![[Baseline.png]]
### Example:
Say you're in state s, and you took action a:
- Without baseline:  
    You got $Gt=20G_t = 20Gt​=20$, so you update with $+20⋅∇θlog⁡π(a∣s)$
- With baseline:  
    If $b(s)=15b(s) = 15b(s)=15$, then your **advantage** is $20−15=5$, and you update with $+5⋅∇θlog⁡π(a∣s)$
This is more measured and stable.
- Can we modify the REINFORCE ideas and use the idea of TD approaches
- YES
- Just replace the target value similar to SARSA with the reward of the next state rather than the return
## Actor-Critic Method
![[AC.png]]
- You have two separate entity:
	- <span style="color:rgb(0, 176, 80)">Actor: updates the policy function </span>(parameters $\theta$)
	- <span style="color:rgb(0, 176, 80)">Critic: Updates the action-value function (parameters w)</span>
- The action values estimated by the critic influence the policy update
- The bootstrapped one-step return is often superior to the actual return in terms of its variance

![[AC-methods.png]]
## The Advantage Function
- What does it mean to use the TD error when updating the policy?
	- $\delta_{\pi\theta}=r+\gamma V_{\pi\theta}(s')-V_{\pi\theta}(s)$
- This is similar to the baseline approach
- We compute the relative impact of taking action $a$ based on the average performance of state $s$
- So basically it's the same as REINFORCE baseline but just uses the reward of the next state and is still using the value function to handle the stability issue 

[[CS272]]