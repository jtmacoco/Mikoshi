Composed of 2 neural networks a generator and a discriminator 
- The generator converts random noise into synthetic samples as if they were part of the original dataset
- The discriminator tries to predict if the sample is real or generated
- Uses labels
- Length of input vector determines the dimensionality of the latent space
## Generator
- Generates the image
- Input for generator is random noise
	- This is the latent space
	- The random noise is just random numbers
- Idea is to force the generator to understand a very complex latent space overall
- It's randomly sampling from all the space possible which is a lot of info
- <span style="color:rgb(192, 0, 0)">NO ENCODER SETTING IT UP</span>
## Discriminator 
- Input get's real or fake images
- Then the discriminator needs to tell whether the image is fake or real like a game
	- Doesn't recognize a class like VAE's jus is something real or fake 
- It knows which are fake and real by training the network
- When it first starts it had no understanding of anything
- <span style="color:rgb(192, 0, 0)">If fake label 0 if real label 1</span>

[[CS271]]