Word Embeddings make words into vectors so to be understandable by machines
Ex:
- One hot vectors
- So one hot encoding basically 
"Milo is a cat" 
"A cat eats fish"
"Milo eats fish"

| Word | One-Hot Vector     |
| ---- | ------------------ |
| milo | [0, 0, 0, 0, 0, 1] |
| is   | [0, 0, 0, 0, 1, 0] |
| a    | [1, 0, 0, 0, 0, 0] |
| cat  | [0, 1, 0, 0, 0, 0] |
| eats | [0, 0, 1, 0, 0, 0] |
| fish | [0, 0, 0, 1, 0, 0] |
So the above table is an example of one hot encoding 
Good since no mathematical relations among the words, so no mathematical relations among the words. 
But if you add

"A fish eats cat"

the one hot vector encoding won't know the difference between the sentences, since there isn't any context. So the order of the words isn't take into consideration. 

- So we want to try and have words that are similar be closer together in the word embedding or latent space basically
- We want to cluster together synonyms
- So using vectors and multiple dimensions is a solid start similar to VAEs
- But this requires a lot of weights 
- This is know as <span style="color:rgb(0, 176, 80)">Word2Vec</span>


[[CS271]]