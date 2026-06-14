## Planning
- search based planning agents:
	- Planning is central part of AI
	- Search based planning agents
	- atomic representation of a state
- Classical planning
	- work in deterministic, static and fully observable environments
	- combine logic and search
---
## The Frame Problem
- Do we need to specify the result of an action on all the state variables
- Common sense law of inertia
	- An action can be assumed not to change a variable unless there is evidence to the contrary 
- <span style="color:rgb(0, 176, 80)">PDDL:</span> planning domain definition language, based on strips
---
## PDDL
- PDDL includes:
	- Initial and goal states
	- A set of action schemas in terms of preconditions and effects
---
## PDDL - state representation 
- A state is a represented with a conjunction of FOL literals representing atomic facts (fluents)
- Literals must be ground (No variables):
	- At(x,SFO) is not allowed since <span style="color:rgb(192, 0, 0)">x is a variable</span>
- Literals must be function-free:
	- At(Brother(Anna),SJSU) <span style="color:rgb(192, 0, 0)">is not allowed since Brother is a function</span>
- Names and unique:
- Closed world assumption:
	- whatever is not explicitly stated is assumed to be false
	- No need to describe negative literals in state representation 
---
## PPDL- Action Representation
- Action schema includes
	- Action name followed by a list of variables
	- precondition: conjunction of positive function free literals
	- Effect: Conjunction of positive or negative function-free literals
- <span style="color:rgb(192, 0, 0)"> Each schema represents a set of actions</span>
- <span style="color:rgb(192, 0, 0)">Any variable in the effect of an action schema must appear in the action's preconditions</span>
---
## PDDL and the Fram Problem
- Classical planning deals with problems where most actions leave most things unchanged
- The frame problem is the challenge of representing the effects of an action without explaining represent non-effects
- <span style="color:rgb(192, 0, 0)">Only specify what has changed</span>
---
## PDL - Applicable Actions
- An action $a$ is applicable in state s if a's preconditions are satisfied by s
- When action schema contains variables it may have multiple IDK
---
## PDDL - Goal Representation
- A goal is a conjunction of literals positive or negative that may contain variables
- Variables are treated as existentially quantified
- $Goal(At(x,SFO)\wedge Plane(x))$
---
## PDDL Problem Representation
- A set of action schemas defines a planning domain
---
## Solving Planning Problem
- Solve a planning problem represented in PDDL
- State Space Search
	- Progression Search
	- Regression Search
	- Heuristics 
- Start with the initial state and apply each possible action repeatedly hoping to find a goal state
---
## Regression Search
- Start from goal, and search backward until we reach a state implied by the initial state. note that the goal does not represent a single state, but rather a family of states
	- Unify elements of state with effects to find relevant actions
	- Use preconditions to construct previous state:
---
## Heuristic
- PDDL represents makes it easy to automatically generate heuristics
- Heuristics are exact solution to a relaxed problem





[[CS156]]