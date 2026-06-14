## Invariant Metrics
- Better similarity functions use domain knowledge
- Computer Vision Example Invariant metrics
	- Similar are invariant under certain transformations
	- Rotations, scaling, translation, stroke thickness
	- Be careful
---
## A tale of 2 approaches
- Nearest neighbor like approaches
	- Can use fancy similarity functions
	- Don't actually get to do explicit learning
- Perceptron like approaches
	- Explicit training to reduce error
	- Usually linear classification
	- Faster classification
---
## Formalizing Learning
- Inductive learning(discover learning) is a process where the learner discovers rules yb observing examples
- These rules are represented a function $f$, unknown to us
	- Training examples come in pairs: $(x,f(x))$
- Goal:
	- Given a training data set, discover the best hypothesis $h$ that approximates the true function $f$ best
- Includes:
	- Classification: $f(x)$ is the finite set of values
	- Regression: $f(x)$  can be any number
---
## Inductive Learning
- Construct/ adjust h to agree with f on training  set
- $h$ is consistent if it agrees with $f$ on all examples
- curve fitting (regression)
- Consistency vs simplicity
---
## Consistency vs Simplicity
- "simpler" solutions generalize better avoid overfitting
- Several ways to simplify:
	- reduce the hypothesis space
- Have fewer features
- Regularization
- Smoothing
---
## READ GRADING RUBRIK FOR HW 7
---
## Recap: Classification
- Supervised Learning
- We've seen several methods for this
- Make prediction given evidence
---
## Clustering
- Unsupervised learning
- Detect patterns in unlabeled data
	- Group emails, search results, images
	- find categories of customers
	- detect anomalous/malicious program executions
- Useful when we don't know what we are looking at
- Requires data, but no labels
- Often get gibberish
---
## K-Means
- Pick K random points as a cluster centers(means)
- Repeate:
	- Assign data instances to closet mean
	- Assign each mean to the average of its assigned points
---
## Phase 1: Update assignments
- For each point, assign to closes mean:
## Phase 2: Update Menas
- Move each mean to the average of its assigned points:
---
## Initialization
- K-means is non-deterministic 
- Requires initial means
- It does matter what you pick
---
## K- Means questions
- Will k means converge
	- To a global optimum?
	- It will usually converge but not always to what we want
- Will it always find teh true patters in the data?
	- No it won't
	- If patters are very clear it is more likely to find them but no guarantee 
- Do people ever use it

[[CS156]]