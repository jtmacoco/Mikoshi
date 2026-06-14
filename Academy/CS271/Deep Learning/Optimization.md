## <span style="color:rgb(0, 176, 80)">Definition:</span> 
- Refers to the task of either minimizing or maximizing some function $f(x)$ <span style="color:rgb(0, 176, 240)">by altering x</span> 
	- Usually minimization since maximization can be accomplished via minimization of -f(x)
- parameters are defined as weights
- <span style="color:rgb(192, 0, 0)">Use derivatives to help tell direction to go in order to find a minimum</span>
	- We are using the sign of the derivative to tell use direction
	- Note this doesn't guarantee finding the global minimum 
	- Helps determine step size
	-  If slope is positive want to go negative
	-  If slope is negative want to go positive
- This is difficult since we don't know the function like we can't view the graph
- Basically we want to minimize the loss function finding the $\theta$ parameter that minimize this argument
## Jacobian matrix 
- A function of m x n matrix of partial derivatives
- Basically just a matrix that contains all the partial derivatives for every single parameter in the model
## Hessian matrix
- A function the (symmetric) nxn matrix of second partial derivatives
- Basically just contains the second partial derivatives from the Jacobian matrix
- Basically if all Eigenvalues are positive then we have found a minimum
- If some of Eigenvalues are positive and some are 0 we've found a flat point on the function
- If all Eigenvalues are negative we've found a maximum 

## <span style="color:rgb(0, 176, 80)"> Eigenvalues:</span>
- Eigenvalues describe how a matrix scales vectors in certain directions.

## Second Derivatives 
- Can use the second derivative to tell if minimum or maximum, helps the model not get stuck if starts at a zero point or a flat surface (think in a graph more flat)
- <span style="color:rgb(192, 0, 0)"> Negative means maximum</span>
-  <span style="color:rgb(192, 0, 0)">Positive means minimum</span>

A point is a local minimum if:
## Necessary conditions:
- Gradient corresponding to the point is 0
-  Hessian matrix is positive semi-definite
## Sufficient condition:
- Gradient is 0
- Hessian matrix is positive definite (then is a local optimum)


- When we have multi parameters/weights we need to find the right value for each of them
- Partial derivatives tell h ow a single val/weight influence output, so basically which weight needs to change. 
## When to stop
- When there isn't much improvement anymore so the loss really hasn't gone down all that much so stop (note if goes up can be bad leading to overfitting)




[[CS271]]