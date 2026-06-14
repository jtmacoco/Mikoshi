## <span style="color:rgb(0, 176, 80)">Definition:</span>
- Problem occurs when gradients(values used to update weights) become very small during backpropagation, especially in deep neural networks
- So basically if we continue to multiply a very small number it will get even smaller
- ex: Gradient after 10 layers ≈ 0.1 * 0.25^10 ≈ 0.1 * 0.0000009537 ≈ 0.00000009537
- So the model is working so hard but isn't learning anything really since the weights barley change, in a sense our model is stuck, i.e. the gradient vanished

[[CS271]]