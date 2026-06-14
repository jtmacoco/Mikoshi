Equation: $-1/N \sum_1^n (t_i * ln(y_i)+(1-t_i)*ln(1-y_i))$
- Where N is the number of predictions
- Note that the target value t will be in [0-1] so either 0 or 1
- <span style="color:rgb(192, 0, 0)">This won't work with a multi-classification problem or model</span>
	- This is because what happens if we end up comapring on of the classes vs all of the classes
	- We classify one class vs all the others
	- Think so now we have basically 1 class vs all, where all the other classes get grouped into a single class now.
	- So instead of comparing weather an apple is an apple or a pineapple we basically compare the image is an apple or not an apple 
	- This may make the accuracy go up but it's not really a high accuracy

[[CS271]]