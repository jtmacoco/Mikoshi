Helps solve the vanishing gradient problem
Stands for Long Short Term Memory
- So some things we want to keep long term while others keep short term 
![[lstm.png]]
So the above image shows a plain LSTM network
- Notice output is tanh
- In red are operators so multiplication, addition, tanh, etc.

LSTM can do 4 things:
1. Forget
2. Store
3. Update
4. Output
![[lstm2.png]]
--- 
## Store
![[store.png]]
- Store will output 0 or 1 depending on if it thinks it should store a word
- Forget will not forget words but will forget memory 
	- The memory is the top part so $c_{t-1}$
- This network will basically reason if we need to store this word or not  
- If we store then will output one so that the processed word is multiplied by one and then add it to the memory
- Will output 0 if the word is useless 
--- 
## Forget
![[forget.png]]
- So given this input and the previous output, this model will think do I need to forget everything
- Like resting the memory or not
- If Yes want to forget the multiply times 0 and this signal the memory is gone
- You forget everything
--- 
### LSTM 
- Need to have a good data set
- <span style="color:rgb(192, 0, 0)">So how this works is that the model will basically start to randomly store and forget stuff, but the loss will be very high because it's not able to guess the next words</span>
- Then by back propagating gradient descent, we'll find the right combination of weights so that when you input time, this network will know to  output zero 
	- This is very hard coded to the sentences in input
- If a sentence is long enough then I will still loop a lot of times and eventually the model will get confused
- A partial solution, not solve the problem completely 
---
### Update
![[update.png]]
- Basically re organize the memory keeping it or not, adding something or not then get it ready for the next iteration 	
--- 
## Output
![[output.png]]
-  Can't output right away need to know stuff like gender, singular or plural, etc.
- Can decide to output a 0 so the memory signal will be zero 
- Basically not outputting anything, next iteration will be a zero since the previous step isn't  relevant 
- Output is not a neural network, the color is different
- So basically we filter the input here in between -1 and 1
- Using the tanh helps with with memory management and exploding/vanishing gradients 
![[io-outputs.png]]
- loses track when sentences become long will make sense grammatically but not semantically 
[[CS271]]
