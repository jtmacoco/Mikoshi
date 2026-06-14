## Transformers
- Encoder transformers extract a meaningful contextual representation of the input
- Encoder-Decoder Transformers translate ( and more ) from one text string to another
- Decoder Transformers generate a text string one token at a time
![[transformer-arch.png]]
- The image above is an example of architecture
- <span style="color:rgb(0, 176, 240)">The left side of the image is the encoder</span>
- <span style="color:rgb(0, 176, 240)">The right side is the decoder</span>
- <span style="color:rgb(192, 0, 0)">The input is the whole sequence, not single words</span>
- We have no recurrence, no convolution 
	- Only attention and fully connected layers
- The learnable parameters consist of nothing more than three densely connected weights matrices for each attention head $(W_Q,W_K,W_V)$ and one further weights matrix to reshape the input $(W_O)$
- This is a generic transformer architecture 
---
## Transformer Block
![[transformer-block.png]]
<span style="color:rgb(0, 176, 80)">A Transformer Block is made of:</span>
1. Multi-head attention layer
	- <span style="color:rgb(0, 176, 240)">So as you can see there are 3 vectors in input which is called attention</span>
	- This is called multi head because you actually have multiple modulus, multiple buffers
2. Skip Connections
	- This helps building very deep neural networks reducing the vanishing gradient problem
	- Basically logic is same as discussed in CNN lecture
		- We don't want the numbers to disappear, so add a base to them and don't want them to become to large so normalize them
3. Normalization
	- Layer normalization is used to provide stability to the training process
4. Feed-forward (dense) layers
	-  To allow the block to extract higher-level features as we go deeper into the network
	- Classic deep learning more info in deep learning section
---
## Queries, Keys, and Values
- We can think of an attention head as a kind of <span style="color:rgb(0, 176, 240)">informational retrieval system</span>
- A <span style="color:rgb(0, 176, 80)">query</span> ("what word follows too?") is made into a key/value pair
	- Ex: "<span style="color:rgb(190, 45, 137)">The pink elephant tried to get into the car but it was too ...</span>"
- The final output is a weighted sum of these values
	- Where the weights are determined by the degree of correlation between the question and each key
--- 
![[transformer-arch.png]]
- The query is what comes after the word "too"
- Using example in pink
---
## Going through example step by step
![[transformer-step1.png]]
- The <span style="color:rgb(0, 176, 80)">query Q</span> can be thought of ass a representation of the current task at hand ("What word follows too?")
- The <span style="color:rgb(0, 176, 80)">query Q</span> is derived from the embedding of the word too by passing it through a weights matrix $W_Q$ to <span style="color:rgb(112, 48, 160)">change the dimensionality of the vector</span> from $d_e$ to $d_k$
- The image shows an embedding of the word "too" which is 84 
	- The word "too" is always 84, think of like embedding location kind of 
	- Nothing special about it being 84
- There is a matrix $W_Q$
	- The input vector will be multiplied by this matrix, that contains weights that can be learned
	- This is to obtain a reduced dimensionality version of the embedding in the input
	- This is the query $d_k$ in the image which is of size 4 
	- <span style="color:rgb(0, 176, 240)">So the 6 numbers in input will become a vector of 4</span>
	- It's compressed as when we compress we highlight what is important and remove noise (less important stuff basically)
- The information contained in the $d_k$ is not just the word "too" but it's the word "too" with the query I'm asking the model to perform
- Now guess what's next after "too"
- So the numbers are basically indicating what is the word after "too"
### Bottom half of the image
- Each word from the sentence goes through a similar process as described above
- Each word is multiplied by the same matrix $W_K$ to generate a reduced dimensionality of each word called <span style="color:rgb(192, 0, 0)">key</span>
	- This is the key to understand the output
- <span style="color:rgb(192, 0, 0)">The query size and the key size must be the same</span>
- So in the example it's a size 4
- So each word is processed to reduce it's dimensionality to focus
	- Let's focus and get rid of the noise
--- 
- Then what happens?
- Each <span style="color:rgb(192, 0, 0)">key</span> is compared to the <span style="color:rgb(0, 176, 80)">query </span> using a dot product between each pair of vector $(QK^T)$
	- This is why the keys and query have to be the same length
-  The higher  this number is for a particular key/query pair, the more the key resonates with the query

![[transformer-step1.5.png]]
- Note we normalize by the length it self and if you notice the softmax part we have a sqrt this is to keep the variance 1 or more precisely steady
- So multiply the key and query together
- <span style="color:rgb(0, 176, 240)">Why do we multiply</span>
	- The query numbers will resonate more with some words
	- The more similar the words are <span style="color:rgb(192, 0, 0)">keys</span> are to the <span style="color:rgb(0, 176, 80)">query</span> the greater the product will be
- We use softmax because we want a probability distribution
- Now basically if the product is greater, for example say $10*100$,  given this query, this means that the word is very important
- So the output of this product will be greater and then when we softmax, we normalize to create a probability distribution 
	- So the most important words will have more percentage will appear stronger
