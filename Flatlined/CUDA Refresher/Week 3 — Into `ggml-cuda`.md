---
title: Week 3 — Into `ggml-cuda`
source: "[[Contracts]]"
tags:
  - contract
created: 2026-08-11
status: completed
client: personal
deadline:
stack: cuda
---
| Day       | Task (≈30 min)                                                                                                                                                                                                                    |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mon       | Clone `llama.cpp`, build it, confirm it runs a model locally.                                                                                                                                                                     |
| Tue       | Open `ggml-cuda`'s quantization kernels (`Q4_0`/`Q8_0` dequant). You'll recognize the shape from your own quantization-adjacent work if you did any — if not, this is genuinely new, take it slow.                                |
| Wed       | Open the attention/KV-cache-related CUDA code. This is the part that should feel most familiar given your GPT-2 engine — actively compare their approach to yours line by line.                                                   |
| Thu       | Browse open issues labeled performance / good-first-issue. Shortlist 2-3 that overlap with what you just read (quantization or KV-cache/attention).                                                                               |
| Fri       | Pick one. Read every file it touches end to end.                                                                                                                                                                                  |
| Sat (lab) | Comment on the issue: your understanding of the problem, your proposed approach, and — worth stating explicitly — that you've built a from-scratch inference engine with KV caching, so the maintainer knows you're not guessing. |
| Sun       | Rest. You're back up to speed and have a concrete next target — this hands off directly into the contribution plan from before.                                                                                                   |
## Progress Log

- 2026-08-11: Contract initialized

## Notes


## Links

