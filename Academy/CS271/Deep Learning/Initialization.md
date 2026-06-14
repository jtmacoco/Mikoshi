- Note that the weights can't all be equal
	- If they are all equal, the backpropagation would not be able to recognize the different nodes and would upgrade all of them in the same way
		- This makes the weights useless
	- Even outputs would be the same
## Random Restart
- Based on rerunning the training of a model with different initial conditions to see if we get lucky and maybe start near the global minimum

Standard normal initialization with fixed variance can cause exploding activation or gradients
So we want to initialize nodes so the values don't get to big basically
See in the image how the values get very big in just 2 iterations



![[Init.png]]
-  So after some math which is in the glean notes Xavier and Glot figure out the relation ship between the variance and number of inputs
- The equation is as follows
$\sigma = sqrt(2/(n_{in}+n_{out}))$
So there is a direct correlation between the number of inputs and outputs and the variance. 
So the more inputs and outputs the smaller the variance will be which makes sense.

Uniform Xavier Initialization is:
$[-x,x]$ where x = $sqrt(6/\#inputs+\#outputs)$
Normal Xavier Initialization:
$\sigma = sqrt(2/\#inputs+\#outputs)$





[[CS271]]