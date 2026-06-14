## Overfitting
- Can't recover from a 0
## Generalization and Overfitting
- Relative frequency parameters will overfit the training data
- <span style="color:rgb(192, 0, 0)">In general, we can't go around giving unseen events zero probability</span>
- As an extreme case, imagine using the entire email as the only feature
	- Would get the training data perfect (deterministic labeling)
	- Wouldn't generalize at all
## Lapace smoothing
- Lapace's estimate:
	- Pretend we saw every outcome once more than we actually did
## Tuning on Validation Data
- Now we have 2 kinds of unknown's
	- Parameters: the probabilities $P(F|Y)$, $P(Y)$
- Learn parameters from the training data
- Tune hyperparameters on different data
- For each value of the hyperpaarameter (k), test on the held out/validation data
- Choose the best value (best accuracy)
- Do a final test on test data
---
## Baselines
- Important first step: get a baseline
	- Help determine how hard the task is
	- Help know what a "good" accuracy is
- Weak baseline: most frequent label classifier
	- Gives all test instances the most common label in the training set
---
## Perceptron: Linear Classifier
- Inputs are feature values (vectors)
- Each feature has a weight
- Sum is the activation
	- If activation is => threshold T => + 1
	- Otherwise, no output(0)
---
## Binary Decision Rule
- In the space of feature vectors
- Examples are points
- A weight vector corresponds to a decision boundary that is a hyperplane

[[CS156]]