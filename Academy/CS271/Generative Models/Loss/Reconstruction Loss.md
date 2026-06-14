This is typically used in autoencoders
<span style="color:rgb(192, 0, 0)">Input should look like output</span>
So how this typically works is by comparing input pixels to output pixels this is a super high level overview 
## RMSE
- Optimizes symmetrically around average pixel values 
	- Because an overestimation is penalized equivalently to an underestimation
- Equation: 
  RRMSE = $sqrt(\frac{\sum_i^N(y_i-t_i)^2}{N})$
- Note using binary cross entropy is also typically used but images are slightly blurry where RMSE images are more pixilated 

[[CS271]]
