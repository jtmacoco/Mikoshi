**Tags:** #haskell #functors
```haskell title=getmax
getMax :: [Int] -> Maybe Int
getMax [] = Nothing
getMax (x:xs) = case getMax xs of
	Nothing -> Just x
	Just maxTail -> if x > maxTail then
		 Just x
		 else 
		 Just maxTail
	
```

```haskell title=rectangleArea
rectangleArea :: Int -> Int Either String Int
rectangleArea h _ | w <= 0 Left "width is not positive"
rectangleArea _ w | h <= 0 = Left "Height is not positive"
rectangle w h = Right $ w * h

```
- Idea is boxing up result as we go

---

```haskell  title=foo
foo [] = []
foo (x:xs) = x+1: foo xs
```

```haskell title=bar
bar (Just n) = Nust $ n+1
bar Nothing = Nothing
```

--- 

>[!important] Functors
>- Something that can be mapped over
>- Map of this kind of box

- **Monads are specialized type of functor used as a way in Haskell of compartmentalizing side effects**

>[!danger] No Side Effects Means
> The function does not change anything outside itself and only returns a value based on its inputs

```haskell {3}
main = do
printStrl "who goes there?"
name <- getLine
putStrLn $ "Welcome , " ++ name
```

- The `<-` is like extracting things from the box
- `return` in haskell is like boxing things up the **opposite of `<-`**

- <span style="color:rgb(192, 0, 0)">Mondad is a functor</span> 
---
# Functor Law 1

> If we map the `id` function over a functor, the functor that we get back should be the same as the original functor

# Functor Law 2
> Composing two functions and then mapping the resulting function over a functor should be the same as first mapping one function over the functor and then mapping the other one

basically: `fmap (f . g) = fmap f . fmap g`

# Maybe as a functor

```haskell title=maybe
instance Functor Maybe where
 fmap f (Just x) = Just (f x)
 fmap f Nothing = Nothing
```
