**Source**:[[CS252]]
**Tags:** #haskell #monads #monad 

>[!important] Mondad
>A way to chain computations that carry extra context

- For `Maybe`, the context is:
	- This computation might fail
- For `IO`, the context is:
	- This computation interacts with the real word 
- For Lists:
	- This computation may produce multiple results
	
- Mondads can chain through a series of functions
``` haskell
Just 3 >>= (\x -> Just (x+4))
	   >>= (\x -> Just(x+5))
```

- Chains the functions together so output of `x+4` where `x = 3` is `Just 7` which is now the input for x in the `x+5` so `x = Just 7`
- Monad automatically handles the `Just` which is why `x = 3`
----
## List Example
```haskell
[1,2,3] >>= (\x -> [x, x*10])
```

## Apply function to each element:

```
1 → [1,10]
2 → [2,20]
3 → [3,30]
```

then output is :
```haskell
[[1,10],[2,20],[3,30]]
```

**Monad automatically flattens so*** we get this 
```haskell
[1,10,2,20,3,30]
```
