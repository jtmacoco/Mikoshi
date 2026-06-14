- First models were based on Feed forward architecture, recurrent neural networks, but they had to high training complexity
- Word2Vec introduces simplicity and is very fast by reducing the number of hidden layers
- <span style="color:rgb(0, 176, 80)">A word embedding is a way of mapping words to vectors</span>
	- <span style="color:rgb(0, 176, 80)">Word2Vec:</span>
		- Unsupervised method based on corpus statistics
		- Built-in embedding layers: tensorflow/keras support "embedding layers"
- Using Word2Vec allowed for math arithmetic to be applied 
- So Related words should be "close" in a Euclidean sense, unrelated words should be far away
- EX:
	- king - man + woman = queen
	- Paris - France + Italy = Rome
- How large should the vector be?
- What if we have say 50 elements in the vector for each word with values, say -1.6 and 1.6
- This is a dense vector<span style="color:rgb(0, 176, 80)">( A fixed length numerical representation of a word or concept where most or all elements are non zero)</span>
- In this way, the vector defines points in space
- If well done, the closer points will correspond to closer meaning

![[word2vec.png]]

So this image is an example of using multiple dimensions 
But how does training work
- So we want to try and guess the next word in the sentence based on the previous word, the size can be adjusted like a window

- So the idea is that we have a word in input now what is the probability of every word in the vocabular dictionary, however big we want it, what is the next word going to be
![[word2vecex.png]]
So the image shows kind of how this work and notice how it only uses 1 hidden layer so it's super fast compared to before and very easy to implement. 

- Here is mathematically why this works so well
- Here is a very simple example of how this kind of works
	- So say we have an output like a target value of 10
	- The the operands come from some matrices and lets say it's 5
	- Then we want to add something that's close to 5 or 5 say 5.1
	- The output of this would be 10.1 which is close to 10 so it will be closer in the word embedding
	- Then say we input another word that's value comes out to 8
	- Now 8+5 = 13 which isn't as close to 10 so it will be a bit farther in the word embedding
	- $?+5=10$ so you can se this works well since it really depends on the input number value 
	- So basically the input which is a question mark is forced to be closer to a number that will get the target output

- You shall know a word by the company it keeps
- Two versions of wrod2Vec(both containing only one hidden layer)
- <span style="color:rgb(0, 176, 80)">Continuous Bag-of-words(CBOW)</span>
	- Predicts the central word based on a window of words surrounding it
	- $J=-log\hat{P}(w_t|w_{t-n+1}...w_{t-1})$
	- Only predict the next word in the sentence 
- <span style="color:rgb(0, 176, 80)">Skip Gram(SG)</span>
	- Predicts the context (surrounding words) based on the central words (opposite of CBOW)
	- $J=-\frac{1}{T}\sum^T_{t=1}\sum_{-n\leq j \leq n}logP(w_{t+j}|w_t)$
	- So basically given one word try to predict the words before and after

[[CS271]]