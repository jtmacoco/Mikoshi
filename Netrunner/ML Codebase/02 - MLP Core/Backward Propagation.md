---
title: Backward Propagation
source: "[[MLP Core]]"
tags:
  - machine-learning
  - math
  - backpropagation
type: concept
created: 2026-09-03
---

## What is Backward Propagation

Backward propagation is the algorithm used to train neural networks by computing how much each weight in the network contributed to the prediction error, then updating those weights to reduce that error (minimize loss).

1. Forward pass input data flows through the network layer by layer, producing an output/prediction. The result is compared to the true value using a loss function, giving a single number representing how wrong the prediction was.
2. Backward pass starting from the loss, the algorithm works backward through the network, using the chain rule of calculus to compute the gradient (derivative) of the loss with respect to each weight. This tells you how much a small change in each weight would change the loss

**General Formula**:

$$
\frac{\partial L}{\partial a} * \frac{\partial a}{\partial z} * \frac{\partial z}{\partial w}
$$

## How it works

**Gradient = Derivative** basically the same, gradient is multi-variable derivative

**For a singe layer, going backward**:
```python
dz = da * activation_prime(z)     # gradient of loss w.r.t. pre-activation
dW = dz · a_prev.T                     # gradient of loss w.r.t. weights
db = dz                           # gradient of loss w.r.t. bias
da_prev = W.T · dz                # gradient passed to the previous layer
```

Where:
- `da` = gradient of the loss with respect to the layer's activation (comes from the layer *after* it, or from the loss function for the last layer)
- `activation_prime(z)` = derivative of the activation function, evaluated at the cached `z` from the forward pass
- `dz` = gradient of the loss with respect to the pre-activation
- `dW`, `db` = gradients used to update this layer's weights and bias
- `da_prev` = gradient handed off to the previous layer, continuing the chain

This repeats layer by layer, in reverse  
$$
\text{Loss} \rightarrow \text{Layer}N \rightarrow ... \rightarrow \text{Layer}2 \rightarrow \text{Layer}1 \rightarrow \text{Input}
$$

Each step applies the **chain rule**:
$$
\frac{\partial L}{\partial W^{(l)}} =
\frac{\partial L}{\partial a^{(l)}} \cdot
\frac{\partial a^{(l)}}{\partial z^{(l)}} \cdot
\frac{\partial z^{(l)}}{\partial W^{(l)}}
$$
which is exactly `da → dz → dW` above, expanded one layer at a time.

Purpose:

1. **Compute gradients**: determine how much each weight and bias contributed to the loss, layer by layer, using the cached `z` and `a` values from the forward pass
2. **Propagate error backward**:  pass `da_prev` to the previous layer so it can compute its own gradients, without redoing work already done downstream
3. **Update weights**:  once all gradients are computed, an optimizer (e.g. gradient descent) updates each layer's `W` and `b`:

```python
W = W - learning_rate * dW
b = b - learning_rate * db
```

## General Pattern

1. Undo the activation function -> get `dz` for this layer
2. Use `dz`  to compute this layers gradients -> `dW`, `db` (cache them don't apply yet)
3. Use `dz` to compute the delta for the **previous** layer -> `da_prev`

Undo the activation isn't taking the inverse rather saying how sensitive is the activation to the incoming delta. If I nudge `z` how much does `a` change . 

Softmax couples every output to every input (via the shared denominator), so unlike ReLU/sigmoid there's no simple per-neuron derivative — but paired with cross-entropy it simplifies to `dz = a - y` anyway, so you never need the full matrix in practice.

### Why multiplying by that "cancels through" the activation:

Think of it as a local exchange rate. If `da/dz = 0.5` at some point, that means a tiny change in `z` produces half as much change in `a`. So whatever sensitivity the loss has to `a` (`da`), the loss must be sensitive to `z` by only half as much — because `z`'s influence on the loss is _entirely funneled through_ `a`. Multiplying by `da/dz` converts "sensitivity in `a`-units" into "sensitivity in `z`-units."
## Backprop: Chain rule

Compute the $\frac{\partial L}{\partial W}$ this says if **If I nudge this weight how much does the loss change**
- $\frac{\partial L}{\partial a}$ - how loss changes with the layer's output (comes from the layer after it) 
	- How loss changes activation
- $\frac{\partial a}{\partial z}$ - derivative of the activation function
	- how the activation output changes with its pre-activation input (the "undo activation" step)
- $\frac{\partial z}{\partial w}$ - just the input of that weight, since $z =  wx + b \Rightarrow \frac{\partial z}{\partial w} = x$
	- how the pre-activation changes with this specific weight (this is just `a_prev`, the input to this layer

Can't compute $\frac{\partial z}{\partial w}$ contribution to the loss without first knowing $\frac{\partial a}{\partial z}$ contribution to the loss which itself needed $\frac{\partial L}{\partial a}$. t's a cascade - each factor only tells you the _local_ sensitivity (how one variable affects the very next one), and the chain rule strings all these local sensitivities together into one _global_ sensitivity (how a weight buried deep in the network affects the final loss, possibly through many layers)

**Why this matters for how backprop is actually implemented  this is the efficient trick:**

Rather than recomputing the _entire_ chain from scratch for every single weight in every layer (which would be insanely redundant - layer 1's weights and layer 2's weights share most of that chain), you compute the chain incrementally, backward, and **reuse** the partial product as you go

## How backprop uses derivatives

**Why $\frac{\partial z} {\partial w} = x$ (the "subtract 1" rule)**

- The power rule says: for $w^n$, the derivative is $n \cdot w^{n-1}$ (bring down the exponent, subtract 1 from it).
- In $z = wx + b$, the weight is really $w^1$ (exponent of 1).
- Apply the rule: $\frac{d}{dw}(w^1) = 1 \cdot w^0 = 1 \cdot 1 = 1$
- The $x$ was just a constant multiplier sitting next to $w$, so it comes along for free: $\frac{d}{dw}(wx) = x$

**One-line takeaway:** since $w$ only ever appears to the power of 1 in a linear layer, its derivative is always just "1", which leaves the input $x$ behind as the answer. That's why $\partial z/\partial w = x$ every time - it's not a special rule, it's the ordinary power rule on the simplest possible case.

**Quick table for your notes:**

| Term              | Derivative | Why                                              |
| ----------------- | ---------- | ------------------------------------------------ |
| $w^3$             | $3w^2$     | exponent drops 3→2, visible                      |
| $w^2$             | $2w$       | exponent drops 2→1, visible                      |
| $w^1$ (i.e. $wx$) | $x$        | exponent drops 1→0, $w^0=1$ vanishes, leaves $x$ |
| $b$ (no $w$)      | $1$        | derivative of $w$ w.r.t. itself is trivially 1   |



```html-embed
Mikoshi/Netrunner/ML Codebase/02 - MLP Core/02 - MLP Core_Assets/backprop.html
650
```
