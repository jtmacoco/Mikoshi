- Propositional logic assumes the world contains facts
- First order logic ( like natural language) assumes the world contains: 
	- Objects: people, numbers, etc
	- Relations: (between objects, or describing properties)
	- Mappings: from object to object:
		- BestFriend(anna), Instructor(156)
---
## First- Order Logic: Building Blocks
- <span style="color:rgb(0, 176, 80)">Constants:</span> represent objects
- <span style="color:rgb(0, 176, 80)">Predicates:</span> functions that are true or false
	- describe properties
	- represent relations between objects
- <span style="color:rgb(0, 176, 80)">Functions:</span> functions that return non-boolean values
	- represent a mapping between objects
- <span style="color:rgb(0, 176, 80)">Variables:</span> stand for objects that are not explicitly named
- <span style="color:rgb(0, 176, 80)">Connectives:</span> (same as in propositional logic)
- <span style="color:rgb(0, 176, 80)">Equality(Not in propositional logic):</span> refer to the same object
- <span style="color:rgb(0, 176, 80)">Quantifiers:</span> introduce variables
	- Universial 
-  All fish swim:
- $\forall x Fish(x) \implies Swims(x)$  swims is a predicate
---
## First-Order Logic: Syntax
- Term: (represents an object)
	- Constant: 4, zoe, cs152
	- variable: x, y, student
	- function $(term_1,...,term_n)$: BestFriend(zoe), instructor(cs152)
- Arguments to predicates and functions can only be terms
- Arguments to predicates and functions can be terms
---
## First-Order Logic: Syntax
- Atomic Sentence:
	- Predicate $(term_1,...,term_n)$
		- Adjacent([1,1],[1,2])
		- Dating(Ryan, BestFriend(Anna))
	- term1 = term2 <span style="color:rgb(192, 0, 0)">so can also be an equality</span>
		- This is an atomic
--- 
- Complex sentence:
	- Made from atomic sentence$es using connectives
	- $Adjacent([1,1,],[1,2])\wedge Breezy([1,2])$ this would be an example of a complex sentences
---
## Truth in FOL
- Sentences are true with respect to a model and an interpretation 
- $\forall <variables><sentence>$
- $\forall x P$ is true in a model m if and only if:
- P is true with the x being each possible object in the model
- EX: Everyone  @ SJSU is smart
	- Try later
- $\forall$ basically means that for every object within our world are something like in the prev ex smart
- Typically $\implies$ is the main connective with $\forall$
- Common mistake: using $\wedge$ as the main connective with $\forall$
- $\exists <variables> < sentences>$  
- $\exists x P$ is true in a model m if and only if:
	- P is true with x being some possible object in the model
- EX: someone at SJSU is tall
	- Try later
--- 
## Existential Quantification 

- Typically $\wedge$  is the main connective with $\exists$
---
## Properties of quantifiers
- Not everyone likes chocolate
	- $\neg \forall x likes(x,Chocolate)$
- There is someone who does not like chocolate
	- $\exists x \neg Likes(x, chocolate)$
- When not is in front of quantifier
---
## Inference in FOL
- Given:
	-  $\forall x (Fish(x) \implies swims(x)$
---
## Substitution
- A substitution is a mapping from variables to constants or other variables
- Properties of a substitution:
	- Each variable is associated with at most one expression
	- No variable with an associated expression occurs in within any associated expression( that is no 'left side' appears on a a 'right side')
---
## Instantiation
- An instantiation is a substitution of a variable with a constant
	- If true for everything it's true for that particular constant
---
## Universal Instantiation
- Every instantiation of a universally quantified sentences
- MISSED
- The new KB is logically equivalent to the old 
---
## Skolemization
- Skolemization is a more general form of existential instantiation
- Each existential variable is replaced by a Skolem function of the enclosing universally quantified variables(S)
---
## Unification
- Unification is the process of determining whether two expressions can be made identical by appropriate substitution for their variables 


[[CS156]]