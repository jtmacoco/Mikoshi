- Uncertainty comes into play when environment is :
	- Partially Observable
	- Non Deterministic
---
## Probabilistic reasoning
- Observed variables (evidence): Agent knows certain things about the state of the world
- Unobserved variables: Agent needs to reason about other aspects
- Model: agent Knows something about how the known variables relate to the unknown variables
- Agent can also learn the model 
---
## Random Variables
- A random Variable represents some aspect of the world about which we many have uncertainty
- We denote random variables with capital letters
- Like variables in CSP, random variables have domains 
---
## Probability Distributions
- Associate a probability with each value in the domain
- Temperature: hot or cold?
- Unobserved random variables have distributions
---
## Uniform Probability Distribution
- All have the same probability typically at the initial state
---
## Joint Distribution
- A joint distribution is a probability distribution that involves two or more random variables
---
## Probabilistic Models
- A probabilistic model is defined by a join distribution over a set of random variables
- (Random) variables with domains
- Assignments are called outcomes
- Joint distribution : how likely assignments (outcomes) are
- Normalized: sum to 1.0
- Ideally: only certain variables directly interact
---
## Events
- An event is a set E of outcomes
- From a joint distribution, we can calculate the probability of any event
	- by adding up probabilities basically 
- Typically, the events we care about are partial assignments 
---
## Marginal Distributions
- Marginal distributions are sub tables which eliminate some variables
- Marginalization (summing out): Combine collapsed rows by adding 
---
## Conditional Probabilities
- Definition of conditional probability
- Given two random variables A and B:
- $P(a|b) = \frac{P(a,b)}{p(b)}$
----
## Conditional Distributions
- Conditional distributions are probability distributions over some variables given fixed idk lol
---
## Product Rule
- Sometimes we have conditional distributions but want the joint distribution:
---
## Bayes' Rule
- Two ways to factor a joint distribution over two variables:
- $P(x,y)=P*x|y)p*y)=P(y,|x)P(x)$
- <span style="color:rgb(192, 0, 0)">Add bayes rule to cheat sheet also question on final exam</span>
---
## Probabilistic Inference
- Probabilistic inference: compute a desired probability from other know probabilities
-  We generally compute conditional probabilities
	- These represent the agent's believes given the evidence
	- Probabilities change with new evidence
--- 
## Inference with Bayes' rule

$P(cause|effect)=\frac{P(effect|cause)P(cause)}{P(effect)}$

- Example  robot needs to infer location from noisy sensor reading
- Cause location
- Effect sensor reading
- Easy to measure P(Sensor|Location)
- We compute P(Location |Sensor)
---
## Independence
- Two random variables are independent in a joint distribution


[[CS156]]