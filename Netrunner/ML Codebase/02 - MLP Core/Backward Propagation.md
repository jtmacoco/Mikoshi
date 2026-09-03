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


```html-embed
Mikoshi/Netrunner/ML Codebase/02 - MLP Core/02 - MLP Core_Assets/backprop.html
650
```
