---
title: Optimization
source: "[[MLP Core]]"
tags:
  - machine-learning
type: concept
created: 2026-09-07
---

## What is Optimization

Optimization is the process of adjusting a network's weights and biases to minimize the loss function. Backpropagation tells you *which direction* and *how much* each parameter contributed to the error (the gradient); optimization is what actually *uses* that gradient to update the parameters.

**The core idea:**

Think of the loss function as a landscape — a surface where height = error. Every point on that surface corresponds to one specific setting of all the network's weights. Training is the process of walking downhill on that surface until you reach a low point (ideally the lowest).

Gradient descent is the basic strategy for that walk:

1. Compute the gradient of the loss with respect to each weight (via backprop)
2. The gradient points in the direction of *steepest increase*
3. Move the weights in the *opposite* direction (steepest decrease)
4. Repeat until the loss stops improving (or improves negligibly)

**The core update rule** (this is the equation everything else in this note is a variation of):

$$w \leftarrow w - \eta \cdot \nabla_w L$$

Where:
- $w$ = a weight (or bias)
- $\eta$ (eta) = learning rate — how big a step to take
- $\nabla_w L$ = gradient of the loss $L$ with respect to $w$ — comes straight out of backprop

**Why this is its own topic separate from backprop:**

Backprop answers *"which way is downhill, and how steep?"*
Optimization answers *"given that, how do I actually walk?"*

You could in theory take the raw gradient and apply the simplest possible update (that's plain gradient descent, below) - but in practice, *how* you use the gradient (how big a step, whether you smooth it over time, whether you adapt it per-parameter) has a massive effect on training speed and stability. That's what the rest of this note covers: Batch GD → SGD → Mini-batch → Momentum → Adam/RMSprop, each one refining *how the gradient gets turned into a weight update.*

---
