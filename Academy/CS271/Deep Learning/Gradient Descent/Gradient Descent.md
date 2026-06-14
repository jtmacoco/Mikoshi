## <span style="color:rgb(0, 176, 80)">Definition:</span> 
- is a form of trial and error in searching for a local minimum
	- Since unlikely will get stuck in a maximum 
- Basically calculate the derivatives and based on the sigh of values tells direction
- This is the exact same as the slope but instead it works in multi-dimension so 3d and so on
- Since it takes in vectors
### In multi-dimensions, the gradient is:
- The vector that points in the direction of the steepest slope (steepest increase), and its length (magnitude) is how steep the slope is
### So in simple terms:

> **Gradient = slope in multi-dimensions**,  
> but instead of a single number (like in 1D),  
> it’s a **vector** that gives:
> 
> - The **direction** of the steepest climb
>     
> - The **rate of change** in that direction
>
## Simple Example
$f(x) = 5x^2 + 3x -4$
step 1: Derivative of the function:
$f'(x) = 10x + 3$
step 2: Choose an arbitrary number $X_0$
$x_0=4$
Step 3: Choose a value $X_1$ following the update rule:
$x_{i+1}=x_i-\eta f'(x_i)$
$x_1=x_0-\eta [10*x_0+3]$
$x_1=4-\eta [10*4+3]=4-43n$

$\eta$  is the learning rate

So in the example say that the learning rate is 1 so 4-43=-39. What this is saying is that starting at point 4 we need to jump to -39 which is super larger and bad. So the loss will exponentially increase.  This doesn't work because the magnitude of the derivative is to large and we can't take it as it is.

So this is what the learning rate is for to help with these super large values. Note that the learning rate is a hyperparameter. 

Smaller learning helps adjust the jump/step size. So if learning rate is super small then we will have more jumps basically and it will take forever to converge. So it's necessary to fine tune a good learning rate value so not to small but not to large

## Gradient Decent Limitations
- It only takes the consideration of the first derivative and not the second
- The reason for this is because it's cheap to compute first rather than second
	- technically using the second derivative would reach faster but we want to parallize the code using a gpu so the first being cheaper (less computationally expensive) it's easier to do. 







[[CS271]]
