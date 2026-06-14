
- Rationality depends on the performance measure so the reward function 
- Depends on what the agent knows about the environment <span style="color:rgb(0, 176, 240)">state space</span>
- Be aware of what actions the agent can take so <span style="color:rgb(0, 176, 240)">action space</span>
- <span style="color:rgb(192, 0, 0)">A rational agent is an agent that maximizes the expected value of the performance measure </span>
---
## Rationality - Limits
- Rational agent can not look into the future
- Only knows what it's current percepts are
- Rationality does not guarantee success 
- EX:
	- Say about to cross major street and being a rational agent look to right, left and don't see any cars coming, so start crossing
	- But an airplane flies over and a suitcase drops and flattens you
	- So you weren't irrational because you didn't cross while looking up, since looking up isn't what you would typically do 
- <span style="color:rgb(192, 0, 0)"> SO rationality is doing the right thing given the circumstances </span>
- Difficulty: Computational limitations may make perfect rationality unachievable 
- Know the steps but the computation is to costly
- Given resources design best program
---
##  Rationality
- Rationality involves:
	 - Exploration
	 - Learning
	 - Autonomy 
--- 
## Task Environment 
- TO design a rational agent, we must specify the task environment
	- Performance measure
	- Environment 
	- Actuators 
---
## Task Environment - PEAS
> Self- driving taxi
- Performance measure
	- Safety 
	- Profits
	- Speed
	- Arriving on time 
	- Comfort of car
	- legality 
- So going over decision making based on performance measure (which is like reward system form RL)
- Environment:
	- City
	- Highway
	- Streets
	- Pedestrians
	- Other Cars
- Actuators
	-  Wheels
	- Brakes
	- Acceleration 
	- Horn
- Sensors
	- Cameras
	- Lidar
	- Radar
	- GPS
	- Microphone
	- Touch screen
	- GPS
---
## Agent to do online shopping
> Internet shopping agent
- Performance
	- Accuracy
	- Speed
	- Quality
	- Appropriateness
- Environment
	- Internet
	- Website
	- Vendors
- Actuators:
	- Display to usr
	- follow URL
	- fill in form
- Sensor:
	- Keyboard microphone
---
## Robot Agent
> Part picking robot
- Performance measure
	- Accuracy
- Environment
	- Factor
	- Conveyor belt with parts
- Actuators:
	- Hand
	- Joint
- Sensors:
	- Camera
--- 
## Environment properties
- Fully observable vs Partially Observable
	- Fully observable: the agent can see everything
		- Agent sensors give it access to the complete (relevant )state of the environment at each point in time
- When the environment is partially observable, the agent needs to keep track of what it has seen of the environment so far
- Deterministic vs Non-deterministic (stochastic)
- Deterministic: the next state of the environment is completely determined by the current state and the action executed by the agent 

- Chess: Deterministic 
- Automated taxi: Stochastic 
- Real world: Stochastic 

- Deterministic is like epsilon greedy basically 
- <span style="color:rgb(192, 0, 0)">Episodic vs Sequential</span> (look this over before next class)
	- Episodic: The agent's experience is divide into atomic episodes
- Sequential means what ever you do know will have an effect in the future
- Static vs Dynamic
	- Static:
		- environment doesn't change
	- Dynamic the environment changes
	- Semi-dynamic: the environment it self does not change with the passage of time but the agent's performance score does 
	
	- Chess: Static
	- <span style="color:rgb(192, 0, 0)">Chess with a clock is semi dynamic</span>
	- Automated taxi: Dynamic
	- Real world: Dynamic 
	
- Discreet vs Continuous
	- Discrete: a finite number of distinct, clearly defined percepts and actions 
	- Chess: Discreet 
	- Automated taxi: Continuous 
	- Real world:  Continuous
	
- Single Agent vs Multi-agent
	- Single agent: an agent operating by itself in the environment 
	- Multi-agent environments may be competitive or cooperative 
	
	- Chess: Multi
	- Automated taxi: Multi, Both competitive and cooperative 
	- Part picking robot: Single 
	- Real world: Multi
---
## Agent Types
- Simple Reflex agents
- Model based agents
	- Reflex agents
	- <span style="color:rgb(192, 0, 0)">Missed this </span>
---
## Simple Reflex Agents
- Choose action based on current percept
- Do not consider the future consequences of their actions
- consider how the world is
---
## Model Based Agents
- Model based agents must have a model of how the world evolves
---
## Reflex Agent with State
- Choose action based on current percept and memory
--- 
## Goal Based Agent
- Ask "what if"
- Decisions based on (hypothesized) consequences of actions
- Must have a model of how the world evolves in response to actions
- Must formulate a goal (test)
- Consider how the world would be
 ---
## Utility Based Agent
- Maximize  the expected utility 
- Consider how the world would be
- Measure of happiness
---
## Representing the world
- Atomic representation: each state of the world is indivisible (black box)
	- Tabular learning I think
- Factored representation: states are divided into variables and each variable has a value
- structured representation : Objects and relationships and described explicitly 

[[CS156]]


