# Minishell

## Technical notes
-  AST-based command representation<br>
This project uses an **Abstract Syntax Tree (AST)** to represent the command line. More specifically, it follows a **type-tagged, polymorphic** AST design.<br> At the core is a minimal base struct (`t_cmd`) that contains only an `int type` field. Every concrete command —pipeline, list operator, redirection, exec command, logical AND/OR, heredoc, and so on - has its own specialized struct that embeds the base struct's header field (`int type`) and then carries whatever additional data.Because all nodes share this common `int type` header, the parser and executor can treat any specialized node as a generic `t_cmd` and select the correct behavior based solely on the type.<br> During parsing, the input command line is broken into logical components and assembled into an AST. Binary operators such as pipelines, command lists, and logical AND/OR become nodes containing two children (`left` and `right`). Commands like redirections or heredocs wrap a single subcommand. Leaf nodes are exec-command nodes, which hold the final command arguments and all information needed to run the program.<br> Execution is performed by recursively traversing the AST and handling each node according to its type, allowing the shell to evaluate complex command lines in a structured and predictable way.
- Lookahead-based tokenizer <br>
The shell uses a **hand-written, lookahead-based tokenizer** to scan the input line and produce tokens for the parser. The tokenizer walks the input **character by character**, skips irrelevant whitespace, and classifies each token according to shell syntax rules. It handles multi-character operators (such as `&&`, `||`, `<<`, `>>`), quotes, parentheses, redirections, and ordinary words. Each call identifies a token’s type, returns the token’s start and end positions, and advances the input pointer so the parser can continue from the correct location.<br><br>
![AST_examples](https://github.com/user-attachments/assets/b1bf55d3-82dc-4be6-84d8-66fc69e18956)


- Operator Precedence and Parsing Strategy
The shell follows a well-defined operator precedence, which determines how complex command lines are grouped. From strongest binding to weakest:<br><br>
**Parentheses**<br>
Group commands and force them to be parsed as a unit.<br><br>
**Redirections** (`<`, `>`, `>>`, `<<`)<br>
Attach tightly to the command they modify.<br><br>
**Simple commands and arguments**<br>
The basic building blocks of execution.<br><br>
**Pipelines** (`|`) <br>
Connect the output of one command to the input of another.<br><br>
**Logical operators** (`&&`, `||`) <br>
Control execution flow based on command success or failure. <br><br>
**Command lists** (`;`) <br>
The weakest binding, used to sequence independent commands.<br><br>
To implement these rules, the project uses a **recursive-descent parser with top-down precedence handling**. Each parsing function corresponds to one precedence level. Higher-precedence constructs call lower-precedence ones first, ensuring that tightly bound operations (like redirections or pipelines) are parsed before more general ones (like lists or logical operators). Parenthesized expressions re-enter the parser at the highest level, allowing a complete command line to be nested inside a block.
This structure produces a clean and predictable Abstract Syntax Tree (AST) where each node reflects the operator precedence defined by the shell grammar.<br>
![parsing-strategy](https://github.com/user-attachments/assets/a110c53c-e54b-4f12-89e4-c25c8780253e)

