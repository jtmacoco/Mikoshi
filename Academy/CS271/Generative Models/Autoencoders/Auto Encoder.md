## Architecture
- An auto encoder is a single neural network with 2 components:
	1. An encoder network that compresses high dimensional input data into a lower-dimensional embedding vector typically called z
	2. A decoder network that decompresses a given embedding vector back to the original domain
- So say we have a input of pants with a dimensional input of 2 that means the auto-encoder will pick a point and convert it to just two numbers. No matter how many pixels the pants image has it will be converted to just 2 numbers
- The decoder will then generate an image of pants that looks the same but isn't the same
- The idea behind the compression is to lose information, so we can generate something similar but different so not the same thing

## Denoising Models
- Auto-encoders can denoise models 
- It cleans noisy images by ignoring random noise positions in latent space
- <span style="color:rgb(192, 0, 0)">Larger latent space can cause the generative model issues </span>
## Loss: 
[[Reconstruction Loss]]
## Encoder
- <span style="color:rgb(0, 176, 80)">An encoder takes the input image and mps it to an embedding vector in the latent space</span>
- Use convolution to extract features
- Use a stride of 2, which basically halves every time
	- Another way to think about this is that first CNN layer focus on the eye, second focus on the wrinkles and so on
	- So after the first layer's feature map is now the input for the next layer in CNN portion 
- Then we flatten but there is no dense layer like traditional CNN
- Instead we basically have 3 convolution layers that will then pass it's output to a single dense layer which will then output the coordinates of the latent space
- <span style="color:rgb(192, 0, 0)">Every convolutional step we extract features so we have a lot of info basically</span>
- The dense layer is of size 2
	- This means we have an input layer and an output layer no hidden layers
- 2 for typical auto encoder has been proven to work best but may not bet the best

## Decoder
- <span style="color:rgb(0, 176, 80)">The decoder is a mirror image of the encoder, but instead of convolutional layers we use Convolutional Transpose</span>
- <span style="color:rgb(0, 176, 80)">Convolutional Transpose:</span> is a layer that doubles input tensor size with strides = 2
	- So it gradually expands layers to the original dimension size
- The trick to the Convolutional Transpose is that around every pixel we add zero's which will basically expand the back to original image size. 
- No pooling because we don't want to add any invariance to the position, so if a shoe is rotated we won't be able to really generate a good image of a shoe
- <span style="color:rgb(192, 0, 0)">Note we can have more dens layer you got this wrong Jonathan on mock exam please understand
</span>

## Joining Encoder to Decoder
- Need to compile with a loss function and optimizer
- So we use<span style="color:rgb(192, 0, 0)"> binary cross</span> entropy because this is technique like a binary classification, we are comparing pixels to pixels so 1 to 1
	- Look more blurry
- Can also use RMSE 
	- This will look more pixelated
- Binary Cross-entropy will penalize extremes fore (as it's asymmetrical)

## Reconstructing Images
- If raise dimensionality can create more detailed image
	- This is because we are retaining more information
	- Can re-create more complex particles
<span style="color:rgb(192, 0, 0)">NO LABLES USED TYPICALLY FOR AUTO-ENCODERS</span>
- This is because it's an unsupervised technique
Not typically centered at 0 for laten space

	



[[CS271]]