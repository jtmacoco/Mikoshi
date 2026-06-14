- Called U-Net due to shape lol

![[u-net.png]]

## Sinusoidal Embedding
- This is what the embedding is in the image above
- <span style="color:rgb(192, 0, 0)">Basically want to convert a scalar value(the noise variance) into a distinct higher-dimensional vector</span>
- <span style="color:rgb(192, 0, 0)">Noise is a number</span> like 0.45
	- We want to remember this number in a vector format
	- Need a function that given a number outputs always a different vector

Since this is hard to kind of understand here is a visual Jonathan please understand this 
![[u-net-embedding.png]]
- This image is an example of an embedding vector 
- This is a 2d vector basically and each column has a different embedding value, so at 0.32 in the image which would be the x axis every value in that specific rows column, so going up is unique
Notice in first image how after applying this embedding we up-sample, which just makes the embedding bigger basically so a cube
But this cube is unique to a specific noise variance so 0.32 for example. Jonathan think if we take 0.32 and it's column just 0.32 column then we up-sample which basically just makes this specific column a cube now. 

## ResidualBlock
- By including skip connections, the block has the option to bypass the complex weight updates
- This allows the network to be trained to great depth without sacrificing gradient size or accuracy 
- Basically this helps build a deeper network without suffering from the vanishing gradient problem and degradation problems
	- Degradation problem is the fact that as neural networks become deeper, they are not as accurate as shallower ones. Accuracy seems to become saturated at a certain depth and then degrade rapidly 
![[ResidualBlock.png]]
- So in the image you see there are 2 convolutions
- Then a separate branch with another convolution
	- This has a filter size of one pixel only
	- Doesn't change anything and helps enlarge the number of filleters so they're the same size from the batch norm part of the image 
- This helps because the deeper the network goes the smaller the gradient values are going to be
- So it kind of helps retain information
- 
- Ex:
	- So if we have say we go through this residual block and start off at 100 for the gradient values
	- Then we go through the convolutions in the top of the image so not the branch
	- This gets an output of 1 for the value
	- Now the branched convolution is added physically like concatenating, it's value which is 100 still since it doesn't change anything to the output of the top branch
	- This output is now 101, so information isn't lost
	- Think of this branched convolution as a base basically so we start from the base and add what every is outputted from the top branc$h
	- 
[[CS271]]