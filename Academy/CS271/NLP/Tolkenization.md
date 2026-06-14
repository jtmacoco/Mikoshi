## Word Tokens
- All text is usually converted to lowercase to treated all words in the same way
	- But some proper nouns(names or places) better capitalized(tokenized independently)
- The <span style="color:rgb(192, 0, 0)">text vocabulary may be very large,</span><span style="color:rgb(192, 0, 0)"> with some words appearing very sparsely</span>
	- Replace sparse words with a token for unknown word, to reduce the number of weights
- Words can be stemmed so that different tenses of a verb are tokenized together
	- For example, browse, browsing, browses, and browsed would all be stemmed to brows
- Using word tokenization means <span style="color:rgb(192, 0, 0)">the model will never be able to predict words outside of training</span> 

## Character Tokens
- The model may generate new words outside of the training vocabulary sometimes desirable but not always
- Capital letters can either be lowercase or remain as separate tokens
- The vocabulary is usually much smaller when using character tokenization faster to train there are fewer weights
- This is like grams or n-grams
- This is what's used in ChatGPT
	- Since there are combinations of characters that won't appear in a language

## N-Gram
- n-gram = a sequence of n items usually words taken from text
- EX:
	- **Character unigrams (1-grams)**: `["t", "h", "e"]` for the word "the"
	- **Character bigrams (2-grams)**: `["th", "he"]`
	- **Character trigrams (3-grams)**: `["the"]`


[[CS271]]
	