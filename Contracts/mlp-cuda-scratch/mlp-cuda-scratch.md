---
title: mlp-cuda-scratch
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-15
status: on-contract
client: personal
deadline:
stack: c, cuda
---

## Objective

Develop from scratch MLP for MNIST dataset, then profile and use cuda to speed up


## Stack / Tools

- C++
- CUDA


## Progress Log

-  2026-08-15: Contract initialized
-  2026-08-15: Working on loading the dataset
-  2026-08-16: Finished loading dataset
-  2026-08-16: Working on forward pass
-  2026-08-17: Initialized Weights finished
-  2026-08-17: Working on linear forward pass trying to make similar to pytorch
-  2026-08-18: Made linear it's own object and re-named some files and moved some functions around
-  2026-08-20: Linear function compiles and works with mlp class, haven't verified if it works
-  2026-08-20: Working on backend process
- Kind of stopped keeping up with this but I going to start again kind of felt this was helpful
- 2026-09-12: Finished AdamW function need to check
- 2026-09-12: Fix training loop so far
- 2026-09-13: Adamw and gradient descent pass implemented


## Notes

- **How to figure out number of weights**:  $\text{num\_weights} = \text{in\_feats} \times \text{out\_feats}$
- Read HE paper
- out_feats: means  the number of nodes (neurons) in the layers output
- Each layer in a neural net get's its own initialization
- for `cross_entropy` formula returns $ln(y_i)$ since $t_i$ is 1 and the rest are 0's which zero out the rest so no need to sum (loop) over rest of values
- `log` in c++ is natural log so $ln$

### How to read data big endian

- `bytes[0]` is the _most significant_ byte in the file, so it gets shifted left by 24 bits to become the top byte of the result.
- `bytes[1]` becomes the next byte (shift 16).
- `bytes[2]` becomes the next byte (shift 8).
- `bytes[3]` is the least significant byte (no shift).

The `|` (bitwise OR) then combines all four into one `uint32_t`. This is the standard manual way to parse a big-endian 32-bit value regardless of the host machine's endianness.

### Example of pass through

- This is meant to help show why we use the transpose in the backward pass
	- i.e. column major loop

```html-embed
Mikoshi/Contracts/mlp-cuda-scratch/mlp-cuda-scratch-assets/linear_backprop_walkthough.html
600
```

## Bias Questions

Each **weight** is tied to a specific `(input, neuron)` pair — that's why it needs the inner `j` loop, it has to touch every input feeding into neuron `i`.

Each **bias**, though, belongs only to the neuron itself, not to any particular input. There's exactly one `bias[i]` per output neuron, regardless of how many inputs that neuron has. So it doesn't belong in the inner loop at all — it's correctly added _once_, after the inner loop finishes summing up all the weighted inputs.

If you tried to add bias inside the inner `j` loop, you'd accidentally add it multiple times (once per input feature) — that would be a bug, not a feature.

**Does it still affect the output? Yes, directly.**

Look at the line: `output[i] = sum + bias[i];`

`bias[i]` is added straight into `output[i]` — full strength, not scaled by any input. That's the whole point of a bias: it shifts the neuron's output regardless of what the inputs are, even if every `input[j]` were `0`.

**Where does it get "adjusted" then?**

Nowhere in the `forward` code you pasted — this is just the forward pass. Bias only gets updated during **backpropagation**, in whatever `backward()` method computes gradients. There, the gradient with respect to `bias[i]` is just the gradient flowing out of `output[i]` (summed over the batch, if you're batching) — it doesn't need the chain-rule multiplication by `input[j]` that weight gradients need, precisely because bias wasn't multiplied by any input on the way in.

So the asymmetry you're seeing in `forward()` (bias outside the inner loop) is intentional and mirrors a similar asymmetry you'll see in `backward()`: weight gradients need the inputs, bias gradients don't.

