- Basic idea is to try and get out of a local minimum to go into a potential global minimum
- Momentum is based on physics basically 
- So we basically use the past or previous loss to help kind of push the model to get out of a local minimum
- This is what the equation looks like:
	- $\theta _{t+1}=\theta _t-\eta -\alpha \nabla _\theta L(\theta _{t-1})$
- So we add this alpha value which basically determines how much of the past we want to consider
- Alpha considers how much the past gradients will affect the current gradient
- So the larger value alpha is the more of the past we consider
	- Think of like we have a larger memory so long term memory
- Smaller value alpha means less memory so less of the past effects the current gradient

[[CS271]]