- So what we are trying to do is find in space the area where the context is
- Then focus on this area of space to look for the right word
- The model will be trained on the same query multiple times until the output is satisfying
- <span style="color:rgb(0, 176, 80)">Query is a representation of the prompt, but compressed in a small vector</span>
	- Query is kind of like the context of what is required
- From slides:
--- 
![[transformer-1.7.png]]
	- The resulting vector is <span style="color:rgb(112, 48, 160)">scaled</span> by $d_k$ to keep the <span style="color:rgb(112, 48, 160)">variance of the vector sum stable</span> (approximately equal to 1)
	- Softmax is applied to ensure the contribution sum to 1
	- This is a vector f attention weights
	
---  
![[transformer-1.8.png]]	
- The value of Vector V are also representations of words in the sentence
		- You can think of these as unweighted contributions of each word
	- The vector V is derived by passing each embedding through weights matrix $W_v$ to change the dimensionality of each vector from $d_e$ to $D_v$
		- <span style="color:rgb(0, 176, 240)">Notice that the value of the vectors don't necessarily have to have the same length as the keys and query's ( but often they do, for simplicity)</span>
- <span style="color:rgb(192, 0, 0)">We use the key information to compute the weights, we don't want to use the keys because the weights come from this (the keys)</span>
- So we basically have a second representation of the same words
--- 
So notice in the previous image with the full example that the irrelevant words like "pink" have a lower attention weight value because they don't matter, so we've removed the noise from the sentence
- So what we have is contextualized value, an understanding of the sentence 
- So now the input into the deep learning model is easier since we are basically saying "car into Elephant too",  which is much easier for the deep learning model to solve, i.e. predict the next word
--- 
## Multi-Head Attention

![[multi-head.png]]
- Multi-Head Attention concatenates the output from multiple attention heads
	- Where each learns a distinct attention mechanism for more complex relation ships
- The weights matrix $W_0$ projects the vector into the desired output dimension
	- In our case is the same as the input dimension of the query ($d_e$) so that the layers can be stacked sequentially on top of each other
- <span style="color:rgb(0, 176, 240)">Want the model to have multiple opportunities to understand more, but really want to have more weights to play with</span>
- More parameters the network has the better can understand
---
## Layer Normalization 
![[layer-norm.png]]
- With batch normalization the output from each channel is normalized to have a mean of 0 and standard deviation of 1
	- The normalization statistics are calculated across the batch and spatial dimensions
- Layer normalization normalizes each position of each sequence in the batch by calculating the normalizing statistics across the channels
	- It is the opposite of batch normalization, in terms of how the normalization statistics are calculated
- Different from batch normalization because we want to normalize the layer as it is without caring about previous batch inputs
	- We do this because we want the numbers to be small at every step
![[layer-norm2.png]]
- Remember: Neural Networks learn better if the inputs to a layer have uniform mean and standard deviation in each dimensions
	- Otherwise, the larger parameters will dominate the updates
- However, the more you train the less uniform these inputs become
- We add Layer Normalization
- Layer Normalization is like "cheating" the results so uniform 
- So when we input the whole sentence the position of the words is kind of lost like what was the first word, or the last word
---
## Positional Encoding
![[positoinal-encoding.png]]
- Without positional encoding we have <span style="color:rgb(112, 48, 160)">simply each word embedded in a dense vector of size 3</span>, and then they go through the Transformers blocks
- The attention  mechanism in the transformer blocks <span style="color:rgb(192, 0, 0)">cannot reason about the position of the words</span>
- Positional encoding is like saying this is the first word, second word and so on
This is what it looks like irl:
![[positional-encoding2.png]]]
- <span style="color:rgb(192, 0, 0)">It's legit just adding lol</span>
---
## Masking
- We want our model to be able to handle a group of query vectors in parallel ( a matrix)
	- Operating on every word in the input at once and predicting for each the next word
- We can batch the vectors together into a matrix
	- But we need to apply a mask to the <span style="color:rgb(192, 0, 0)">query/key</span> dot product
		- Other wise information from the future words would leak through
		- Without this mask, the model would perfectly guess the next word, because it would be using the key from the word itself as a feature 
![[masking.png]]
- So basically has to guess the next word(target value) then it will move on
---
## Transformers 
![[transformers3.png]]
- The network will output a set of probabilities for each word that we can sample from
	- We make the text generation stochastic, rather than deterministic
- The temperature parameter specifies how deterministic we would like the sampling process to be
- Temperature basically adding randomness 
---
## GPT - Generative Pre-Trained Transformer
- No official paper but from the official blog we know that ChatGPT uses technique called reinforcement learning from human feedback (RLHF) to fine tune the GPT-3.5 model
1. Supervised fine tuning: Prompts written by humans and their desired outputs
2. Reward modeling: Humans rank outputs from best to worst to train a reward model
3. Reinforcement Learning: Policy outputs an action ( a sequence of tokens), which is scored by the reward model trained in step 2
	- A reinforcement learning algorithm know as Proximal Policy Optimization (PPO) can then be trained to maximize the reward by adjusting the weights of the language model
	
[[CS271]]
