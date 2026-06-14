**Tags:** #semantics #big-step 

```haskell
data Exp = Etrue
 | EFalse
 | Eif Exp Exp Exp
deriving show
data Val = Vtrue
 | VFalse
deriving show
```

```haskell
evalute:: Exp -> Val
evaluate ETrue = VTrue
evaluate EFalse = VFalse
evaluate (Eif e1 e2 e3) = 
```
---
# Abstract Syntax Tree (AST)
- Operational semantics
	- Big-Step aka **natural**
	- Small-Step aka **structural**
---
# Big Step Semantics
- $=$ : means is
- $\Downarrow$ means evaluates to