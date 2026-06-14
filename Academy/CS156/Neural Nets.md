## Learning: Binary Perceptron
- Start with weights = 0
- For each training instance:
	- Classify with current weights
- Repeat until no more significant changes (iterations)
---
## Example: Perceptron
- Separable case
---
## Properties of Perceptrons
- Separability: Some parameters get the training set perfectly correct
- Not all data is separable
- Convergence: if the training data is separable, the binary perceptron rule is guaranteed to converge
---
## Multi-class decision rule
- If we have multiple classes:
	- A weight vector for each class : $w_y$
	- Score (activation) of a class y: $w_y\cdot f(x)$
	- Prediction: highest score wins: 
		- $y = argmax_y(w_y\cdot f(x))$
		- y = label corresponding to the highest score
---
## Learning: Multi-class Perceptron
- Start with all weights = 0
- Pick up training examples one by one
- Predict with current weights
- $Y = argmax_y w_y \cdot f(x)$
- If correct $(y = y^*)$ no change
- If wrong: lower score of wrong answer (y), raise score of right answer $(y^*)$
	- $w_y = w_y - f(x)$
	- $w_{y^*} = w_{y^*} + f(x)$
	- repeat until no more significant changes (iterations)
---
- <span style="color:rgb(192, 0, 0)">Use Max since it will break the tie for for coding assignment </span>
- Only update weights when make mistake 
---
## Problems with perceptron
- Noise: if the data isn't separable, weights might thrash
	- averaging weight vectors over time can. help (averaged perceptron)
- Mediocre generalization: finds a barely separating solution
- Idea: Adjust the weight update to mitigate the problems
- MIRA (Margin Infused Relaxed Algorithm): Choose an update size that fixes the current mistake, but minimizes the change to w
---
## Minimum correcting update
- Idea: adjust the weight update to mitigate the problems
- MIRA: Choose an update size that fixes the current mistake but, minimizes the change to w
- Introduce a learning rate
---
## Maximum Step Size
- Example may be labeled in correctly
- Solution: Cap the maximum possible value of r with some constant
- Converges faster than perceptron
- Usually better, especially on noisy data
---
## Support Vector Machines
- Max the margin: good according to intuition, theory
- Only Support vectors (vectors on the margin) matter; other training examples are ignored
- SVMs find the separator with the max
---
## Classification Comparision
- Naive Bayes
	- Builds on a model from the training data
	- Gives prediction probs
	- Strong assumptions about feature independence
	- One pass through data (counting)
- Perceptron:
	- Makes fewer assumptions about data
	- Mistake driven learning
	- Multiple passes through data
	- Often more accurate 
---
## Hill Climbing
- Start Wherever
- Repeat: Move the best neighboring state
- If no neighbors better than current, quit
	- Neighbors = small perturbations of w
- What's tricking when hill climbing for multi layer perceptron
	- Challenge only find local min not global
---
## Neural Network Properties
- Theorem( Universal approximator ): a 2 layer neural net with sufficient number of neurons can approximate any continuous function to any desired accuracy
- Practical Considerations
	- Can be seen as learning the features
	- Large number of neurons: Danger of overfitting
	- Hill-climbing procedure can get stuck in bad local optima
---
## Case Based Learning
- Reasoning from examples as opposed to building a model
- Avoid even numbers
- Parametric models:
	- Fixed set of parameters
	- More data means better settings
- Non Parametric models
	- Complexity of the classifier increases with data
	- (K)NN is non-parametric

	

[[CS156]]