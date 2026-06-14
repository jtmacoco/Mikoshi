- LSTM works better than RNN with long sentences
- However if the sentence is longer and longer it still doesn't work 
- We need **attention**
- <span style="color:rgb(192, 0, 0)">Add a real memory in the network</span>
- If talking and want to follow lecture, can rely on memory, or <span style="color:rgb(0, 176, 240)">take notes</span>
	- Store the key words instead of exact words said  
---
### High level understanding
- Imagine writing all the words a professor is saying but also highlight the key words
- So can review very quicky 
---
- Here we see a translation example without attention 
- Each state is connected to the next one and no other
![[attention1.png]]
### Issues
- No parallelization
- Slow even with GPUs
- Not so long memory
	- Even with LSTM, long sentences cannot be translated correctly
- Encoding bottleneck
	- We need to encode a lot of words before being able to translate
	- <span style="color:rgb(192, 0, 0)">They all get compressed in a single hidden layer ( the last one )</span>
	- <span style="color:rgb(192, 0, 0)">Compressing means potentially losing important information</span>
---
![[wt-attention.png]]
- Here we see Attention
	- Now, each state has access to each other state in the sentence
- Long-term dependencies can be accessed as easily as short-term dependencies
- No back-propagation through time (No BPTT)
	- To train such network, it requires just a single passage through the attention modulo
- Attention provides learnable memory access
- So if we need information from the past we can just grab from yellow bar (attention bar)
- <span style="color:rgb(0, 176, 240)">Don't need to memorize the past, can just make a note basically</span>
	- So if I'm studying and forget something look at notes
- Think of the attention bar as a notebook with a limited number of pages
- So eventually there will be a limit to how far the model can remember, but as long as it's written down, the model will be able to process it
	- <span style="color:rgb(0, 176, 240)">There is an issue that if the model goes back a lot it will be more complicated</span>
- If buffer is large enough then can go back a lot
- Chatgpt buffer longer you talk to it the more lost it will get
- Can process this  information in parallel

[[CS271]]