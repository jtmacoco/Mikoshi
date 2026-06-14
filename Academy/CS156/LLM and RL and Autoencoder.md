- Try to learn the identity function
- Why?
	- dimensionality reduction/compress the data
	- discover interesting structure about the data
	- learn the features
	- visualize the function learned by a hidden unit
	- understand what feature the hidden unit is looking for
---
## How Many Computers to Identify a Cat
- Goal:
	- build high level class specific feature detectors from unlabaled images
	- build a face detector
- How?
	- deep (9-layer )locally connect sparse autoencoder
	- dataset: 10 million images from youtube videos
---
## Reinforcement Learning
- Reinforcement learning is learning behavior that maximizes a numerical reward
- the agent is not told which actions to take
- The agent must discover which actions yield the highest reward by trying them
- The agent learns from direct interaction with the environment 
	- Agent generates its own data by interacting with the environment
- Trial and error
- Delayed reward
---
## Value Funciton 
- The value function specifies the long term desirability of states
- The value of a state is the total amount of reward an agent can expect to accumulate over the future starting from that state
- For example, a state might always yield a low immediate reward but still have a high value because it is regularly followed by other rewards
---
## Key Ideas
- Important ideas in reinforcement learning
- Exploration: Explore unknown
- Exploitation: eventually you have to use what you know
- Regret: Even if you learn intelligently, you make mistakes
- Sampling: because of chance you have to try things repeatedly
- Difficulty: learning much harder than solving a problem with known parameters 
---
## Large Language Models
- Features
	- Text tokenization 
	- Word embeddings
- Deep Neural Networks
	- Attention
	- Transformers
- Multi-class classification
- Reinforcement Learning
---
## Tokenization
- Break down text into smaller units called tokens
- Each token is assigned a unique integer
---
## Word Embeddings
-  Idea is that words that are close in meaning will have embedding close together 
---
## Self Attention
- instead of conditioning on all input tokens equally
- Pay more attention to relevant tokens
	

[[CS156]]