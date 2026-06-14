Used for image classification and various image problems
## CNN Steps
- Convolution (with Relu)
- Max Pooling
- Flattening
- Full Connection
## Convolution helps solve 3 main problems
1. Input images may have different size
	- We would need to learn the different W matrices for each size
2. Every pixel in input means that we need a lot of weights in the network
3. <span style="color:rgb(192, 0, 0)"> Patterns that occurring in one location may not be recognized if occurred in different locations</span>

![[cnn-solve.png]]
- Here the image displays 1 where the color is black so the image is a cross
- We can design a weight vector to act as a matched filter for detecting the desired cross-shape
- This will give a strong response of 5 if the object is on the left, but a weak response of 1 if the objected is shifted over to the right 
- So the more the feature is present the larger the output number will be
	- If you look at the image there are some zero's surrounding the 1's so when we move the filter over it will have a smaller value since summing up the values with in the filter shape
	- This means that it will show that the image is less present over in different area's who's sum value is smaller
	- This is the big idea 
--- 
## Step 1 - Convolution
- This is the transformation in mathematical terms
	- $(f*g)(t)=\int_{-\infty}^\infty f(\tau)g(t-\tau)d\tau$
	- The verb to use is "to convole"
		- Translated from math is " to combine"
- Convolution for the discrete case
- Discrete convolution of $x=[1,2,3,4]$ with $w=[5,6,7]$ to yield $z=[5,16,34,52,45,28]$
- We see that this operation consists of "flipping" w and then "dragging" it over x, multiplying element wise , and adding up the results

	![[step1-convolution.png]]
- This is the same as the integral above the math formula
- <span style="color:rgb(0, 176, 240)">reversing the isn't important for neural  network</span>
![[ex-convolution-step1.png]]

-  No fixed rule for the strides
- The stride can be bigger than the matrix size, and if there is no padding then it will just display 2 numbers for example.
	- Say the stride was 2 in the above then $[2,5]$ would be the only 2 numbers , idea is that it makes the numbers even smaller
![[convolution-faster.png]]
- Since convolution is a linear operator, we can represent it by matrix multiplication, we do it this way since typically there are many zero's for things that aren't represent or may not want
- This basically just speeds up the algorithm, as we can reduce the weights that we need
-  CNNs are similar to MLPs (Multi-Layer-Perception), but their weight matrices have a special sparse structure 
	- Elements are tied across spatial locations, achieving translation in variance and significantly reducing the number of parameters compared to standard fully connected layer sin MLP
example of cnn extracting to a feature map

![[feature-map.png]]
- So notice how when we move the filter that it becomes 1, this means that we didn't find the feature but a part of the feature, so like say 25% of the feature
- This continues over and over basically
- Eventually we will find the feature
- Each of the numbers is a weight that the model can learn
	- They start random initialization 
- May not understand why the model is using this filter 
	- <span style="color:rgb(0, 176, 240)">Dataset dependent </span>
- <span style="color:rgb(0, 176, 240)"> What is the feature map? what did we obtain</span>
1. We reduced the size of the original matrix
	- The more the larger is the stride
2. The higher are the numbers, the more precisely the detected feature appears in the original image
	-  Note that it sill preserves the spatial relationships between pixels
3. We don't lose the pattern
- Can I have a convolution that maintains the size of the original image?
- Yes, it is called same Convolution, and it sues zero-padding
	- It basically adds a border of 0s to the image 
--- 
### How big is the feature Map?
- If the input has size $x_h*x_w$ we use a filter size of $f_h*f_w$ we use zero padding on each size of the $p_h$ and $p_w$, then the output has the following size:
	- $(x_h+2p_h-f_h+1)*(x_w+2p_w-f_w+1)$
![[feature-map-representation.png]]
- Important when we change the stride we reduce the dimensionality
--- 
### <span style="color:rgb(192, 0, 0)">How stride affects the size of the Feature Map?</span>
- If the input has size $x_h*x_w$ we use a filter size of $f_h*f_w$ we use zero padding on each size of the $p_h$ and $p_w$, and we use strides of size $s_h$ and strides $s_w$, then the output has the following size:
	- $\frac{x_h+2p_h-f_h+s_h}{s_h}*\frac{x_w+2p_w-f_w+s_w}{s_w}$
---  
- After creating the set of Feature Maps, we need to add some non-linearity 
- We apply the Rectifier activation function ReLU
	- All the negative values are filtered out
- This helps reducing the graduality of the color palette
	- Example: in a picture, colors go from bright to dark gradually. If we remove the negatives, it will change more abruptly. Less linearly!
- <span style="color:rgb(192, 0, 0)"> The deeper model more likely gradients will vanish or explode which is another reason for why to use ReLU</span> since CNNs can be pretty deep
## Step 2 Polling
- Convolution, though, has equivalence
	- It preserves info about the location of the patterns 
- We need to ensure our neural network has a property called translation invariance
	- Basically, that it doesn't care where the features are and doesn't care if the features a a bit tilted, different, relatively closer of far apart, and so on
