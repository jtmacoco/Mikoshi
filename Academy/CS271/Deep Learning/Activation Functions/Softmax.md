
- This is typically only used in the last layer of the model
- The reason for this is that it helps the model learn faster by making good values(where loss is low) better and values where loss is hight(worse values) even worse. 
	- This works since we really only care about the predicted value is better and helps the model learn/converge faster by putting more of an emphasis on these points.
- Softmax activation transforms a bunch of arbitrarily large or small numbers into a valid probability distribution
- The values that softmax outputs are in the range from 0 to 1 and their sum is exactly 1(like probabilities)
-<span style="color:rgb(192, 0, 0)"> ONLY USE IN OUTPUT LAYER</span>
- The reason is because if we use softmax in the hidden layers then a lot of the information about the variability of the data is lost
![[softmax.png]]
[[CS271]]