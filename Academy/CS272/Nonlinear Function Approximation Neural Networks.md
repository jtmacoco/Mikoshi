## Linear Approximation to Nonlinear
- A Linear combination of state features is used to represent a value function
- Linear function approximation
	- Provides some nice theoretical guarantee on the learning convergence
	- But! Is not sufficient to represent a complex value function in practical tasks(under fitting)
- Nonlinear function approximation by neural networks(NNs)
---
## The perceptron
- A perceptron is an artificial neuron that takes a collection of binary inputs and produces a binary output
- The output of the perceptron is determined by summing up the weighted inputs and thresholding  the result:
	- If the weighted sum is larger than the threshold b,
	- the output is one ( and zero otherwise )
--- 
## Beyond Perceptrons: Neural Networks
- Feed forward neural networks to represent a more complex (nonlinear) functions
- There is no backward connections
- Artifical neurons that have
	- Real number inputs/outputs and
	- (possibly) nonlinear activation functions
		1. The Sigmoid Neuron
		2. Rectified Linear Units( ReLU)
		3. Softmax
---
## Universal Approximation Theorems 
- A set of theorems that put limits on what neural networks (typically feedforward networks) can theoretically learn
- [Cybenko, 1989] An ANN with a single hidden layer containing a large enough finite number of sigmoid units can approximate any continuous function on a compact region of the network's input space to any degree of accuracy
- However, both experience and theory show that approximating the complex functions needed for many tasks is made easier abstractions that are hierarchical compositions of many layers of lower-level abstractions 
---
## Inference and Backprop
- Forward propagation (Inference): Given an input we obtain the output
- Back propagation (Backprop): After obtaining the output, we flow back the loss information to compute the gradient (that are used to update the weight parameters)
	- Analytically, computing the gradient is not to difficult
	- However, numerically evaluating such expressions may be expensive
	- The backprop algorithm is a computationally efficient way to obtain the gradient values
[[CS272]]