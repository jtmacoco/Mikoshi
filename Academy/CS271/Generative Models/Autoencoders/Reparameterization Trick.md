- Rather than sample directly from a normal distribution with parameters z_mean and z_log_var 
1. Sample epsilon from a standard normal
2. Manually adjust the sample to have the correct mean and variance
- Gradients can now backpropagate with out issue since the randomness is contained within the epsilon variable, so the partial derivatives are deterministic

<span style="color:rgb(112, 48, 160)">Analogy:</span> 
- Imagine you're trying to learn how to hit a bullseye on a target with a bow and arrow
	- Your training a robot archer
	- the robot has to learn where to aim (like learning $\mu$, the man)
	- And it also has to learn how shaky its hand are( this is like learning $\sigma$ the standard deviation)
- Problem without reparameterization
	- If every time the robot shoots, the wind randomly pushed the arrow some unpredictable amount, and you just see where the arrow lands you can't figure out what went wrong
		- Was it the aim was off
		- Or was it the wind
		- Or the hand shakiness 
	- The robot can't learn what it did wrong
- Reparameterization trick how it helps
	- Now imagine instead of having a random wind every time
		- you have a fixed random wind pattern(like always using the same gust map- this is $\epsilon \sim N(\mu,\sigma ^2$)

So the encoder has weights that produce the man and variance vectors, which are updated during the backpropagation, so basically trying to learn the mean and variance(the distribution for inputs)

## Without Reparameterization:
- Let’s say your encoder gives you $\mu = [1, 0.5]$  and $\sigma=[0.2,1.0]$ and then we basically sample from this distribution such that $z∼N(μ,σ^2)$
	-What this is basically saying is We picked some random value for z — don’t ask why, it’s just the dice.

[[CS271]]
	