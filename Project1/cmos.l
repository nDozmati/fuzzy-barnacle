%{
#include <stdio.h>
#include <stdlib.h>

FILE *out;  /* global output file pointer */
%}


%%

[ \t\n]+                    ;                       /* ignore whitespace, tabs, and new line characters */

"//".*                      ;                       /* ignore single line comment */

"/*"([^*]|\*+[^*/])*\*+"/"  ;                       /* ignore multi-line comment */

"if"                    { fprintf(out, "001 "); }   /* check for declared phrases first */
"else"                  { fprintf(out, "002 "); }
"while"                 { fprintf(out, "003 "); }
"for"                   { fprintf(out, "004 "); }
"return"                { fprintf(out, "005 "); }
"int"                   { fprintf(out, "006 "); }
"double"                { fprintf(out, "007 "); }
"float"                 { fprintf(out, "008 "); }
"char"                  { fprintf(out, "009 "); }

[a-zA-Z_][a-zA-Z0-9_]*  { fprintf(out, "100 "); }   /* identifiers */

[0-9]+                  { fprintf(out, "101 "); }   /* integer constants */

"=="                    { fprintf(out, "200 "); }   /* operators */
"="                     { fprintf(out, "201 "); }
"+"                     { fprintf(out, "202 "); }
"-"                     { fprintf(out, "203 "); }

";"                     { fprintf(out, "300 "); }   /* delimiters */
"("                     { fprintf(out, "301 "); }
")"                     { fprintf(out, "302 "); }
"{"                     { fprintf(out, "303 "); }
"}"                     { fprintf(out, "304 "); }

.                           ;                       /* ignore anything else not previously matched */

%%


int main() {
    out = fopen("scanner_out.txt", "w");    /* overwrite each time */
    if (!out) {
        printf("Error opening output file\n");
        return 1;
    }

    extern FILE *yyin;
    yyin = stdin;       /* read from redirected input */

    yylex();
    fclose(out);
    return 0;
}