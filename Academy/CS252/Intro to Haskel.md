**Tags:** #haskell 
# Recursion 
- Add more base cases until recursive step seems obvious then go back and remove un-needed base cases
----
# Going over lab

## Max Num

```haskell title=maxNum
maxNum :: [Integer] -> Integer
maxNum [] = error "empty list"
maxNum[x] = x
maxNum(x:xs) = if x > largest then x else largest
where largest = maxNum xs
```

- `x:xs` is similar to the concept of i++ or like iterating through a list
---
# FizzBuzz

```haskell title=fizzbuzz
fizzbuzz n
| n == 0 = ""
| n == 1 = "1"
| n < 0  = error ""
| (n `mod` 3) == 0 && (n `mod` 5) == 0 = fizzbuzz ($n-1) ++ "fizzbuzz"
| (n `mod` 3) == 0 = fuzzbuzz($n-1) ++ "fizz"
| (n `mod` 5) == 0 = fuzzbuzz($n-1) ++ "buzz"
```
----
# jsonToString

```haskell title=jsonToString
toString (JObject o) = "{" ++ keys2str o ++ "}"

keys2str::[(string,Jvalue)] -> String
key2str [] = ""
key2str ((k,jv):[]) = k ++ ":" ++ toString jv
key2str ((k,jv):xs) = k ++ ":" ++ tostring jv ++ "," ++ key2str xs
```

- `$` can be used to substitute the `()`

---
# Key Haskell  

 >[!important] Key traits of Haskell
> 1. Purely functional
> 2. Lazy
> 3. Statically typed
> 4. Type inference
> 5. Fully curried functions

- Haskell doesn't usually calculate the results until they are needed this is because Haskell is  **Lazy evaluation**
---
# Base Types
- **Int:** Bounded Integers
- **Integer:** Unbounded Integers 
- Float
- Double
- Bool
- Char
---
# Lists
- ++ Concatenation
- :  Prepend an item
- !! Get an element at the given index
- head first item
- tail rest of list
- last last item
- init the beginning part of the list
---
# Type Signature

`inc :: Int -> Int`
the `::` means it has a type signature

---
# Can't reassign vars in Haskell
**If you say that a is 5, you can't say it's something else later because you just said it was 5**

---
# Types and Type-classes

