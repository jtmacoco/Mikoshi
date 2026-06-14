- The Wasserstein loss requires $y_i=1$ and  $y_i=-1$ as labels instead of the typical 1 and 0 
	- -1 means fake
	- 1 means real
- This means we remove the sigmoid activation from the discriminators final layer
	- So the predictions $p_i$ are no longer constrained to fall in the range [0,1] but instead can now be $(-\infty,\infty)$
- This is the loss function equation:
	- $-\frac{1}{n}\sum_{i=1}^n(y_ip_i)$

[[CS271]]

	