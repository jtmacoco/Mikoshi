- This type of solves the problems of normal autoencoders by introducing randomness into the model and constraining how points are distributed in the latent space
	- Basically leaves less holes in the latent space
	- Tries to make the latent space continuous 
## constraints
1. The center of each item's area need to be as close to the middle (0,0) as possible
2. Deviation of the item from the center should be as close to one unit as possible
- The further the encoder strays from the constraints, the higher the loss 

## Updated Encoder
- In a VAE, each image is mapped to a multivariate normal distribution around a point in the latent space, rather than how a regular autoencoder, each image is mapped directly to one point in the latent space
- Output of encoder is now 2 vectors the <span style="color:rgb(192, 0, 0)">mean and variance vectors</span> 
## Multivariate Normal Distribution
- Can sample a point z from a normal distribution using the following equation:
- $z=\mu+\sigma \epsilon$
	- Epsilon is sampled from the standard normal distribution
- What this means is that we are basically just taking a b
- Each point get's encoded into a distribution
- z is the latent space point
- Note we want the mean to be 0 and variance to be 1 typically

## Updated Decoder
- Can sample point z from the distribution defined by these values using equation
- $z = z\_mean + z\_sigma*epsilon$

## Issue
- The Issue was that since we randomly sample z form the distribution created by z_mean and z_log_var, the randomness breaks backpropagation, because the gradients can't flow through a random sample
- When backpropagating we will get different weights each time, so the model will not learn at all 
This issue can be solved with the help of the [[Reparameterization Trick]]  & Kulback-Leibler divergence term

## Building VAE encoder
- $Loss_{new}=Reconstruction_{loss} +\beta KL_{loss}$
- Beta is a hyperparameter
## Idea behind Beta
- It is to help guide the distributions to look like a standard normal
- <span style="color:rgb(192, 0, 0)">Not to much because everything will overlap and the output will be very messy</span>
- <span style="color:rgb(192, 0, 0)">Not to little because then space won't be continous</span>
- If Beta is to small the $Reconstruction_{loss}$ will over power the $KL_{loss}$ and the KL loss won't have any effect so it will basically just be an normal autoencoder
- If Beta is to big then there will be overlapping and all the images will be poor because the model is confused
![[kl-beta.png]]
A: Beta value is to small
B: Beta value is just right
C: Beta value is to large

<span style="color:rgb(192, 0, 0)">KL is training the encoder since KL is training the encoder because it's the encoder that needs to put stuff in the right position</span>

<span style="color:rgb(192, 0, 0)">Reconstruction is training the decoder because it needs to be similar to the input</span>
![[Reparameterization.png]]

## Reconstruction VAE vs AE
- So AE and VAE will perform about the same when reconstructing images
- The reason is because when we use the decoder we are telling exactly where to sample, that is the point where that object is in the latent space
- So the AE does it well since it uses the reconstruction loss


## Training Variational Autoencoder
- Should use batch normalization layers after each convolutional layer to stabilize training

## Latent Space Arithmetic
- This is something a normal autoencoder can't do, so it's not very good at generating new things while a VAE can do this somewhat well
- We can perform arithmetic on vectors in the latent space to obtain a visual analogue when decoded back into the original image domain
- EX: suppose we want to take an image of somebody who looks sand and give them a smile
	1. We first need to find a vector in the latent space that points in the direction of the increasing smile
	2. We add this vector to the encoding of the original image in the latent space
	3. We decode this new point
	4. We should get a more smiley version of the original image
- How do we find this smiling vector
- Well each dataset image has a label
	1. We take the average position of encoded images in the latent space with the attribute smiling
	2. We subtract the average position of encoded images that do not have the attribute smiling 
	3. We obtain the vector that points in the direction of the smiling
- Formula to do this is: $z_{new} = z+alpha*feature\_vector$

## Morphing Faces
- Imagine two points in the latent space A and B
	- They represent 2 images
- Starting from A decode each point toward B in a straight line
	- You see a gradual transition from the starting face to the end face
- Updated Formula: $z_{new}=z\_A*(1-alpha)+ z\_B*alpha$
[[CS271]]

