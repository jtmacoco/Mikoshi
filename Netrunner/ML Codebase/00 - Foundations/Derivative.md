---
title: Derivative
source: "[[Foundations]]"
tags:
  - math
type: concept
created: 2026-09-04
---
## What is Derivative

A derivative measures how fast something is changing - the rate of change of a function at a given point. Geometrically, it's the slope of the tangent line to the function's graph at that point.

Notation:
- $\frac{d}{dx}$ → the operator: "take the derivative w.r.t. x"
- $\frac{dy}{dx}$ → the result: the derivative of y w.r.t. x
- $f'(x)$ → same idea, different notation (Lagrange's)

Formal definition (limit of a ratio of tiny changes):

$$\frac{dy}{dx} = \lim_{\Delta x \to 0} \frac{\Delta y}{\Delta x}$$

---

## Example / Usage

$$y = x^2$$

$$\frac{dy}{dx} = 2x$$

At $x = 3$, slope $= 6$ — meaning at that point, y is increasing 6x as fast as x.

---

## When to Use

- Finding the slope/rate of change at a specific point
- Finding maxima/minima (where derivative = 0)
- Physics: velocity = derivative of position, acceleration = derivative of velocity
- Optimization problems (cost, profit, efficiency, etc.)
- Related rates (how one changing quantity affects another)

---

## Watch Out For

- $\frac{d}{dx}$ alone is NOT a number — it's an operator waiting for a function
- $\frac{dy}{dx}$ LOOKS like a fraction but is technically a limit, not literal division (though it often behaves like one, e.g. in the chain rule)
- Derivative ≠ the function itself — it's a NEW function describing the original's rate of change
- A derivative existing requires the function to be continuous AND "smooth" at that point (no sharp corners, breaks, or vertical tangents)
- Don't confuse $\frac{dy}{dx}$ (derivative) with $\frac{\Delta y}{\Delta x}$ (average rate of change over an interval) — derivative is the instantaneous version