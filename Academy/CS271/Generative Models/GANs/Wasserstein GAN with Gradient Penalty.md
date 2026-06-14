- <span style="color:rgb(192, 0, 0)">WGAN and WGAN GP are similar but different</span>
	- Everything  the header for gradient penalty is talking about WGAN GP
- Change the discriminator to a critic
- The critic still judges what is real and fake but it's not a discriminator
	- The difference is that a critic gives a grade or a score, like this image looks real 100 points, this image looks fake 10 points. 
## Loss
- Uses Wasserstein Loss
- Ex: 
	- Say I have a score of 1000 with a label -1, the output would be -1000
	- Then say I have a score of 10 with a label 1, the output would be 10
	- This means that the critic is doing a good job at know which is generated and which is real
	- So what really matters is the distance between generated and fake images
		- The bigger the distance the better the critic is doing
		- The smaller the distance the better the generator is doing
- The critic's job is not to say 'real or fake' — it's to say **how real something feels**. The bigger the difference between scores for real and fake stuff, the smarter the critic is, and the better the generator learns
## <span style="color:rgb(192, 0, 0)">Note in WGAN Without Gradient Penalty gradients will explode</span>

## Lipschitz Constraint
- Provides a limit on how much the function grows
- Since the range is now $(-\infty,\infty)$ the Wasserstein loss can be very large 
- This constraint aims to help with this exploding gradient or very large loss issue
![[Lipschitz_Visualisierung.gif]]

- Notice how there is this cone. This is the constraint basically, for any point in the function, if there function goes within the white area of the cone, then we know it's exploding and should stop
- Here is the formula for Lipschitz Constraint
	- $\frac{|D(x_1)-D(x_2|}{|x_1-x_2|}\leq 1$
	- $|x_1-x_2|$ is the average pixelwise absolute difference between the 2 images
	- $|D(x_1-D(x_2)|$ is the absolute difference between the critic predictions (the scores basically)
- So the critic is 1-Lipschitz if it satisfies the inequality for any 2 input images $x_1$and $x_2$
- What this means is that we require a limit on the rate at which the predictions of the critic can change between 2 images
- So say the 1 were to change to 2 in the equation this would mean that the constraint is more lenient, basically the cone is smaller
- If we change the 1 to 0.5 then the constraint is basically being more strict, basically the cone is larger
- Ex:
	- Say that the distance between 2 images pixel wise is 1000, so 1000 pixels are different
	- Then the scores here no matter how large, can only have a max distance of 1000 between the 2 scores
	- So one score could be 999 while the other is -1 this would be fine since the output would be less than or equal to 1.
- <span style="color:rgb(192, 0, 0)">Using Lipschitz Constraint is not enough though</span>
	- The reason is because we have to wait for the model to output the scores for every pair of images then ensure that this they follow the constraint, so the constraint is true
	- If it's not true restart the training
	- Not very practical

## Gradient Penalty 
- Basically check that the gradient is as close to 1 as possible because 1 keeps the numbers not too large and not too small
- The problem is that we should do this for every real image and every fake image, but this is very time consuming 
- What we do so, no need to check every real image and fake image, is create a set of interpolated images between fake and real, and we don't need to do this for every fake and real image, we can do this for every 10 or 100 or however many
- <span style="color:rgb(192, 0, 0)">An interpolated image is a blend between a real image and a generated (fake) image, typically created by combining the two with a weighted average</span>
- Formula for gradient penalty loss
	- $\lambda \, \mathbb{E}_{\hat{x} \sim \mathbb{P}_{\hat{x}}} \left[ \left( \left\| \nabla_{\hat{x}} D(\hat{x}) \right\|_2 - 1 \right)^2 \right]$
	- What this is basically saying is we compute the gradient of the critic output with respect to its input
	- Then we measure how far the gradients norm(distance) is from 1
	- The difference(or distance) is what is penalized in the loss function
- The goal is to keep the rate of change(the slope) which is from the gradient, of the critic's output with respect to input around 1
- We need the **critic function** to be **1-Lipschitz continuous**, meaning:
	- The slope (or gradient norm) must be **at most 1** everywhere.
## Training WGAN-GP
- With GAN we don't want the Discriminator to get to strong
- With WGAN: we are not worried (thanks to the Wasserstein loss)
- However, with Wasserstein loss, the Critic must be trained to convergence before updating the generator 
	- This ensures that the gradients for the generator update are accurate
- We train the critic several times between generator updates 
	- A typical ratio used is 3 to 5 Critic updates per Generator Update
	- This is because  GP is a regularization technique kind of and it breaks the legs of the critic a lot in a sense, so we need to update more often. It needs more time to get used to it's legs basically, since it starts off with no legs
- <span style="color:rgb(192, 0, 0)">Important Batch Normalization shouldn't be used in the Critic!</span>
	- This is because we are normalizing the numbers within the network, at every layer we have similar numbers
	- This creates correlations between the images because the numbers are all very similar 
	- But the images can be very different so maybe it's required that the weights are so distant from each other due to them being different 


 [[CS271]]
 