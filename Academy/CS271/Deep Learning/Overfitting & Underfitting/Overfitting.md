- Overfitting indicates that our training has focused on the particular training set so much that it has missed the point
	- Occurs when the gap between the training error and test error is to large
- So typically this occurs and can be seen when the loss on the training set is to good 
	- Basically think of that the loss of the model such as in the image is zero which would be a perfect model
	- <span style="color:rgb(192, 0, 0)">Note that just because have 100% accuracy or 0 loss doesn't necessarily mean you are overfitting can mean that you need to tweak hyperparameters or something else in the model</span> 
- <span style="color:rgb(0, 176, 80)">Bias (in the case of overfitting)</span> Is basically the loss
- <span style="color:rgb(0, 176, 80)">Variance (in the case of overfitting)</span> Change in the prediction accuracy between training data and test data
- So high variance = overfitting 
- High Bias = underfitting

- More data is important but shouldn't be necessary the model should be able to infer the patters/features. So basically we don't need to see all the data to learn the pattern

quote from professor:
"So when you ask this dot, the model can understand because it's complex enough that they are alternating can infer that if can infer that can even tell you that this is black, this is white, just by inferring the pattern that was learned so it doesn't need to see all the data.

This is a special case and it's one of the reasons why deep learning is so much used nowadays because it's so powerful."

## Split the dataset
- Training (to learn the parameters of the mode)
- Validation (to "train" the hyperparameters)
	- This is what helps with overfitting and early stops
- Test (to estimate the generalization error)

## Validation
- The validation loss should be close to the training loss
- So if the train loss begins to get very close to 0 and the validation loss increases (at any point) then we should early stop because the model is overfitting
- Can add patience, so that if the validation loss goes up as long as it still has some patience the model will tolerate.
	- so if had a patience of 2 the the validation loss can go up 2 times before early stopping
## Early Stopping
- Stop when the validation loss starts to increase
- Stop when the training loss becomes very small

![[overfitting.png]] 


[[CS271]]