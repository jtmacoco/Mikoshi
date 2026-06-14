- <span style="color:rgb(192, 0, 0)">Tells hows how much the distribution for a given class or object differs from a standard normal distribution</span>
We need to change the loss function
- Since before the loss function consisted of the reconstruction loss between images and their attempted copies
- The reconstruction loss in a VAE requires the KL Divergence term
## High level overview
- Basically a simple measure between a distribution compared to the standard normal distribution
- If a distribution is far from the standard one then the loss will be greater
- So the model is force to re-create a standard normal distribution for every sample
- This factor is forcing the distribution that describes where and how much space each object is taking to be equal to mean 0 and variance 1

[[CS271]]
