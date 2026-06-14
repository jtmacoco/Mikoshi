## Upsampling 
- An alternate to Convolutional transpose
- The trick is to take one pixel and surround it with a copy of that pixel
- Helps avoid a more pixelated image 
## Convolutional Transpose
- The trick to the Convolutional Transpose is that around every pixel we add zero's which will basically expand the back to original image size. 
Note that a stride of 2 is most commonly used but the stride can be different for either Upsampling or convolutional transpose
[[CS271]]
