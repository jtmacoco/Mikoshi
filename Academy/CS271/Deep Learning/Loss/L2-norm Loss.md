- <span style="color:rgb(192, 0, 0)">This only works with regression problems</span>
- Equation: $\sum_{i}(y_i-t_i)^2$ 
	- y is predicted or the output of the model
	- t is the target value the labeled value
- This takes the <span style="color:rgb(0, 176, 80)">Vector norm aka Euclidian distance</span> of the outputs and the targets
- So think about this like the distance between 2 points, the smaller the distance the lower the loss
- The higher the distance the higher the loss more model needs to work to improve(optimization)
![[l2-norm.png]]
- Notice in this image the different exponents
- These correspond to the different types of loss where can be L2,L3,L4 and so on
- Typically we use L2 norm because it's a good in between
- L1 norm is very slow but this wouldn't have any bias
- So to go into more detail why L2-norm is a good in between is because
	- L3, L4, and so are are to harsh
	- Notice in the graph how once we get past 1 the function grows rapidly
		- This means that when the model is wrong in it's prediction it the loss function will make that wrong value even higher, so the model knows not to pick that predicted value again or have a similar output
		- Example: if the loss value was 2 then after applying L3 norm it would be 8, which is very high(note this isn't really how it works but just trying to show how it can be to harsh since actual function is slightly different than just cubing the one value)
	- Small errors contribute less to the loss, meaning the model might be "too lenient" when predictions are already close to the target, leading to slower learning in these cases

[[CS271]]