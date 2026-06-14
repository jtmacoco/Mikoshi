## Bayes Nets: Big Picture
2 problems with using full joint distribution tables to represent our probabilistic models
1. Unless there are few variables, the joining distribution is to big
2. Hard to learn (estimate) joint probabilities empirically when more than a few variables are involved
- Bayes nets: technique for describing complex joining distributions compactly using simple, local conditional distributions 
- Arcs: interactions:
	- Similar to CSP constraints
	- Indicate "direct influence" between variables
	- Formally: encode conditional independence
---
## Ex: Coin Flips
- N independent coin flips
	- each coin flip represented by a random variable $x_i$
---
## Bayes Net Semantics
- A set of nodes one node per random variable
- Nodes are connected in a directed, acyclic(no cycles) graph
	- A collection of distributions over X, one for each combination of parents' values
- $P(X|a_1...a_n)$
---
## Probabilities in BNs
- Bayes' nets implicitly encode joint distributions as a product of local conditional distributions
- To see what probability of BN gives to a full assignment, multiply all the relevant conditionals together
---
## Size of Bayes' Net
- How big is a joint distribution over N boolean variables
- How big is a N-node net if nodes have up to ke parents
- $O(N*2^{k+1})$ 
- Both gives us the power of calculated
- Bayes Nets: Huge space sacings
- <span style="color:rgb(192, 0, 0)">Easier to elicit local CPTs</span>
- Faster to answer queries
---
## Bayes Nets: Assumptions
---
## Causal Chains
- Cause Effect
	- <span style="color:rgb(192, 0, 0)">Observing the cause blocks the influence/dependenc between effects</span>
---
## Common Effect
- <span style="color:rgb(192, 0, 0)">Observing effect activates influence between possible causes</span>
---
## General case
General question: in a given BN, are 2 variables independent (given evidence
Solution: break down the graph into segments
Any complex example can be broken into repettition of three 
Observation is like blocking flow of river with rock
<span style="color:rgb(192, 0, 0)">Question about ACTIVE/INACTIVE slides</span>
- All it takes to block a path is a single inactive segment
---
## General Case
- <span style="color:rgb(192, 0, 0)">One active path means no independence</span> 
---
## Inference by Enumeration in Bayes' Net
- Inference by enumeration is the basic exact inference method for Bays' net
---

[[CS156]]