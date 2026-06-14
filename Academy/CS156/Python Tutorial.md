## Min and Max 
- <span style="color:rgb(192, 0, 0)">Don't use min max or sum a variable names</span> 
- Use built in functions
- Min has default parameter `min(examps,default=-100)`
---
## Min and Max  with a Key
- `deviation = [4,-1,5,2,12,-6,18,-20]`
- Min of deviation is -20
- Max of deviation is 18
- How to find the deviation with the largest absolute value
- To get largest abs of deviation 
	- use abs function
- `max(deviation,key=abs)`
	- Output is -20
- <span style="color:rgb(0, 176, 240)">Higher order functions are functions that take in other functions as arguments</span> 
---
## Operations with Dictionaries
- Any operation on the dictionary (min, max, sum, sorting, iteration, membership check) is performed on the keys
---
## Anonymous Functions
- Lambda expressions provide a concise way to define functions without giving them a name
- They are used to create and use functions on the fly
- Lambda expressions are usually passed as arguments to other functions
---
## Min Max with a key lambda
`points = {(2,2),(0,3),(1,4)}`
- `key = lambda p:p[1]`
- then can call max `max(points,key=key)`
- then max will compute maximum of the y coordinate only
- <span style="color:rgb(192, 0, 0)">The returned output will be a tuple so (1,4)</span> 
---
## Lambda with Dictionary Values
- so also need to take a key if want to specify value else will default the to the key's of the dict
---
## List Comprehension
- `deviation = [4,-1,5,2,12,-6,18,-20]`
- How do I find the absolute values of all the elements in the list?
- abs_dev [abs(d) for d in deviations]
	- creates the list basically
---
## Generator Expressions
- Suppose that we are only interested in the sum of theses squares 
- `total = sum([x**2 for x in range(1000)])`
- Better way to conserve memory is to store the whole list in memory
- `total = sum(x**2 for x in range(1000))`
- So remove the the square brackets to be memory efficient
- Can add if condition 
- `(abs(d) for d in deviations if d >= -10)`
## Classes and Objects
- Although you don't have to write class defs in the programming projects, you will need to create Objects and invoke methods defined on these projects
- Just like some functions may have default values for their arguments, some classes may have some default values. Theses values don't have to be specified when instantiating an object
## <span style="color:rgb(192, 0, 0)">Code defined in other Notebooks</span>
- option 1:
	- Execute the other notebook(in the current namespace)
	- `%run spartanquest.ipynb`
	- All functions/classes become accessible in the current notebook
- option 2:
- import definitions from the other notebook into the current one (need to install import-ipynb first- this is done for you)
- from data_structures import *
- All functions/classes become accessible in the current notebook*
[[CS156]]