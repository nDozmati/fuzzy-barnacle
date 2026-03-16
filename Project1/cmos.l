%{
#include <stdio.h>
#include <stdlib.h>

FILE *out;  /* global output file pointer */

/* DEFINED TOKENS */

/* keywords */
#define TK_if 101
#define TK_else 102
#define TK_while 103
#define TK_for 104
#define TK_return 105
#define TK_int 106
#define TK_double 107
#define TK_float 108
#define TK_char 109 /* did not like 009 (bad octal) -> now 109 */
#define TK_void 110
#define TK_const 111

/* identifiers */
#define TK_identifier 900
#define TK_number 901
#define TK_address 902

/* operators */
#define TK_equalequal 200
#define TK_notequal 201
#define TK_greaterequal 202
#define TK_lesserequal 203
#define TK_plusequal 204
#define TK_minusequal 205
#define TK_multiplyequal 206
#define TK_divideequal 207
#define TK_equal 208
#define TK_plusplus 209
#define TK_plus 210
#define TK_minusminus 211
#define TK_minus 212
#define TK_star 213 /* must parse to distinguish pointer versus multiplication */
#define TK_divide 214
#define TK_input 215
#define TK_greaterthan 216
#define TK_output 217
#define TK_lessthan 218
#define TK_and 219
#define TK_or 220
#define TK_questionmark 221
#define TK_carrot 222
#define TK_modulo 223

/* delimiters */
#define TK_semicolon 300
#define TK_comma 301
#define TK_leftparen 302
#define TK_rightparen 303
#define TK_leftbrack 304
#define TK_rightbrack 305
#define TK_leftcurl 306
#define TK_rightcurl 307
#define TK_backslash 308
#define TK_singlequote 309
#define TK_doublequote 310

%}


%%

[ \t\n]+                    ;   /* whitespace, tabs, and new line characters */
"//".*                      ;   /* single line comment */
"/*"([^*]|\*+[^*/])*\*+"/"  ;   /* multi-line comment */

"if"                        { fprintf(out, "%d ", TK_if); }
"else"                      { fprintf(out, "%d ", TK_else); }
"while"                     { fprintf(out, "%d ", TK_while); }
"for"                       { fprintf(out, "%d ", TK_for); }
"return"                    { fprintf(out, "%d ", TK_return); }
"int"                       { fprintf(out, "%d ", TK_int); }
"double"                    { fprintf(out, "%d ", TK_double); }
"float"                     { fprintf(out, "%d ", TK_float); }
"char"                      { fprintf(out, "%d ", TK_char); }
"void"                      { fprintf(out, "%d ", TK_void); }
"const"                     { fprintf(out, "%d ", TK_const); }

[a-zA-Z_][_a-zA-Z0-9]*      { fprintf(out, "%d ", TK_identifier); }
[0-9]+                      { fprintf(out, "%d ", TK_number); }

"=="                        { fprintf(out, "%d ", TK_equalequal); }
"!="                        { fprintf(out, "%d ", TK_notequal); }
">="                        { fprintf(out, "%d ", TK_greaterequal); }
"<="                        { fprintf(out, "%d ", TK_lesserequal); }
"+="                        { fprintf(out, "%d ", TK_plusequal); }
"-="                        { fprintf(out, "%d ", TK_minusequal); }
"*="                        { fprintf(out, "%d ", TK_multiplyequal); }
"/="                        { fprintf(out, "%d ", TK_divideequal); }
"="                         { fprintf(out, "%d ", TK_equal); }
"++"                        { fprintf(out, "%d ", TK_plusplus); }
"--"                        { fprintf(out, "%d ", TK_minusminus); }
"+"                         { fprintf(out, "%d ", TK_plus); }
"-"                         { fprintf(out, "%d ", TK_minus); }
"*"                         { fprintf(out, "%d ", TK_star); }
"/"                         { fprintf(out, "%d ", TK_divide); }
">>"                        { fprintf(out, "%d ", TK_input); }
">"                         { fprintf(out, "%d ", TK_greaterthan); }
"<<"                        { fprintf(out, "%d ", TK_output); }
"<"                         { fprintf(out, "%d ", TK_lessthan); }
"&&"                        { fprintf(out, "%d ", TK_and); }
"&"                         { fprintf(out, "%d ", TK_address); }
"||"                        { fprintf(out, "%d ", TK_or); }
"?"                         { fprintf(out, "%d ", TK_questionmark); }
"^"                         { fprintf(out, "%d ", TK_carrot); }
"%"                         { fprintf(out, "%d ", TK_modulo); }

";"                         { fprintf(out, "%d ", TK_semicolon); }
","                         { fprintf(out, "%d ", TK_comma); }
"("                         { fprintf(out, "%d ", TK_leftparen); }
")"                         { fprintf(out, "%d ", TK_rightparen); }
"["                         { fprintf(out, "%d ", TK_leftbrack); }
"]"                         { fprintf(out, "%d ", TK_rightbrack); }
"{"                         { fprintf(out, "%d ", TK_leftcurl); }
"}"                         { fprintf(out, "%d ", TK_rightcurl); }
"\\"                        { fprintf(out, "%d ", TK_backslash); }
"'"                         { fprintf(out, "%d ", TK_singlequote); }
"\""                        { fprintf(out, "%d ", TK_doublequote); }

.                           ;

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
