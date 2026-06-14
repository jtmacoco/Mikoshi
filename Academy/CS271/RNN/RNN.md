- Autoregressive models generate new data based on previous values in the sequence
	- Rather than on a latent random variable
- These models attempt to explicitly model the original data distribution instead of approximation of it
- <span style="color:rgb(192, 0, 0)">We need to work with sequential data</span>
- Concept of sates is needed
![[rnn_state.png]]
- So based on this picture of the ball we can tell what direction the ball is going based on the previous states or positions 

- So the input takes the previous output basically
- So we basically have this kind of loop where the output is appended the input
![[rnn.png]]
- <span style="color:rgb(192, 0, 0)">So in this image there are 3 inputs then the output is 2 so we would basically just concat this output the the input leaving us in the next loop with an input size of 5</span>
- This kind of feedback loop is similar to have multiple neural nets for different time sequences
	- Think I have one neural net for time step 1 then another for time step 2
	- An RNN is **one neural net** applied repeatedly across time steps, like a loop over time, **sharing weights**. It’s not creating multiple networks, just **unrolling** the same one.
- <span style="color:rgb(192, 0, 0)">Activation function is typically TANH but can use Relu</span>
- Model now has some information from the past since the previous word has been processed and generated an output
- This output goes in input again, so the model now has an information from the past state and then uses the current input plus the state plus the past output to generate the new output 
- So what is more recent will be clearer better memorized 

## Back-propagation Through Time (BPTT)
- It's called back propagation through time because we loop, so if i have three inputs I need to loop back  propagation back three times(maybe double check this)
- So RNNs don't use a typical back propagation
- The back propagation is not only "from output to input", but also through time
	- looping back the sequence
- Formula:
	- $h_t = f(W^T_hh_{t-1}+W^T_xX_t)$ <span style="color:rgb(192, 0, 0)">h is the same as w for weights basically</span>
	- $y_t = softmax(W^T_Of(W^T_hh_{t-1}+W^T_xX_t)$
- So this suffers from the vanishing gradient problem
	- The reason being that when looping back notice that $y_t$ is constantly taking the $h_{t-1}$ every back propagation so the larger the input the larger this back propagation is going to be. 
- Another way to see this is if we have an input size of 3 with 2 hidden layers and size 2 of output nodes then it's like looping through the hidden layer 6 times since $3*6$
- Lecture mentions typically one word one input
---
## Vanishing Gradient Examples
- I spent some time  in Columbia, and even though I was born in England, I now speak fluent ...
	- Too many words/ inputs; the gradient vanished and the information about the long-term inputs are gone
	- This happens since Columbia is to far back in the sentence, and England is closer, so will likely put English rather than Spanish  
--- 
## Tokenization
- The first step is to clean up and tokenize the text
- Tokenization is the process of splitting text into individual units (words or characters)
[[CS271]]