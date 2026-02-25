%{
#include <stdio.h>
#include <stdlib.h>

FILE *out;
%}

%%

"int"|"float"|"char"|"double"|"if"|"else"|"while"|"for"|"return" { 
    fprintf(out, "%s ", yytext); 
}

[a-zA-Z_][a-zA-Z0-9_]* { 
    fprintf(out, "ID "); 
}

[0-9]+ { 
    fprintf(out, "NUM "); 
}

"=="|"="|"+"|"-"|"*"|"/"|"{"|"}"|"("|")"|";" {
     fprintf(out, "%s ", yytext); 
}

[ \t\n]+    ;
.           ;

%%

int main() {
    out = fopen("tokens.txt", "w");
    yylex();
    fclose(out);
    return 0;
}