---
title: Backward Propagation
source: "[[MLP Core]]"
tags:
type: concept
created: 2026-09-03
---

## What is Backward Propagation

Backward propagation is the algorithm used to train neural networks by computing how much each weight in the network contributed to the prediction error, then updating those weights to reduce that error (minimize loss).

1. Forward pass input data flows through the network layer by layer, producing an output/prediction. The result is compared to the true value using a loss function, giving a single number representing how wrong the prediction was.
2. Backward pass starting from the loss, the algorithm works backward through the network, using the chain rule of calculus to compute the gradient (derivative) of the loss with respect to each weight. This tells you how much a small change in each weight would change the loss

## How it works

**For a singe layer, going backward**:
```python
dz = da * activation_prime(z)     # gradient of loss w.r.t. pre-activation
dW = dz · x.T                     # gradient of loss w.r.t. weights
db = dz                           # gradient of loss w.r.t. bias
da_prev = W.T · dz                # gradient passed to the previous layer
```

Where:
- `da` = gradient of the loss with respect to the is layer's activation (comes from the layer after it, or from the loss function for the last layer)
- `activation_prime(z)` = derivative of the activation function, evaluated at cached `z` from the forward pass
- `dz` = gradient of the loss with respect to the pre-activation
- `dW`, `db` = gradients used to update this layer's weights and bias
- `da_prev` = gradient handed off to the previous layer, continuing the chain

This repeats layer by layer, in reverse  
$$
\text{Loss} \rightarrow \text{Layer}N \rightarrow ... \rightarrow \text{Layer}2 \rightarrow \text{Layer}1 \rightarrow \text{Input}
$$

Each step applies the **chain rule**:

$$ \frac{\partial L}{\partial W^{(l)}} = \frac{\partial L}{\partial a^{(l)}} \cdot \frac{\partial a^{(l)}}{\partial z^{(l)}} \cdot \frac{\partial z^{(l)}}{\partial W^{(l)}} $$

## Backprop: chain rule

Backprop computes 

>[!important] Key Idea
> If I nudge this weight how much does the loss change?


## Animation 

```html-embed
Mikoshi/Netrunner/ML Codebase/02 - MLP Core/02 - MLP Core_Assets/backprop.html
650
```
