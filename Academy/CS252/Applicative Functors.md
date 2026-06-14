**Tags:** #haskell #applicative-functors


```haskell
instance Functor Tree where
fmap f Empty = Empty
```

- **Pure:** Boxes up an item
- `<*>`: 
	- Infix operator similar to fmap
	- The function itself is in a functor
	- Apply the function inside the box to the value inside the box
	
>[!important] Monoids
> An associative binary function & a value that acts as an identity with respect to that function

# Functors Conceptually
- value in box  →  apply function  →  new value in box

```
+-----+        +-----+
|  a  |  --f--> |  b  |
+-----+        +-----+

   fmap f

+-----+        +-----+
| F a | -----> | F b |
+-----+        +-----+
```

## Example

`(+1) <$> Just 3`

```
+--------+
| Just 3 |
+--------+

apply +1

+--------+
| Just 4 |
+--------+
```
---
# Applicative Functors Conceptually 
- function in box `<*>` value in box
```
+-----------+     +---------+
| F (a->b)  | <*> |   F a   |
+-----------+     +---------+
        │              │
        └──── apply ───┘
               │
               ▼
           +--------+
           |  F b   |
           +--------+
```

## Example

`Just (+3) <*> Just 4`

```
+-----------+    +--------+
| Just (+3) | <*>| Just 4 |
+-----------+    +--------+
        │
        ▼
   +--------+
   | Just 7 |
   +--------+
```

## Multi arg functions (Applicative shines)

Suppose 
- `add x y = x + y`

Applicative allows feeding arguments one box at a time

- `add <$> F x <*> F y`

Diagram:
```
        add
         │
         ▼
      fmap/add
         │
         ▼
     +---------+
     | F (y->z)|
     +---------+
          │
          │ <*> F y
          ▼
       +------+
       | F z  |
       +------+
```

## Example

`(+) <$> Just 3 <*> Just 4`

Step 1: `(+) <$> Just 3`

```
+--------+
|Just 3  |
+--------+
     │
     ▼
+------------+
|Just (3 + ) |
+------------+
```

Step 2: 
`Just (3+) <*> Just 4`

```
+-----------+   +--------+
| Just (3+) | <*>| Just 4 |
+-----------+   +--------+
        │
        ▼
     +--------+
     | Just 7 |
     +--------+
```

- so applicative allows us to apply this function to multiple boxes which are chained together with th `<*>`  (rough idea)

- Ex: 
	-  `f <$> box1 <*> box2 <*> box3`
	- This is read as : apply `f` to the values inside `box1`, `box2`, and `box3`.
	- so it behaves like `f a b c`