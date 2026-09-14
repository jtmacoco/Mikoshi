---
title: Training Mechanic
source: "[[MLP Core]]"
tags:
  - machine-learning
type: concept
created: 2026-09-13
---

## What is Training Mechanics

Training Mechanics covers everything that shapes *how well and how reliably* a network actually learns, beyond just "compute gradient, take a step" (that part's covered in [[Optimization]]). Forward prop, backprop, and optimization tell you the mechanics of *a single update*. Training Mechanics is about the surrounding decisions that determine whether thousands of those updates, strung together, actually produce a good model — or fall apart.

**Why this needs its own note:**

You can have perfectly correct backprop math and a solid optimizer, and still end up with a network that:
- never learns anything (bad initialization → gradients vanish before training even starts)
- memorizes the training set but fails on new data (overfitting)
- learns too slowly or unstably (poor normalization, bad hyperparameters)

None of that is a bug in the math — it's the *mechanics around* the math. This note is where those practical, often experience-driven concerns live.

**What this note covers:**

1. **Weight Initialization** — how starting values are chosen, and why "just use random numbers" isn't good enough (too large/small → vanishing/exploding signals from step one)
2. **Bias/Variance Tradeoff** — the lens for diagnosing *why* a model is underperforming (too simple vs. too closely fit to training data)
3. **Overfitting & Regularization** — L1/L2 penalties, dropout — techniques to fix high-variance problems
4. **Batch Normalization** — stabilizing the distribution of activations between layers during training
5. **Hyperparameters** — epochs, batch size, learning rate schedules — the dials you tune around all of the above

**The throughline:**

Each of these exists to answer one practical question: *"Given that the math works in principle, what do I need to get right in practice for training to actually succeed?"* That's the dividing line between this note and [[Backpropagation]] / [[Optimization]] — those are about the algorithm being *correct*; this is about training being *stable and generalizable*.

## Bias/Variance Tradeoff

**Bias**:
- Bias is the error introduced by approximating a real world problem