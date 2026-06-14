## The Bellman Expectation Equation
- $v_pi(s)\stackrel{\cdot}{=}\sum_a\pi(a|s)\sum_{s',r}p(s',r|s,a)[r+\gamma v_\pi(s')]$
- This is basically averaging over all the possibilities, weighting each by its probability of occurring
- States that the value of the start state must equal the (discounted) value of the expected next state, plus the reward expected along the way 
	- <span style="color:rgb(192, 0, 0)">"The value of being here at this state now = reward now + value of the likely future (discounted)"</span>
	- What I expect to get in total  = what I get now + what I'll get later (discounted) basically
- Forms the basic number of ways to compute, approximate, and learn the value function
- Averages over all the possibilities weighting each by its probability of occurring from a state-action pair
- This helps because instead of simulating an entire episode to figure out the value of a state(which could take forever), the Bellman Expectation Equation lets us build up the value of a state step by step, using known information about rewards and transitions
## Intuition:

Imagine you're trying to figure out how good it is to be in a room (state).  
You know:
- The **reward** for being there now.
- The **chances** of going to other rooms based on your actions (the transition probabilities).
- And the **value of those other rooms**.
- The **Bellman Expectation Equation** lets you say:
	 - The value of this room = the reward here + the average of the values of the rooms I might go to next.


[[CS272]]