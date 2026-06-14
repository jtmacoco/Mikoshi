```haskell title=factorial
fact 0 acc = acc
fact n acc = fact(n-1) (n*acc)
```

9)
`myAdd x y = Just  $ y + x`

# Syntax
- Structure of a program 
- Define with grammar
- Lexer Text -> [Tokens]
- Parser:  Produce AST so takes list of tokens [tokens] and returns AST
- Bottom up parsers
	- YACC/Bison 
	- LALR
- Top Down parsers
	- LLK
	- LL*, ALL(\*)
	- Parsing Combinators 
- Parsec
---
# Semantics
- Meaning of program
- Big step operational semantics aka natural semantics 
	- $E \Downarrow v$
	- done in one step
- Small step operational semantics aka structural semantics
	- $e->e' .... > e''' -> v$
	- $e->*V$
- Store $\sigma$
	- Store represents mutable state
---
# Lambda Calculus
- Minimal 
- Truing complete programming language
- Grammar is just x | var | x* e| e e 
- Call by value
- Call by need
---
# Latex
- DSL for typesetting docs
- Literate Prog
