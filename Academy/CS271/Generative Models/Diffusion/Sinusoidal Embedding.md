<span style="color:rgb(190, 45, 137)">Jonathan if you forget please just remember this red sentence below (I know you forget from past Jonathan)</span>

> <span style="color:rgb(192, 0, 0)">The meaning behind the sinusoidal embeddings is to tell the model which time step we are trying to predict the noise</span>



![[u-net-embedding.png]]
- Example metrics
	- Batch size B = 4
	- Embedding Length = 104
	- Diffusion time-steps = [10, 200, 50, 999]
---
- So Sinusoidal Embedding is typically used to encode 
- It takes a time step $t$ and turns it into a smooth continuous vector

- This helps predict the noise at each time step by injecting positional information on where the model is on our noise schedule

- So basically the model needs to know if de-noising early or not
- And we can't feed scalar value t directly since neural nets will struggle
---
### Create Frequencies
- We do this using exponential spacing
- The reason is because 
	- Low frequency components -> encode coarse changes in $t$
	- High frequency components -> encode fine-grained differences
- Gives network a multi-scale representation of time
### Intuition behind Sin/Cos Encoding
- Periodicity(wraps around smoothly)
- Symmetry
- unique representation of time stamps
---
### Example
```python
B = 4
dim = 128
t = tensor([10, 200, 50, 999])
```

- we must proximate the frequencies so create a list of frequencies 

- Since dim is 128 we talk half so 64 will be sine and 64 will be cosine freqs
	- Pytorch command (won't work but you get the general idea) to create a list of freqs
		- `freqs = torch.exp( -log(10000) * torch.arange(half)/(half-1) )`
		- ex output something like [0,.0001,0.002332,]
		- This list right now is just a bunch of numbers separated exponentially 
		- No sine or cosine have been applied
- So now our time embedding looks like `[10, 200, 50, 999]` and our freqs look like `[10, 200, 50, 999]`
- So in order to multiply them together properly we must adjust the shapes this is because we want to multiply every time by every frequency so something like:
```
Row 0: t = 10    → 10 * freq[0..63]
Row 1: t = 200   → 200 * freq[0..63]
Row 2: t = 50    → 50 * freq[0..63]
Row 3: t = 999   → 999 * freq[0..63]
```

- So we add a 0 dimension to the freqs and a 1 dimension to get the right dimensions for the multipication
- Then just take the sine and cosine of those values and concat them together 
[[CS271]]