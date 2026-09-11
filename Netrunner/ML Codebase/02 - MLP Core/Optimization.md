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

- Optimizer = gradient descent

## Watch Out For

> [!danger] Don't confuse optimizer vs. batch size
> These are **two separate dials**, not a hierarchy — don't mix them up.
>
> - **Optimizer** (`torch.optim`) → *how* you use a gradient to update params
>   `SGD`, `Momentum`, `Adam`, `RMSProp`
> - **Batch size** (`DataLoader`) → *how much data* you average before computing that gradient
>   `1` (stochastic), `32/64/128` (minibatch), `full dataset` (batch)
>
>  Any optimizer can pair with any batch size - they're orthogonal.
>  Minibatch is NOT a type of optimizer.
>
>  **OPTIMIZER DO NOT HAVE A BATCH SIZE**

> [!important] Minibatch GD = a DataLoader setting, not an optimizer
> "Minibatch gradient descent" is just a **description of your data setup** — it's not a class, not something with `.step()`.
>
> ```python
> train_loader = DataLoader(
>     dataset,
>     batch_size=32,   # <- THIS is what makes it "minibatch"
>     shuffle=True      # <- randomizes order each epoch (common pairing, not required)
> )
> ```
>
> - `batch_size=1` → stochastic GD
> - `batch_size=32/64/128` → **minibatch** GD
> - `batch_size=len(dataset)` → full-batch GD
>
> The optimizer (`SGD`, `Adam`, etc.) just consumes whatever gradient falls out of the batch — it never sees `batch_size` itself.
>
> Quick test: if it doesn't have `.step()`, it's not an optimizer.

---


