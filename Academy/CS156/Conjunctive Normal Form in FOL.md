## Conversion of CNF in First Order Logic
- List steps in order for cheat sheet
1. Eliminate bi-conditionals and implications
2. Move $\neg$ inwards 
3. Standardize variables - Each quantifier must use a different variable 
4. Skolemize - Each existential variable is replaced by a Skolem function of the enclosing universally quantified variables. If there is no enclosing universally quantified variable the existential variable is replaced by a constant. Basically replace the $\exists$ with a constant or Skolem function 
5. Drop universal quantifiers
6. Apply distributivity ($V over \wedge$)
---
## Conversion to CNF
Everyone who loves all animals has a pet
$\forall_x [\forall_y Animal(y)\implies Loves(x,y)]\implies [\exists_z Pet(z,x)]$
Step 1: Eliminate bi-conditionals and implications
<span style="color:rgb(192, 0, 0)">if step is not applicable still list step but say it's not applicable </span>
Some means there exists $\exists$
<span style="color:rgb(192, 0, 0)">Do sentences together so sentence 1 step 1then sentence 2 step 1</span>

[[CS156]]