- Root Mean Square Propagation has the same update rule as Adaptive Gradient algorith. However $G_i(t)$ is different, it is an Exponentially weighted moving average (EWMA):
	$G_i(t)=\beta (t-1)+(1-\beta)(\frac{\delta L}{\delta w_i}(t))^2$

- Now we have this beta value which is a hyperparameter which is meant to help reduce the issue of increasing the denominator value to fast which was AdaGrads problem
-  Consider the past as a portion of an average
- So say beta is .9 (90 percent ) we would then consider 90 percent of the past and only 10 percent of the gradient. So we increase the number every iteration and we reduce the size every time
## simple terms:
This basically is just making the formula slower so we aren't dividing by such big numbers at the start anymore helping reduce the amount that the learning rate decreases we learn faster

<span style="color:rgb(192, 0, 0)">NO MOMENTUM BEING USED</span>
[[CS271]]
