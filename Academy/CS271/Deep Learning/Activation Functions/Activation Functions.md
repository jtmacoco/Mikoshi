- These functions are used to add Non-Linearity to our model 
- This basically makes the model more complex so it can solve more complex problems
- Adding complexity

## Typically what is needed for activation function
- Monotonic
	- So the model can't improve then de-improve
		- Think of like a half circle we go up this circle and reach a peak then go down (the model gets worse) so we don't want this, kind want a straight line going to infinity
- Continuous
	- Want the model to work for all points not just some so should go from $[-\infty,\infty]$
-  Differentiable
	- We NEED the function to be differentiable so we can backpropagate and calculate the loss using gradient descent 

## Different types of activation functions
- Sigmoid
- Tanh
- Softmax (note only used in last layer)
- Relu
- LeaklRelu

Note that some activation functions are susceptible to exploding and vanishing gradient. An example of this would be that sigmoid suffers from the vanishing gradient problem. **Better nodes in goodnotes** 

## SoftMax function
$$

\sigma(\mathbf{z})_i = \frac{e^{z_i}}{\sum_{j=1}^{K} e^{z_j}}

$$

[[CS271]]