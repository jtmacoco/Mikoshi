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
- Bias is the error introduced by approximating a real world problem (which may be complex) with a simplified model.
- Formally: Bias = $\mathbb{E}[\hat{f}(x)] - f(x)$, the gap between the model's _average_ prediction (across different training sets) and the true value.
- High bias → the model makes systematic errors regardless of the data it sees. It's too simple to capture the real pattern.
- Symptom: **underfitting** — poor performance on both training and test data.
- Example: fitting a straight line to data that's actually curved.

**Variance**:
- Variance is the error introduced by the model's sensitivity to small fluctuations in the training data.
- Formally: Variance = $\mathbb{E}\left[(\hat{f}(x) - \mathbb{E}[\hat{f}(x)])^2\right]$, how much predictions swing if you retrain on a different sample.
- High variance → the model fits the noise in the training data, not just the signal.
- Symptom: **overfitting** — great performance on training data, poor performance on new/test data.
- Example: a very deep decision tree that memorizes quirks of the training set.

**Tradeoff**:

- Total expected error decomposes as: **Error = Bias² + Variance + Irreducible noise**
- Simple models → high bias, low variance.
- Complex models → low bias, high variance.
- The goal is to find the sweet spot that minimizes _total_ error, not to drive either term to zero individually.
- In practice, tools like cross-validation, regularization, and ensembling (bagging reduces variance, boosting reduces bias) help navigate this tradeoff.

**Target Analogy** (shooting at a bullseye): Think of the bullseye as the true value you're trying to predict, and each "shot" as a prediction from a model trained on a different sample of data.

- **Low bias, low variance** — shots land in a tight cluster, right on the bullseye. This is the ideal model: accurate and consistent.
- **High bias, low variance** — shots land in a tight cluster, but off to one side of the bullseye. The model is consistent, but consistently wrong (underfitting).
- **Low bias, high variance** — shots are scattered widely, but they're centered around the bullseye on average. The model is right "on average" but unreliable for any single prediction (overfitting).
- **High bias, high variance** — shots are scattered widely _and_ off-center. The worst case: inaccurate and inconsistent.

![[Training Mechanic-20260913225257003.png]]

## Bias: Two Different Meanings

These share a name but are **not the same concept**. Easy to conflate - keep them separate.

---

### 1. Statistical bias (bias-variance tradeoff)

- A **property/behavior** of a model, not a stored number.
- Measures how far off the model's _average_ prediction is from the true value, if you imagine retraining on many different datasets.
- Formula: `Bias = E[f̂(x)] − f(x)`
- High statistical bias → underfitting, model is too simple, systematically wrong.
- You don't "set" this directly — it emerges from model choices (architecture, complexity, features).
- See: [[Bias-Variance Tradeoff]]

### 2. Parameter bias (the `b` in `Wx + b`)

- A **literal trainable parameter**, exactly like a weight.
- Every neuron/layer has a bias term that shifts its output independent of the input.
- Updated via backpropagation and gradient descent, same mechanism as weights.
- No special meaning beyond "an offset the model learns" — it's just another number the optimizer tunes to minimize loss.
- This is what people mean when they say "weights and biases."

---

### Quick mnemonic

> **Parameter bias** = a number in the model. **Statistical bias** = a description of the model's overall behavior.

One is a knob. The other is what happens when you turn a bunch of knobs (including that one) in a particular direction.

**Why isn't there an equivalent "variance" parameter to update?**  
Because statistical variance isn't a single number sitting in the model waiting to be nudged  it's a description of how much the _whole trained model_ changes when you feed it different training sets. There's no single weight you can turn to directly set "variance = 0.3." Instead, variance is controlled indirectly, through things like: