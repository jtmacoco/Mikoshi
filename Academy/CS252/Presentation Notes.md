## **Comparing Object-Oriented Design in Smalltalk, C++, and Java**
- Interesting talk for the different programming languages for object oriented programming
- Small talk was most interesting as I haven’t used it before but everything is an object
- Code styles are also different and interesting 
- Small talk pure oop
- Smalltalk not really used since wasn't good for distributed
- Java dominant in Enterprise software
---
## Gradual Typing
- Interesting project on gradual typing I found it interesting as the interesting to highlight how small type changes can cause performance swings
- More static type != better performance
- Gradual typing it is promising but in practice there are typically limitations
---
## A Gradual Type Checker for Bash Function Calls and Pipelines
- I found this interesting as this project goes over how bash doesn't have a type system which is something I've never really thought of since I've only really used it for small scripts. 
- ShellCheck is interesting which is syntax liniting, no types
- Amber is another tool that helps with typing 
- Crazy incident where there were issues when trying to implement typing as this was cool to see how there are issues when making such large changes like typing systems 
- Gradual Typing helps types incrementally so this helps not break stuff I think
---
## TypeScript vs. JavaScript: A Survey of Gradual Typing, Language Design, and Practical Tradeoffs.
- Interesting how javascript has so many assumptions until runtime 
- Output of typescript is javascript
- Team doesn't need to re-write everything at once
- TypeScript doesn't automatically validate at runtime 
- Useful != fully safe
	- unsafe programs can still pass through
- Javascript hard to type check due to dynamic stuff
- 
---
##  Resumex: A Domain-Specific Language for Resume Generation.
- This was a good project as I personally find it kind of tedious to keep updating my resume for a particular job. I find this to be particularly predominant today since so many people use AI to generate a resume based on the job description. 
- This is a great project and seems to be very useful for many students or graduates who are looking for a job
- So it outputs a latex file or pdf 
- Interesting how it sorts the skills via the job description 

---
## A Domain-Specific Language for Music Composition
- Coo project about music
- Tone.js to output a sound
- Language is python inspired 
- Multiple notes together are interesting implementation similar to a list
- Nodes classes for AST instead of plain dictionaries 
- Python for lexer and parser
- Duration output is in seconds and did conversion on his own end

---
## A Live-Coding Language for Real-Time Music Generation.
- DSL includes hotswaping, any changes automatically applied no need for restarts
- Similar to react projects
- Interesting part was the hotswapapble part for automatic changes 

---
## Design and Implementation of a Small Programming Language in Haskell
- This was an interesting project 
- Implemented match so it matches automatically unpacks head and tail

---
##  AJS: An English-Like DSL for Stock Trading
- Interesting take on english based language for trading
- English like so not just programmers can use it
- Event driven, so options
- Real time simulation
-  

---
# Day 2

##  Lighthouse: a Logic-Based Redirection Language
- Lighthouse is a different way to write how api's re direct stuff similar to nginx
- File to help fix issues with aws configs
- So a checker for json files
- So it's a type checker for json configs
- Idea is checking json meant for aws balancer rules 
- To many mistakes want to reduce errors or pushing out 
---
##  Metaprogramming Across Paradigms: A Comparative Study of Smalltalk, Common Lisp (CLOS), and Lua.
- SmallTalk communicates with objects
- Everything is an object
- Can pass own function 
- Swap identity of two live objects all pointers update instantly
- Clos
	- Allows programmers to customize it
	- Can be modified during runtime
	- Multiple dispatch
	- I don't get it 
- Lua designed to fit inside another language
- Survey 
---
## A Language for AI Agent Workflows
- Small language for running agent workflows
- Defined everything like semantics
- Needed so instead of library have semantics to back why stuff breaks
- Treat them like real programs rather than individual scripts
- Make it easier for others non programmers
- 
---
## Implementing a Small Simply Typed Functional Language with Pattern Matching
- Pattern matching stuff
- Goal to explore features are implemented internally 
- Supports
	- Core expressions
	- Ints
	- Bools
	- Conditionals
	- Let bindings
	- Lambda Expressios
- Data & Matching
	- Lists using Nil and Cons
	- case expressions for pattern matching
- Types
	- Int
	- Bool
	- function types
	- list types
- Limitation pattern matching restricted to list structures does not support primitive types
- Manual typing requires type annotation due to lack of inference
- 
---
## Language Server for the IMP Language
- So basically like a thing that tells you what is wrong in neovim similar to vscode 
- Uses Tree-Sitter Queries
	- provides a query language that can pattern match on the AST
	
---
## Compiler for SPIR-V
- No longer compile shaders at runtime
- Don't need compiler
- Built compiler to compiler these shaders
---
##  Extensible Markdown-to-LaTeX Compiler in Haskell
- Makes markdown easier
- Included validation ideas to help figure out the random question marks
- Ensures correctness before rendering
- Validation AST
	- Checking references basically
	- Detects label and sends it to a map
	- Checks if exists in table or not
- Future work would be adding tables and math equations 
---
##  Interpreter for a Stack-Based Language with User-Defined Words
- Built stack based language interpreter in haskell
- Stack based language stuff resides in implicit stack
- User defined words stored in dictionary called by name
 - Branches are just instruction list
 - Implemented types and stuff
 - Reads source text into list of instruction
	 - Evaluates the instructions
- All runtime errors return clear descriptive messages 
- Inspired by Forth language
---
## Purple: A DSL for Formula 1 Race Strategy.
- Restrictive language to help ensure no errors happen
- This errors can be bad for racing
- TypeSystem restrictive 
- So it helps specifically for racing
- No loops no recursion 
---
# Day 3
---
## a higher level language for configuring firewall rules

---
## Static Analyzer for a Small Expression Language.

