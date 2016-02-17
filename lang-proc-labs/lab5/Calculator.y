%{
#include <iostream>
#include <cstdlib>

/* 
declaration of functions used in the parser generated by bison
yyerror is defined below
yylex is the name of the function from which bison expects to receive tokens
and it's also conveniently the name of the tokenizer function generated by flex
(it's defined in that source file)
*/

int yylex();
int yyerror(const char* s);
%}

%token NUM ADDOP MULTOP LBRACKET RBRACKET EOLINE

/*
the tokens for the language 

below: the grammar production rules
non-terminating symbols are lowercase
terminating symbols (tokens) are uppercase

the : is used instead of the BNF -> (or ::=) symbol
(the | is still a |, rules are terminated by a ;)

next to the rules there are "semantic actions" which are triggered
when a grammar rule matches 

$$ is the value taken by the left hand side of the rules
$1...$n are the n values of the n components of the rule rhs
*/

%%

file   : line file
       | line
       ;
line   : expr EOLINE { std::cout << "Expr value: " <<  $1 << std::endl;  }
       ;
expr   : expr ADDOP term { $$ = $1 + $3;}
       | term 
       ; 
term   : term MULTOP factor { $$ = $1 * $3; } 
       | factor 
       ;
factor : LBRACKET expr RBRACKET { $$ = $2;}
       | NUM { 
            $$ = $1 ;
        }
       ;

%%

int yyerror(const char* s){ 
    std::cout << s << std::endl;
    return -1;
}

int main(void) {
  yyparse();
}