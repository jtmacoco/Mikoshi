```haskell title=non-higher-order
addOneToEach:: [Int] -> [Int]
addOneToEach [] = []
addOneToEach (x:xs) = x+1: addOneToEach(xs)

squareEach:: [Integer] -> [Integer]
squareEach [] = []
squareEach (x:xs) = x*x : squareEach xs

stringifyEach :: [Integer] -> [String]
stringifyEach [] = []
stringifyEach (x:xs) = show x : stringifyEach xs
```

```haskell title=higher-order
applyToEach:: (a->b) -> [a] -> [b]
applyToEach f [] = []
applyToEach f (x:xs) = f(x) : applyToEach f xs
```

- See how the higher order removes the duplication from the non-higher-order
- lol **applyToEach is just the map functon in haskell**

```haskell title=filter-non-higher-order
removeNegs :: [Int] -> [Int]
removeNegs [] = []
removeNegs (x:xs) = if x < 0 then removeNegs xs else x: removeNegs xs

```

```haskell title=filter-higher-order
removeBad :: (a -> Bool) -> [a] -> [a]
removeBad f [] = []
removeBad f (x:xs) = if pred x then 
						removeBad pred xs 
					else 
						x:removeBad pred xs
```

>[!important] points free style
>- Points free : no function argument
>- ex: `incByTwo = inc . inc`
>-  equivalent to $f (g(x))$
>- so input of f get's passed to g and then output of g gets passed to f

- **General rule Iterative solutions tend to be more efficient than recursive solutions**
- But compiles are very good at optimizing a tail recursive function

>[!important] tail recursion
> - When the recursive call is the last step performed before returning a value
> - Use accumulator pattern
> - Collect answer as you go

# Qualities of Functional Programing
1. Functions clearly distinguish
	- Incoming values (parameters)
	- Outgoing values (results)
2. No assignment
3. No loops
4. Return value depends only on params
5. Functions are first class values
- **No reassignment in Haskell**

>[!important] Higher order function
> A function that either takes a function as a parameter or returns a function as its result

# Currying 
- Transform a function with multiple arguments into multiple functions 


