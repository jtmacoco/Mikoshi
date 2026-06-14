- Gradient descent has the drawback of iterating over all the samples in the train set before backpropagate
- Typically use Stochastic Gradient Descent
	- Note this is not the mathematical definition
- All this really means in machine learning is mini batch training
- So SGD works in the same was as GD, but instead of updating the weights per epoch it updates the weights in real time inside a single epoch
	- Each of the batches per epoch would contribute to the upgrading
- So we split the data in to n amount of batches aka minibatches 
- So we update the weights after every batch instead of every epoch

- Using SGD helps converge faster but we sacrifice some accuracy 
- The reason for this is that on batch may explain the batter very well the loss will go down and we will basically move in the right direction toward the minimum
- BUT some batches my not describe the pattern very well which would mean that we would go in the wrong direction away from the minimum 
	- Basically the model doesn't learn well and the loss increases
- Overall though will go in the correct direction and will converge at the sacrifice of some accuracy. 
- So we backpropagate after every batch

[[CS271]]