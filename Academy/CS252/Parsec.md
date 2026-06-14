**Tags**: #parsec #haskell

```haskell title=parser-v1
import Text.ParserCombinators.Parsec
import System.Enumeratment

csvFile :: GenParser Char st [[string]]
csvFile = do
 result <- many line
 eof 
 return result
 
line :: GenParser Char st [string]
line = do
 result <- cells
 char '\n'
 return result 
 
 cells = do 
	 first <- cellContent
	 next <- remainingCells
	 return (first: next)
	 
remainingCells = do
 (char ',' >> cells)
 <|> return  []
 
 cellContent = many (noneOf ",\n")
 
 parseCSV :: string -> Either ParseError [[string]]
 parseCSV input = parse csvFile "Unkown" input

 main = do
  args <- getArgs
  p <- parseFromFile csvFile (head args)
  case p of
   Left err -> print err
   right csv -> print csv
 
```


```haskell title=parser-v2
csvFile =  line `endBy` eol
line = cell `sepBy` (char ',')
cell = many (noneOf, ",\n\r")
eof = try (string "\n\r")
 <|> string "\n"
 <?> "end of line"

```


# What is Parsec

>[!important] Parsec
>Parsec is a Haskell library for building parsers by combining small parsing functions into larger ones. It lets you describe the structure of text declaratively instead of manually managing loops and state.
## Analogy
- Parsec is like LEGO for text processing
- Breaks things into small pieces like `digit`, `lette`, etc.
- Put the pieces together with combinators (`many`, `many`, `choice`, and mondads)
- Builds bigger structures
---

```haskell title=parsec
num :: GenParser Char st Integer
num = do
str <- many1 digit
return $ read str
```

## Type Signature

- `num :: Gen Parser Char st Integer`
-  This is the signature because GenParser has the form `GenParser tokenType userState resultType`
	- `char` : is what the parser consumes so characters (basically parses a `string`)
	- `st` : is what the parser carries so some user defined state (not used in the example) 
	- `Integer` : The parser returns an Integer if successful
- So in English terms it means 

> `num` is a parser that reads characters and outputs an `Integer`

## Definition
```haskell title=definition
num = do
  str <- many1 digit
  return $ read str
```

- This basically monadic operations
- Breaks it up line by line 
---
# What is  `Many1`

`many1 p`
> This means parse one or more occurrences of parser p

```haskell title=parseLetters
import Text.ParserCombinators.Parsec

letters :: GenParser Char st String
letters = many1 letter
```

- `letter` parses one alphabetic character
- `many1 letter` parses one or more letters
### Error Case
`parseTest letters "123abc"`
-  Will cause error because `many1` requires at **at least one** Char
- Note using `many` would fix this as many doesn't require at least 1 
---
