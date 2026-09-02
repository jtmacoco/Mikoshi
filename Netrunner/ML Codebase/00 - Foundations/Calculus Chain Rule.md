---
title: Calculus Chain Rule
source: "[[ML Codebase]]"
tags:
  - math
  - machine-learning
type: concept
created: 2026-09-01
---
## What is Calculus Chain Rule

The chain rule tells you how to differentiate **nested (composed) functions** — a function inside a function.

If $z = f(y)$ and $y = g(x)$, so that $z = f(g(x))$, then:

$$\frac{dz}{dx} = \frac{dz}{dy}\cdot\frac{dy}{dx} = f'(g(x))\cdot g'(x)$$

**Core intuition:** a derivative is a _local scaling factor_ — "for every tiny unit the input moves, the output moves this many units." When functions are nested, one function's output becomes the next function's input, so the effects **compose by multiplying the scale factors**, like gears in series. If $x \to y$ scales by 2, and $y \to z$ scales by 3, then $x \to z$ scales by 6 — because $y$ is the _only channel_ through which $x$ can affect $z$.

**Where it comes from (quick derivation):**

- Perturb $x$ by tiny $\varepsilon$. By definition of derivative: $g(x+\varepsilon) \approx g(x) + g'(x)\varepsilon$
- That perturbation in $y$, call it $\delta = g'(x)\varepsilon$, feeds into $f$: $f(y+\delta) \approx f(y) + f'(y)\delta$
- Substitute: $f(g(x+\varepsilon)) \approx f(g(x)) + f'(y)g'(x)\cdot\varepsilon$
- Match coefficients of $\varepsilon$ → $\frac{dz}{dx} = f'(y)g'(x)$

**Multivariable / branching version:** if $x$ affects $z$ through _multiple_ paths (e.g. $y_1$ and $y_2$), sum the contributions:

$$\frac{\partial z}{\partial x} = \frac{\partial z}{\partial y_1}\frac{\partial y_1}{\partial x} + \frac{\partial z}{\partial y_2}\frac{\partial y_2}{\partial x}$$

This matters a lot for computation graphs (neural nets) where a value can feed into several downstream nodes — gradients **accumulate (sum)** at branch points.

---

## Example / Usage

**Basic:** $z = \sin(x^2)$

- Outer: $f(y) = \sin(y)$, $f'(y) = \cos(y)$
- Inner: $y = g(x) = x^2$, $g'(x) = 2x$
- Result: $\frac{dz}{dx} = \cos(x^2)\cdot 2x$

**Deep nesting (3 functions):** $L = f_3(f_2(f_1(x)))$

$$\frac{dL}{dx} = \frac{dL}{df_3}\cdot\frac{df_3}{df_2}\cdot\frac{df_2}{df_1}\cdot\frac{df_1}{dx}$$

**Backpropagation (neural nets):** each layer is a nested function; the loss is the outermost function. To get $\frac{\partial L}{\partial w}$ for a weight buried deep in the network, you don't need one giant formula — you multiply local derivatives layer by layer, walking backward from the loss. This is why backprop is efficient: each layer only ever computes its own _local_ derivative, and the chain rule stitches them together correctly.

---

## When to Use

- Differentiating any composed/nested function — $f(g(x))$, $f(g(h(x)))$, etc.
- Implicit differentiation (treat $y$ as $y(x)$ and chain through it)
- Related rates problems (multiple quantities changing with respect to time, linked through equations)
- Backpropagation / gradient computation in neural networks — the entire algorithm _is_ the chain rule applied systematically across a computation graph
- Anywhere you have an intermediate variable that mediates the relationship between two others

---

## Watch Out For

- **Forgetting the inner derivative** — the most common mistake. $\frac{d}{dx}\sin(x^2) \ne \cos(x^2)$; you must also multiply by $2x$.
- **Branching paths need addition, not just multiplication** — if $x$ influences $z$ through more than one route, sum the path-products instead of picking just one.
- **Evaluate derivatives at the right point** — $f'(y)$ must be evaluated at $y = g(x)$, i.e. at the inner function's _output_, not at $x$ itself.
- **Order of composition matters** — $f(g(x)) \ne g(f(x))$ in general, so double-check which function is "outer" and which is "inner."
- **Local vs. global** — each derivative in the chain is a _local_ approximation (valid for small perturbations). The chain rule is exact in the limit, but don't confuse it with a global linear relationship between $x$ and $z$.
- **In computation graphs**, it's easy to lose track of _which_ intermediate variable a gradient is "with respect to" — keep clear whether you're computing $\frac{\partial L}{\partial y}$ (upstream gradient) vs. $\frac{\partial L}{\partial x}$ (what you actually want).
