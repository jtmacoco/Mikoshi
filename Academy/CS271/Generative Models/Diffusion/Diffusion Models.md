The name diffusion comes from the property of thermodynamic diffusion
Also called Denoising Diffusion Probabilistic Model(DDPM)

## Basic Overview
- Forward process is just adding noise to an image
- Backward process is denosing the image 
- Example given in class that was good
	- Ok so I show you a picture of a horse for a moment then I stop showing that picture
	- Now try to draw that picture of a horse, probably can't do very well at first
	- Then I'll show you the picture again and you will try to draw again
	- This is the idea, because we don't really see the image, so we need to force our minds to remember the pixels in a way 

## Forward Diffusion Process
- So need to add noise but this is done gradually
	- $x_0$ is the current image no noise
	- $x_1$ adds a little noise but still similar
	- $x_t$ so every time step we add a little more noise basically 
- Can't just add random noise at each time step
	- If we add random pixels at each time step the model won't really learn well
	- Think how is it supposed to learn if we keep randomly generating noise, there isn't really a pattern
	- Also lose a lot of information
- So we gradually add noise from a standard Gaussian(Normal) distribution
- <span style="color:rgb(192, 0, 0)">VARIANCE MUST BE 1</span>
- The formula for generating noise based on the previous time step:
	- $q(x_t|x_{t-1})=N(x_t;\mu _t, \sigma^2_t)$
	- What this means is we generate the next step considering the previous one
	- What should be the mean and variance though????
- The mean $u_t$ in a normal or gaussian distribution indicates where the center of the noise is which can be defined as:
	- $\mu_t=\sqrt{1-\beta_t}x_{t-1}$
	- What this basically means if that we have a mean from the previous image which is translated or moved slightly
	- Shifted using the beta parameter
	- Beta has a t which is saying that we can modify that value at different time steps
- The variance $\sigma^2$ indicates the spread or dispersion of the noise which is defined as:
	- $\sigma^2=\beta_tI$
	- Where $I$ is the [identify matrix](https://en.wikipedia.org/wiki/Identity_matrix)
- Formula to generate next image, adding noise at the next time step basically  
- $x_t=\sqrt{1-\beta_t}x_{t-1}+\sqrt{\beta_t}\epsilon_{t-1}$
- This basically says that the next images equals the pixels of the previous images times the shifting factor which is beta
- Epsilon is the randomness basically like in VAE
- Beta shifting helps so we create new images
	- The mean represents the average outcome at each step
		- Every time we step we have a new mean
		- These changes are very small and controlled or basically scaled by the beta value as to not just recreate the image but come up with something that looks like the input image
		- Shifting helps the model not overfit on the input
	- If beta is to large, changes to initial image will also be very large, so may not look like the input image
	- If beta is to small then will look exactly like the input image
- <span style="color:rgb(192, 0, 0)">So gradually adding noise so that the model can understand what is the noise</span>
## Reparameterization Trick (different from VAE slightly)
- This is used because checking every time step for noise is time consuming 
	- If we had 1000 timesteps of adding noise gradually then it would take forever
- Need to be able to jump to any point and basically tell the noise at that specific time step without the need to calculating everything up to that point which is what this trick does basically
- <span style="color:rgb(192, 0, 0)">Model has to know how much noise there is in an image</span>
	- Otherwise the model will get confused and not learn
	- Think if it doesn't know how much noise how will calculate loss
- Formula:
	- $x_t =\sqrt{1-\beta_t}x_{t-1} + \sqrt{\beta_t}\epsilon_{t-1}$
- We then define $\alpha_t=1-\beta_t$ and $\prod^t_{i=1}\alpha_t$
	- The product is saying all the products up to that time step so t x t1 x t2 etc
- We can re-write the formula as
	- $x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\epsilon$
- We want variance to be one because if we had a smaller variance the points closer to the mean are more likely to be selected, we don't really want that we want it to be standardized so not to pick points  much from the mean but not to little not from the mean
## Diffusion Schedules
- At every step we don't use a constant amount of noise 
- We can choose a different $\beta_t$ at each time step
- Typically we don't want a linear diffusion schedule so use a cosine diffusion schedule
	- Cosine schedule just uses the cosine function so think it's a wavy function
- So using a linear increases the noise to quickly while cosine is slightly smother in increment noise
- But typically an offset schedule of cosine works better it provides a linear growth in incrementing noise which is good
- <span style="color:rgb(192, 0, 0)">This slowly adding noise gives the network more time to understand what noise is</span>
## U-Net
- [[U-Net]]
## Reverse Diffusion Process
- in the equation $x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\epsilon$ the $\bar\alpha$ becomes the label since this tells us how much noise was added at this time step basically 
- So this works better than GANs since GANs will go from complete random noise to an image where diffusion models gradually add noise and gradually understand/re-build the image
- Basic idea of this full process
	1. Sample an image $x_0$ and transform it by t noising steps:
		- $x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\epsilon$
	2. Then input the image $x_t$ and the noising rate $\bar\alpha_t$ to the neural network and ask it to predict $\epsilon$
	3. Then compute gradient descent with loss:
		- $\nabla_\theta\left\|\epsilon - \epsilon_{\theta}(\sqrt{\bar\alpha}x_0+\sqrt{1-\bar\alpha_t}\epsilon,t) \right\|^2$
		- This is the squared error between the prediction $\epsilon_{\theta}(x_t)$ and the true $\epsilon$
	- So basically the model is guessing which pixels are noise and compares with the actual pixels that are noise using the noising rate $\bar\alpha_t$

- Diffusion model uses 2 copies of the network:
	1. One is trained using gradient descent
	2. Another (EMA network) that is an exponential moving average(EMA) of the weights of the trained network over previous training steps
		- EMA is not as susceptible to short-term fluctuations and spikes in the training
		- Use EMA network to produce generated output from the network
	- Kind of like the average of what the jumps are so is smoother
	- 


	




[[CS271]]