- So we basically enhance the translation a bit
![[max-pooling.png]]
- <span style="color:rgb(192, 0, 0)">Doesn't overlap</span>
- So now we have info that it should be on left side 
- Helps in reducing the number of weights and adds a little bit of this translation in backgrounds 
- <span style="color:rgb(192, 0, 0)">There is a limit to how much the image can change </span>
--- 
## Step 3 Flattening 
-  Random initial weights for filters values so some can be negative and others can be positive
- Basically just flatten so can use in a feed forward neural net aka MLP
---
## Step 4 Full Connection
- In this network though, the backpropagation will not simply identify the weights to update, but also the "features"
- In fact, the Feature Detectors are also modified based on the error (via gradient descent)
![[step-4.png]]
---
## Vanishing or Exploding gradient
- A common solution to this problem is to add extra layers to the model
	- Layers that reduce overfitting
- We want to standardize the statistics of the hidden units
	- Zero mean and unit variance
	- This is similar to input standardization
- Alternatively, we can modify the Loss function to penalize greater weight values
--- 
## Batch Normalization
- The most popular normalization layer is called batch normalization
	- Distributions of the activation within a layer has zero mean and unit variance, when averaged across the samples in a mini batch
	- We replace the activation vector $z_n$ (input to given layer) for example with $\bar{z}_n$
- Since we use mini batch gradient descent when we back propagate, we need to consider the result of obtained within a single batch
- So we need the mean and standard deviation, and the variance a little, of all the resulting numbers in the activation vector that are generated by a single batch
- When input information, when you input a sample, a single sample from a batch
	- Now this sample will go through the process through all the operations and will generate outputs
	- <span style="color:rgb(192, 0, 0)"> Here we save these outputs on the side, which is what batch normalization will do</span>
		- They're stored in a vector
	- We repeat this process again and again  until all samples from a single batch have computed values in this vector
	- For every sample we have a collection of vectors based on how many layers we have
	- For a single batch, we have a vector for this hidden layer for every single sample in the batch, so if I have 100 samples in the batch I have 100 of those vectors
	- Now we compute the mean and standard deviation for every single batch
- Formula:
	- $\tilde{z}_n=\gamma \odot \hat{z}_n+\beta$
	- $\hat{z}_n=\frac{z_n-\mu_B}{\sqrt(\sigma_B^2+\epsilon)}$
		- $\beta$ : is the mini-batch containing the example $n$
		- $\mu_b$ : is the mean of the activation in this batch
		- $\sigma_B^2$ : is the corresponding variance
		- $\hat{z}_n$ is the standardized activation vector
		- $\tilde{z}_n$ : is the shifted and scaled version ( the output of the BN layer)
		- $\epsilon\gt0$ : a small constant
		- $\beta$ (shift) and $\gamma$ (scale) are learnable parameters
		- $\odot$ is element-wise product 
---
## Batch Normalization - Test set
- Since this transformation is differentiable, we can easily pass gradients back to the input of the layer and to the BN parameters $\gamma$ and $\beta$
- And during test? We have a single input, so we cannot compute batch statistics. The standard solution to this is as follows
1. After training, compute $\mu_l$ and $\sigma_l^2$ for layer $l$ across all the examples in the training set ( the full training set) \[of course, a move average]
2. Then, save these parameters, and add them to the list of other parameters for the layer ($\beta_l$ and $\gamma_l$)
3. At test time, we use these saved training values instead of computing statistics from the test batch
- Note that when using a model with BN, we need to specify if we are using it for inference(test) or training 
- Basically when the we test the model, is this ideal so and so because maybe that specific sampling input would have required a different mean and variance, but this is a way to average down the mean and variance of the full training set
- So basically everything the model understands then the input should be a generalization of that training set
--- 
## Batch Normalization - Last words
- The benefits of batch normalization ( in terms of training speed and stability ) are greate
	- Especially for deep CNNs
- The exact reasons for this are still unclear
	- BN seems to make the optimization landscape significantly smoother
	- It also reduces the sensitivity of the learning rate
- However it struggles, when the batch size is to small
	- The estimate mean and variance parameters can be unreliable
	- One solution is to compute the mean and variance by pooling statistics across other dimensions of the tensor, but not across examples in the batch
![[bn.png]]
---
## Weight Decay
- Weight decay (aka $L_2$ Regularization) is a regularization technique applied to the weights of a neural network
	- We add a penalizing factor to the loss function ( a penalty on the $L_2$ Norm of the weights):
		- $L_new(y,t) = L_{orig}(y,t)+\lambda||w||^2$
		- $\lambda$ is a value determining the strength of the penalty 
- Computing the size of the weights then multiply by a factor of $\lambda$
- If the weights are to large the the loss will increase
---
## Dropout
- To reduce overfitting, we can apply Dropout to the network
	- A form of regularization
- The idea is that we let a layer to randomly drop out a few output units from the layer itself during the training process
	- By setting the activation to zero
	- We can pick the percentage of the output units that are dropped out randomly from the applied layer

[[CS271]]