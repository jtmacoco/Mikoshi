## <span style="color:rgb(0, 176, 80)">Definition:</span>
- Occurs during the training when gradients become to big during backpropagation 
- So basically say the loss outputs a really big number like a million, then when we do back propagation we are going to be multiplying numbers by a million which leads to really big numbers which is bad because our weight will be massive
- This can affect loss by:
	- Rapid increase in loss
	- Loss Oscillation
	- Inf Loss

[[CS271]]