- Note that you can divide or multiply or do anything really to the loss function as long as you do it for every iteration and every sample every time

## Update Rule:
$x_{i+1}=x_i-\eta f'(x_i)$
which will become

$w_{i+1} = w_i-\eta \nabla _wL(y,t)$
$b_{i+1} = b_i-\eta \nabla _bL(y,t)$

So we basically just compare the outputs y and the targets t. We have 2 separate functions one for bias and weights

- <span style="color:rgb(192, 0, 0)">So when we are taking the derivative of the loss we are going to use the chain rule</span> 


[[CS271]]