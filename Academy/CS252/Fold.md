**Tags:** #haskell #fold

```haskell title=sumlist
sumList :: [Integer] -> Integer
sumList [] = 0 //basecase
sumList (x:xs) = x + sumList xs
```

```haskell title=prodList
prodOfList :: [Integer] -> Integer
prodOfList [] = 1 //basecase
prodOfList (x:xs) = x * prodOfList xs
```

```haskell title=combineStrings
combineStrings :: [String] -> String
combineStrings [] = "" //bascase
combineStrings (x:xs) = x ++ " " ++ combineStrings xs
```

- Notice how there is a repetition but but the base case is different for each function also what is being done is different like addition or `++` or `*`

```haskell title=reduce
reduce :: (a -> b -> a) -> b -> [a] -> b
reduce f b [] = b
reduce f b (x:xs) =  f x reduce f b xs
```


