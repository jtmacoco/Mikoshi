## Imports
```python
import gymnasium as gym
import numpy as np
from collections import deque
import torch as torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
```

## Environment Setup
``` python
torch.manual_seed(0)
env = gym.make("CartPole-v1")
test_env = gym.make("CartPole-v1",render_mode="human")
state_dim = env.observation_space.shape[0]
action_dim = env.action_space.n
```

## Policy Neural Network
```python
class Policy(nn.Module):
	def __init__(self):
		super(Policy,self).__init__()
		self.policyNet = nn.Sequential(
				nn.Linear(state_dim,32),
				nn.ReLU(),
				nn.Linear(32,action_dim)
				)
	def forward(self,x):
		x = self.policyNet(x)
		return F.softmax(x,dim=-1)
	def act(self,state):
		state = torch.from_numpy(state).float().unsqueeze(0)
		probs = self.forward(state)
		dis = torch.distributions.Categorical(probs)
		action = dis.sample()
		return action.item(),dis.log_prob(action)
```
- So this is a simple neural net with 1 hidden layer
### Why dim = -1
In deep learning, the **last dimension** often holds the class scores (logits) for a sample.
For example:
```python
x = torch.randn(32, 10)  # batch of 32, 10 class scores per sample
```

- `dim=0` would apply softmax **across the batch** — that’s almost never what you want.

- `dim=1` (or `dim=-1`) applies softmax **across the class scores per sample** — that’s correct.
- So  we would want to go over the 10 class scores rather than the batches 

### act function
#### state conversion
- So as you will see we are converting the current state for an np_array to a pytorch tensor on like <span style="color:rgb(0, 176, 240)">13</span>
- We unsqueeze which is adding an extra dimension to the first dimension( 0 since 0 indexing)
- So instead the dimension for the cart problem was shape 4, now after the unsqueeze it's shape [1,4] which is a 1x4 matrix
- This is then input as batch x features
- So we are only taking one batch at a time or 1 sample at a time
#### distributions:
- On line <span style="color:rgb(0, 176, 240)">15</span> we have distributions 
- We use a categorical because the state space is discrete(finite)
	- Since we have a finite set of actions i.e. left or right
	- So we are getting the probability of picking either left or right (0 or 1)

- The rest is straight forward, we also output the log_prob's which is used later in the reinforce algorithm, which the pseudo code is in the other notes

## Runner
```python
pi_net = Policy()
optimizer = optim.Adam(pi_net.parameters(),lr=1e-2)

episode = 0
num_episodes = 1500
gamma = 0.99
max_t = 1000
scores_deque = deque(maxlen=100)
print_every=100
```
- Here we setup the policy network and the optimizer 
	- Look in deep learning if you forget about optimizes
- We the initialize the number of episodes and other things
### Main Loop:
``` python
    while episode < num_episodes:
        observation = env.reset(seed=0)[0]
        episode+=1
        rewards = []
        log_probs = []
        for t in range(max_t):
            action,log_prob = pi_net.act(observation)
            observation,reward,terminated,truncated,info=env.step(action)

            log_probs.append(log_prob)
            rewards.append(reward)

            done = terminated 
            if done:
                break

        scores_deque.append(sum(rewards))
        returns = []
        G = 0
        for r in reversed(rewards):
            G = r+gamma*G
            returns.insert(0,G)
        returns = torch.tensor(returns)

        policy_loss = []
        for log_prob, Gt in zip(log_probs,returns):
            policy_loss.append(-log_prob*Gt)
        policy_loss=torch.stack(policy_loss).sum()


        optimizer.zero_grad()
        policy_loss.backward()
        optimizer.step()
        if episode % print_every == 0:
            print('Episode {}\tAverage Score: {:.2f}'.format(episode, np.mean(scores_deque)))
        if np.mean(scores_deque) >= 500.0:
            print('Environment solved in {:d} episodes!\tAverage Score: {:.2f}'.format(episode - 100, np.mean(scores_deque)))
            break
```

- So this is the overall main loop but I'm going to break this up again
- Reset rewards list because collect rewards per episode
- Reset logs_probs because collected per episode
- Reset environment for clean new episode

#### First for loop 6-15:
``` python
for t in range(max_t):
            action,log_prob = pi_net.act(observation)
            observation,reward,terminated,truncated,info=env.step(action)

            log_probs.append(log_prob)
            rewards.append(reward)

            done = terminated 
            if done:
                break
```
- We grab the action and log_prob from the policy network
- Then step that action in the environment
- Then just append the reward we got for taking that action and the log_prob of taking that action at that current state (the state before the action was taken)
#### Returns:
```python
returns = []
G = 0
for r in reversed(rewards):
	G = r+gamma*G
	returns.insert(0,G)
returns = torch.tensor(returns)
```
- Here we basically just calculate the return which is similar to the pseudo code basically
- Note this is done in reverse and we use insert as to insert to the front rather than append to the back of the list
- the convert the returns into a torch tensor

#### Policy Logs:
```python
policy_loss = []
	for log_prob, Gt in zip(log_probs,returns):
		policy_loss.append(-log_prob*Gt)
	policy_loss=torch.stack(policy_loss).sum()
```

- Not we take the -log_prob because we want to perform gradient ascent to maximize reward
	- So any action that lead to higher reward will get a higher probability basically
- policy_loss = []
	- for log_prob, Gt in zip(log_probs,returns):
		- policy_loss.append(-log_prob*Gt)
	- policy_loss=torch.stack(policy_loss).sum()

#### Updating:
``` python
optimizer.zero_grad()
policy_loss.backward()
optimizer.step()
```
- Zero grad is just resting the gradients of the model to zero
	- Why is this necessary?
	- Let’s say you forget to call `zero_grad()` and you do this every episode:
```
loss.backward()
optimizer.step()
```

- What happens?
	- After the first call to `loss.backward()`, `param.grad` contains the gradient.
	- After the second call, it adds **new gradients to the existing ones**.
	- So your model updates using **accumulated gradients**, which may be wrong unless you mean to do that (e.g. gradient accumulation across batches).

- Policy_loss.backward computes gradients loss with respect to parameters and accumulated them in `.grad ` 
- Optimizer.step() Update the parameters using the gradients currently stored in .grad
- the .grad is an attribute that lives inside each parameter tensor
- Not that the policy_loss takes in the logs and returns so when we do this since it's a tensor from our model those tensors will hold the weights of the model basically, which allows us to update them and help improve the model
- parameters are weights and biases
	- So we define nn.inear(4,2)
	- where weight is a matrix of shape [2,4] 
	- Biases is a vector of shape [2]


[[CS272]]