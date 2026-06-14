- "Learning" setting involves some temporal nature of the domain and the regularity across time
- An agent's next choice depends on the history of play
- The agent could guess that the frequency of actions played by his opponent in the pas and play a best response to that mixed strategy. (fictitious play)

## More knowledge, Better Performance?
- More knowledge isn't always beneficial
- In the abstract more knowledge doesn't hurt since it can be ignored
	- Note computers are limited in memory so can be an issue
- But when when one pre-commits to a particular strategy for acting on accumulated knowledge, sometimes less is more
## Optimal Learning
- No such thing as optimal for every possible behavior
- Learning a strategy is simply a strategy in a game that happens to have a component that is naturally viewed as adaptive
## How do we evaluate learning?
- Ask whether a learning strategy achieves payoffs that are "high enough"
	- <span style="color:rgb(0, 176, 80)">Saftey:</span> A learning rule is safe if it guarantees the agent at least its maximin payoff, or "security value."
	- <span style="color:rgb(0, 176, 80)">Rationality:</span> A learning rule is rational if whenever the opponent settles on a stationary strategy, the agent settles on a best response to that strategy
	- <span style="color:rgb(0, 176, 80)">No-Regeret:</span> A strategy that guarantees the player that in hindsight no single action when played throughout the game would have performed significantly better

## Fictitious Play
- Simple learning method, which involves
	- Belief about the opponent
	- Observation of the actual plays
- Usually viewed as a model of learning
- Basically we have some belief about the opponents strategy for example:
	- Believe that the opponent will throw rock, in rock paper scissors 
	- So the agents move should be paper
## Belief
- An agent believes that his opponent is playing the mixed strategy given by the empirical distribution of the opponent's previous actions
- The agent assesses the probability of $a$ in the opponent's mixed strategy as:
	- $P(a) = \frac{w(a)}{\sum_{a'\in A}w(a')}$
	- Where A: All actions in the past
	- w(): number of times the opponent having take the action a
## <span style="color:rgb(0, 176, 80)">Empirical Distribution</span>
- "An **empirical distribution** is a **data-driven estimate** of a probability distribution based on **observed frequencies** from past data"
- Idea is that instead of assuming a known theoretical probability distribution, the empirical distribution is built directly from data by counting how often each outcome occurs
- This is what makes it useful in reinforcement learning

## Trial-and-Error Search
- Exploration: Try out new actions to find better solutions
- Exploitation: You use a sequence of actions that performed well in past runs
	- Kind of like a greedy approach to things

## Current Decision and Future Possibilities 
- All involve interactions between an active decision-making agent and its environment
	- The agent seeking to achieve a goal
	- Uncertainty about its environment
- Agent's actions are permitted to affect the future state of the environment
	- E.g. the next chess position
	- E.g. the robot's next location & future charge level of its battery
	- I.e. The actions and opportunities available to the agent at later times are affected by the current action 

## State/Action
- <span style="color:rgb(0, 176, 80)">An action is a method that allows an agent to interact and change its environment</span>
- <span style="color:rgb(0, 176, 80)">A state of an environment is a representation of the current world</span>
- Note: A state is not always the same as an observation
## Reward
- A reward is a numerical feedback signal
- It indicates how well the agent is doing at that round (immediate feedback)
- Reinforcement learning is based on "reward hypothesis"
## Reward Hypothesis
- All goals (practical tasks to learn) can be described by the maximization of expected cumulative reward
- E.g. Manage an investment portfolio
	- Monetary reward (current balance)
	- Investment distribution
- E.g. Make a humanoid robot walk
	- Positive reward for moving forward
	- Negative reward for falling
	- Joint movement planning
## Delayed Reward
- You may want to sacrifice immediate positive reward for a bigger future reward
	- Actions may have long term consequences (future available actions may be limited by pas actions)
	- Examples:
		- Buying a cup of Starbucks almost every day $5 x 300 = $1,500
		- Instead should not buy Starbucks so often and save to buy a new MacBook

## Policy
- <span style="color:rgb(0, 176, 80)">Mapping from states to actions</span>
	- Basically describing the decision making strategy the agent uses based on it's current understanding of the world (the environment)
	- State represents the current state of the environment
	- Now based on this current state of the environment
- I.e. decide an so-far best action for a given observation (state)
- Note: we are trying to learn an optimal policy through RL

## Model
- A theoretical entity that mimics the behavior of the environment
- More generally, a model allows inferences to be made about how the environment will behave given a state and an action
- There is model based and model free based 
	- Model based:
		- E.g. Rock paper scissors
			- if you know an exact probability distribution over R/P/S (model),
			- You can uses this knowledge to devise an optimal policy
		- This is called planning, <span style="color:rgb(192, 0, 0)">which does not involve try and error searches</span>
	- Model Free based:
		-  E.g. Rock paper scissors
			- if you <span style="color:rgb(192, 0, 0)">DO NOT </span>know an exact probability distribution over R/P/S (model),
			- you need to figure out an optimal policy by observing the opponent
		- <span style="color:rgb(192, 0, 0)">This approach is model-free methods, which DO involve try and error searches</span>

## Difference between RL and other ML
- There is no supervisor, only a reward signal
- Feedback is delayed, not instantaneous
- Time really matters (sequential, Non I.I.D Data)
- Agent's actions affect the subsequent data it receives



[[CS272]]