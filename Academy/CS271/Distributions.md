## Mnemonic:

> **If your model should pick one thing, use Categorical.  
> If it should guess a number, use Normal.**
## General Rule of Thumb

|**Type of Output**|**Use this Distribution**|**Why**|
|---|---|---|
|**Discrete categories** (e.g., "left"/"right", class labels)|**Categorical**|Output is one of a **finite set** of distinct values|
|**Continuous scalar values** (e.g., torque, pixel intensities, noise)|**Normal (Gaussian)**|Output is **real-valued** and varies smoothly|
|**Bounded continuous values** (e.g., between 0 and 1)|**Beta** _(less common)_ or clamp Normal|Useful if the output must stay within bounds|
|**Binary (yes/no, on/off)**|**Bernoulli**|A special case of categorical for 2 outcomes|
|**Counts (non-negative integers)**|**Poisson**|For modeling things like event counts|
|**Overdispersed counts or positive integers**|**Negative Binomial**|Like Poisson, but with more variance|
## Examples in Practice

### 1. **Reinforcement Learning**

- `CartPole` → Actions: {0, 1} → ✅ **Categorical**
    
- `Pendulum` → Action: torque ∈ [-2, 2] → ✅ **Normal**
    
- `Taxi-v3` → 6 discrete moves → ✅ **Categorical**
    

### 2. **Diffusion Models**

- Predict noise for images → ✅ **Normal**
    
- (Alternate: Discrete latent tokens like in VQGAN → **Categorical**)
    

### 3. **Classification (ML)**

- MNIST digit classifier → 10 digits → ✅ **Categorical** (via softmax)
    
- Binary spam classifier → ✅ **Bernoulli** (via sigmoid)
    

### 4. **Autoencoders / VAEs**

- Latent variable → ✅ **Normal** (prior and posterior distributions)
    
- Output reconstruction (image pixels) →
    
    - If using continuous pixel values → ✅ **Normal**
        
    - If using discrete 8-bit pixels → 🟡 **Categorical** _(but computationally heavier)_


## Practical Notes

- **Use `Categorical`** if your output is a **choice** among named labels or discrete actions.
    
- **Use `Normal`** if your output is **numeric and smooth** (e.g., torque, noise, pixel values).
    
- **Check your action or output space** (in Gym, it's `action_space` or `observation_space`):
    
    - `Discrete` → `Categorical`
        
    - `Box` → `Normal`
      
[[CS271]]
