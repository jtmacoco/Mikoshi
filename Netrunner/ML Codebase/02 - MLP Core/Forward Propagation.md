---
title: Forward Propagation
source: "[[MLP Core]]"
tags:
  - math
  - machine-learning
type: concept
created: 2026-09-01
---

## What is Forward Propagation

Forward Propagation/Pass is the process of passing input data through a neural network, layer by layer, to compute an output (prediction). Each layer applies a linear transformation followed by a non linear activation function, and the result is passed forward to the next layer until the final output layer produces a prediction. Uses multiplication and addition no chain rule here.

---
## How it works

**For a single layer**:

```python
z = W·x + b        (linear transformation)
a = activation(z)   (non-linear activation, e.g. ReLU, sigmoid)
```

Where:
- `x` = input to the layer (either raw input data or previous layer's output)
- `W` = weight matrix
- `b` = bias vector
- `z` = weight sum ("pre-activation")
- `a` = output of the layer ("activation"), passed as input to the next layer

This repeats layer by layer
$$
\text{Input} (x) \rightarrow \text{Layer}1 \rightarrow \text{Layer}2 \rightarrow ... \rightarrow \text{Layer}N \rightarrow \text{Output} \hat{y}
$$

**Purpose**:
1. Generate predictions the output $\hat{y}$ is the model's guess for a given input
2. Compute loss $\hat{y}$ is compared against the true label $y$ using a loss function (like cross entropy, MSE, etc.) to measure how wrong the prediction is
3. Set up backpropagation  the activation's computed during the forward pass are cached and reused during the backward pass to compute gradients efficiently.

## Key point

Forward propagation is purely computational, no learning happens here. Weights are only updated afterward, during backpropagation, based on the error calculated from the forward pass's output.

```html-embed
Mikoshi/Netrunner/ML Codebase/02 - MLP Core/02 - MLP Core_Assets/forward_prop.html
650
```
