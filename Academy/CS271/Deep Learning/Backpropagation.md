- Computing the deltas in the hidden layers is obtained through the backpropagation of errors(loss)
- After forward Propagation we back propagate through partial derivatives and change each parameter so errors at the next epoch are minimized
- When using partial derivatives, basically understanding what is the influence of each of these weights to that specific output number
	- So if the loss/error is high the partial derivatives tell us that the most dangerous culprit is this weight(So tells which weight influences the most to the bad output)

[[CS271]]