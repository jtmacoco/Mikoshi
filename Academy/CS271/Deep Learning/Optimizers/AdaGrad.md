- Basically adjust the learning rate based on the gradient since if the gradient is large then farther away from the minimum 
- Formula:
	$\triangle w_i(t)=- \frac{\eta}{sqrt(G_i(t))+\epsilon}*\frac{\delta L}{\delta w}(t)$
- where I indicates the update rule is for individual for each weight	
- $G_i(t)= G_i(t-1)+(\frac{\delta L}{\delta w_i}(t))^2$
- the beginning point of $G_i(0)=0$
- note that gt function is monotonous increasing
- So the learning rate is directly influenced by the loss itself
- with ada grad every single weight as a personalized learning rate
- <span style="color:rgb(192, 0, 0)">THIS DOESN'T USE THE PAST SO NO MOMENTUM</span>
- Gt is always adding something to itself
## Issue
- The loss at the beginning is large
- So we divide $\eta$ by a very larger number which in turn makes the learning rate very small so this is still to slow
[[CS271]]