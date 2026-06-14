## Knowledge Base
- Knowledge base = set of sentences in a formal language (axioms)
- <span style="color:rgb(192, 0, 0)">Domain Specific Content</span> 
- Inference Engine on top of knowledge base
- Declarative approach to building an agent:
	- Tell it what it needs to know
	- Then it can ask itself what to do: answers should follow the KB
---
## A knowledge Based Agent
- The agent takes a percept as input and returns an action
- It must be able to :
	- Represent states, actions, etc
	- Incorporate new percepts
	- Update internal representations of the world
	- Deduce hidden properties of the world
	- Deduce appropriate actions to take
- Logical agents apply inference to knowledge base
---
## Wumpos  World
- This is example from slides 
- Go over again later
- Not fully observable
- Yes Deterministic 
- Episodic ?
	- No Sequential
- Semi-Dynamic 
- Yes Discrete 
- Single Agent
---
## Logic, Worlds & Models
- A logic: formal language for representing information such that conclusions can be drawn
- Propositional logic: atomic symbols representing information (P, Q, R, S, $\alpha$)
- Models: abstraction of possible world
- Truth of sentence is evaulated with respect to a possible model
	- $x+2\leq y$ is true only for some cases
---
## Entailment
- <span style="color:rgb(0, 176, 80)">Entailment means that one sentence follows from another:</span>
	- I didn't get this equation <span style="color:rgb(192, 0, 0)">Go back</span>
- Knowledge base KB entails sentence $\alpha$ if and only if $\alpha$ is true in all worlds where KB is true
- x+y = 4 entails 4=x+y
x = 0 entails $x*y = 0$
---
## Propositional Logic
- Information is represented by atomic symbols
	- Logical connectives
	- Rules for evaluating truth with respect to a model
	- $\neg S$ 
---
## Logical Equivalence
- Two sentences are logically equivalent only if they are true in the same models
---
## Inference
- <span style="color:rgb(0, 176, 80)">Inference:</span> a procedure to derive sentences from other sentences
- <span style="color:rgb(0, 176, 80)">Soundness:</span>
	- An inference procedure $i$ is sound if all sentences derived from KB by $i$ are also entailed by KB
- <span style="color:rgb(0, 176, 80)">Completeness:</span>
	- $i$ is complete if all sentences entailed by the KB can also be derived from KB by $i$
---
## Validity & Satisfiability
- A valid sentence is a sentence that is true in every possible model
- A satisfiable sentence is a sentence that is true in some model
---
<span style="color:rgb(0, 176, 80)">AND =</span> $\wedge$  
<span style="color:rgb(0, 176, 80)">OR = </span>$\vee$  

---
## Conjunctive Normal Form(CNF)
- A conjunction of one or more causes, where each clauses is a disjunction of noe or more literals
- Conjunction = AND
- disjunction = OR
- a literal = atomic sentence or its negation 
- All conjunctions of literals and all disjunctions are in CNF
	- A
	- $\neg A$
- <span style="color:rgb(192, 0, 0)">No implications in CNF</span>
---
## Inference Rules - Notation
- $\frac{A, B, C, D}{E}$
- Whenever our knowledge base contains the sentenes A, B, C, and D we can inferer E
---
## Resolution Algorithm
- To show that $|=\alpha$ we show $KB\vee \wedge \alpha$ is unsatisfiable
1. Convert $KB\vee \wedge \alpha$ to CNF
2. Apply the resolution repeatedly
3. <span style="color:rgb(192, 0, 0)">MISSED</span>
[[CS156]]