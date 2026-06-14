## Bayes Nets Summary
- Bayes nets compactly encode joint distributions
- Guaranteed independences of distributions can be deduced from BN graph structure
- Inference by enumeration is the basic exact inference method for bayes nets. There are techniques to make it more efficient
- There are also some approximate inference methods that include randomized sampling
---
## Homework 6
- <span style="color:rgb(192, 0, 0)">use lambada </span> 
---
## Time and Uncertainty
- The world changes, we need to track it and predict it
- Often, we want to reason about a sequence of observations
	- Robot localization
	- Medical monitoring
	- Speech recognition
---
## Basic Idea
- State random variables for each time step
---
## Bayes Net
- Construct a Bayes net from these states variables
- Arcs/parents ?
- Markov assumtion: $x_t$ depends only on a subset of $x_1,x_2,x_{t-1}$
	- First order Markov: State $x_t$ at each time step only depends on the previous state $x_{t-1}$
---
## Markov Chain
- Transition probabilities or dynamics, specify how the state evolves over time
	- Stationarity/assumption: transition probabilities are the same at all times
	- <span style="color:rgb(192, 0, 0)">Question on final</span>
		- Example weather slide 38
	
----
## Mini-Forward
- 
---
## Stationary Distributions
- For most chains:
	- Influence of the initial distribution diminishes over time
	- Distribution we end up in is independent for the initial distribution
	- Stationary Distribution
		- The distribution we end up with is called the stationary distribution chain
	- <span style="color:rgb(192, 0, 0)">Question on final</span>
---
## Hidden Markov Models
- Transition probabilities or dynamics: specify how the state evolves over time
- Observation/evidence to update our beliefs 
### Basic Idea
- State and evidence random for each time step



[[CS156]]
