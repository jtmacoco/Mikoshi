## Machine Learning

- Up until now: how to use a model to make optimal decisions 
- Machine learning: how to acquire a model from data/experience
	- Learning parameters (e.g. probabilities)
	- Learning structure (BN graphs)
	- Learning hidden concepts (clustering)
---
## Classification 
- Classification: given input x predict a label (class) y
- Spam detection 
	- input: email message, classes: spam/ham
- OCR- optical character recognition 
- input: images, classes: characters
	- Finite number of labels
- Medical diagnosis
- Fraud detection
---
## Spam Filter
- Input: an email
- Output: ham or spam <span style="color:rgb(192, 0, 0)">LIKE 581</span>
- Spelling errors
---
## Model-Based Classification
- Model based approach
- Build a model(bayes' net) where the label y and feature $F_1$ through $F_n$ are random variables
- Instantiate any observed features
- Query for the distribution of the label conditioned on the observed features: P(Y|n)
---
## Naive Bayes for Digits
- Simple digit recognition:
	- One feature(variable) $F_{ij}$ for each grid position <i,j>/pixel
- Data is represented as a feature vector
---
## General Naive Bayes
1. Inference method (last lecture or lecture before )
	- Start with a bunch of probabilities
2. Estimates a local conditional probability tables
	- P(Y), the prior over labels (P(spam, P(ham)))
	- $P(F_i|Y)$

[[CS156]]