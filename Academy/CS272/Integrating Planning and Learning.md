## Model-based vs Model-free
- Given an MDP, a model-based algorithm solves the panning problem
	- Exhaustive search
	- Dynamic Programming
- Without MDP, a model-free method solves the learning problem
	- MC
	- TD
- All the methods are based on 
	- Looking ahead to future events
	- computing a backed-up value
	- using it as an update target for an approximate value function
---
## An Example
- If you search the exact model of an environment
	- $v(s0)=5$
- If you use a model-free update
	- Initial value: $v(s0)=0$
	- Alpha = $0.1$
	- $V(s0)=0+0.1*(5-1)=0.5$
	- and this goes on
- If you have a complete model, model based approaches are sample-efficient
- <span style="color:rgb(0, 176, 240)">Can we integrate these two approaches?</span> 
--- 
## Integration of Planning and Learning
- A model is not available! This was the main motivation for model-free methods
- Can we construct (estimate) a model? 
- Here, a model is a mapping of (state, action) to (Successor state, reward)
	- $p(s',r|s,a)$
- A simplest way to construct a model is to record the experiences and produce simulated experience for value updates
 model -> simulated experience -> backups values -> policy
 ---
## Real vs Simulated experiences
- Real vs Simulated experiences
	- An agent interacts with the actual environment and sample real experiences
	- An agent interacts with the constructed model and sample simulated experiences
- <span style="color:rgb(192, 0, 0)"> Real experiences are used to </span>
	- Learn a model
	- Update the value function (direct RL- What we have learned so far)
- <span style="color:rgb(192, 0, 0)">Simulated experiences are used to update the value function (indirect RL- What we have learned so far with simulated experiences from a model)</span> 
	- Instead of learning only from real experience, the agent learns by thinking ahead using a model 
### <span style="color:rgb(112, 48, 160)">Analogy:</span> Imagine you're training to play chess. You could: 
 - Play real games (real experience)
 - Or you could image impossible moves in your head and see how they might play out (simulated experience)
![[tabular-dyna-q.png]]
![[general-dyna-q-arch.png]]

---
## An Example: Dyna Maze
- 47 states
- Four actions: up, down, right, and left
	- Each action takes the agent deterministically to the corresponding neighboring state
	- Movement is blocked by an obstacle or the edge of the maze, in which case the agent remains where it is
- Reward is 0 on all transitions, except those into the goal state, on which it is +1
![[ex-dyna.png]]
---
Challenges in Nondeterministic Environment
- Assume a dynamic Maze environment where the obstacles move after some time
- Obviously, Dyna-Q suffers with the environment
- Dyna-Q+ is a very simple enhancement of Dyna-Q with an exploration bonus that encourages exploration 
	- If the modeled reward for a transition is r, and the transition has not been tried in $\tau$ time steps, then planning updates are done as if that transition produced a reward for $r+k\sqrt{\tau}$ for some small $k$
	- ### In plain English:
		- Suppose your model predicts that doing a certain action in a state gives you reward $r$
		- But you haven't tried that action  in a while - specifically, for $\tau$ time steps
		- Then, during planning (when using the model to simulate and learn), you pretend the reward is a bit higher that $r$
---
## Prioritized Sweeping
- Similar to prioritized Experience Replay
- You can sample the simulated experiences based on the TD error, instead of uniform sampling
![[sweeping.png]]
---
## Rollout Algorithms $R+\gamma Q(s',a')$
- In Dyna-Q, we used the one-step (bootstrapped) value of a state in the model to update the value function
- Can we generalize this?
	- Exhaustive search of trajectories is infeasible due to the computational cost
	- Sample trajectories (multiple associated returns)? How should we sample?
-  The goal of a rollout algorithm is  NOT to estimate a complete optimal action-value function Q
- Instead, they produce estimates of action values only for each current state and for a given policy usually called the rollout policy
- Rollout algorithms make immediate use of these action-value estimates, then discard them
- This makes rollout algorithms relatively simple to implement 
	- No need to approximate a function over either the state space or the state-action space
- A famous example of rollout: Monte Carlo Tree Search (MCTS)
--- 
Monte Carlo Tree Search (MCTS)
- When the environment changes to a new state, MCTS executes as many iterations as possible before an action needs to be selected
- Incrementally building a tree who's root nodes represents the current state
![[mcts.png]]
- <span style="color:rgb(0, 176, 80)">Selection: </span> Starting at the root node, a tree ($\pi(T)$) policy based on the action values attached to the edges of the tree traverses the tree to select a leaf node
- <span style="color:rgb(0, 176, 80)">Expansion:</span> On some iterations (depending on details of the application),<span style="color:rgb(0, 176, 240)"> the tree is expanded from the selected leaf node</span> by adding one or more child nodes reached from the selected node via unexplored actions
- <span style="color:rgb(0, 176, 80)">Simulation:</span> From the selected node, simulation of complete episode is run with actions selected by the rollout policy
- <span style="color:rgb(0, 176, 80)">Backup:</span> The return generated by the simulated episode is backed up to update the action values attached to update the action values attached to the edges of the tree traversed by the tree policy
	- No values are saved for the states and actions visited by the rollout policy beyond the tree
---
## Use of MCTS in Action Selection
- <span style="color:rgb(0, 176, 240)">MCTS continues executing these four steps, starting each time at the tree's root node, until no more time is left</span>
- The, finally, an action from the root node (which still represents the current state of the environment) is selected according to some mechanism that depends on the accumulated statistics in the tree 
	- At the end of the MCTS search
	- The root node is the current state you're actually in ( the current board position)
	- You've done a bunch of simulations (rollouts), and now you need to actually pick a real action to take
	- You choose the action based on the data you've collected during the simulations 
- This enables a smarter update of the value function based on the model
- Be aware of the tradeoff between the accuracy and computational cost
--- 
## Imagination-Augmented Agent (I2A) Architecture
- An architecture for deep reinforcement learning combining model-free and model-based aspects
	- I2A is a type of agent that learns both from real experience (model free) and from Imagined future experiences (model based)
- It uses approximate environment models by "learning to interpret" their imperfect predictions
	- Given information from the present
	- Environment Model (EM) is queried to make predictions about the future
	- (Simulation of imagined trajectories, which are interpreted by a neural network)
	- So I2A doesn't require a perfect model of the environment
	- Instead , it learns to interpret the (possibly inaccurate) predictions from a learned model
	- So even if the model's guesses about the future are a little off, I2A can still make good use of them
	- <span style="color:rgb(112, 48, 160)">Analogy:</span> 
		- Imagine you're playing chess and your brain says:
		- "If I move here, I think my opponent might respond like this ... then i'll do that..."
		- Even if your predictions aren't perfect, you still use them to make smarter decisions
		- Basically how I2A works lol
- In general, an environment model is any recurrent architecture which can be trained in an unsupervised fashion from agent trajectories
	- Simple terms: an environment model is a neural network that learns to predict what will happen next based on the agent's action by watching what actually happens during training
	- <span style="color:rgb(0, 176, 240)">It's often recurrent, meaning it remembers past steps like an RNN</span>
	- It learns by observing sequences of state-action pairs, no labels are needed
	- Given a past state and current action, the environment model predicts the next state and any number of signals from the environment
	- E.g. Action-conditional next-step predictors, which
		- Receive as input the current observation (or history of observations) and current action and
		- Predict the next observation, and potentially the next reward
- A convolution network transforms this into a pixel-wise probability distribution for
	- the output image, and reward
![[i2a.png]] 
- Uses images because not all games have a hard-coded state space so uses images to understand the state space basically like Atari for example
- Trajectories may contain information beyond the reward sequence
	- E.g. A trajectory could contain an informative sub sequence for instance solving a sub problem which did not result in a higher reward
- Therefore, I2A uses a rollout encoder E that processes the imagined rollout as a whole and "learns to interpret it"
	- By extracting any information useful for the agent's decision, or 
	- Even ignoring it when necessary 
- Each trajectory is encoded separately as a rollout embedding 
- <span style="color:rgb(0, 176, 240)">Helps remove noise like in GEN-AI</span>
![[I2A-full.png]]

- <span style="color:rgb(190, 45, 137)">MAYBE USE DIFFUSION INSTEAD OF CNN'S won't work to long</span>
[[CS272]]