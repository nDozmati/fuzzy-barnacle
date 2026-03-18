/**
 * @file cmos.l
 * @author Matthew Carpenter and Nicolas Dozmati
 * @brief lexical analyzer for plagiarism checker
 * @date 2026-03-16
 * 
 */

%{
#include <stdio.h>
#include <stdlib.h>

FILE *out;  /* global output file pointer */

/* Track previous token */
int prev_token = -1;

/* Helper Macros */
#define EMIT(token) do { fprintf(out, "%d ", token); prev_token = token; } while(0)

/* DEFINED TOKENS */

/* data types */
#define TK_void 100
#define TK_int 101
#define TK_double 102
#define TK_float 103
#define TK_char 104
#define TK_const 105
#define TK_static 106

int is_type_token(int t) {
    return (t==TK_void || t==TK_int || t==TK_double || t==TK_float ||
            t==TK_char || t==TK_const || t==TK_static);
}

/* keywords */
#define TK_if 200
#define TK_else 201
#define TK_switch 202
#define TK_case 203
#define TK_break 204
#define TK_do 205
#define TK_while 206
#define TK_for 207
#define TK_return 208
#define TK_continue 209

int is_keyword_token(int t) {
    return (t==TK_if || t==TK_else || t==TK_switch || t==TK_case ||
            t==TK_break || t==TK_do || t==TK_while || t==TK_for || 
            t==TK_return || t==TK_continue);
}

/* data structures */
#define TK_struct 300
#define TK_class 301
#define TK_public 302
#define TK_private 303
#define TK_protected 304
#define TK_vector 305
#define TK_array 306

int is_structure_token(int t) {
    return (t==TK_struct || t==TK_class || t==TK_public || t==TK_private ||
            t==TK_protected || t==TK_vector || t==TK_array);
}

/* identifiers */
#define TK_identifier 900
#define TK_number 901

int is_identifier_token(int t) {
    return (t==TK_identifier || t==TK_number);
}

/* operators */
#define TK_equalequal 400
#define TK_notequal 401
#define TK_greaterequal 402
#define TK_lesserequal 403
#define TK_plusequal 404
#define TK_minusequal 405
#define TK_multiplyequal 406
#define TK_divideequal 407
#define TK_equal 408
#define TK_plusplus 409
#define TK_plus 410
#define TK_minusminus 411
#define TK_minus 412
#define TK_star 413     /* must parse to distinguish pointer versus multiplication (unused token) */
#define TK_pointer 414  /* {*ptr, * ptr, **ptr, ** ptr} */
#define TK_multiply 415 /* {a*b, a * b} */
#define TK_divide 416
#define TK_input 417
#define TK_greaterthan 418
#define TK_output 419
#define TK_lessthan 420
#define TK_and 421
#define TK_address 422
#define TK_or 423
#define TK_pipe 424
#define TK_questionmark 425
#define TK_carrot 426
#define TK_modulo 427

int is_operator_token(int t) {
    return (t==TK_equalequal || t==TK_greaterequal || t==TK_lesserequal || t==TK_plusequal || 
            t==TK_minusequal || t==TK_multiplyequal || t==TK_divideequal || t==TK_equal || 
            t==TK_plusplus || t==TK_plus || t==TK_minusminus || t==TK_minus || 
            t==TK_divide || t==TK_input || t==TK_greaterthan || t==TK_output || 
            t==TK_lessthan || t==TK_and || t==TK_address || t==TK_or || 
            t==TK_pipe || t==TK_questionmark || t==TK_carrot || t==TK_modulo);
}

/* delimiters */
#define TK_semicolon 500
#define TK_comma 501
#define TK_leftparen 502
#define TK_rightparen 503
#define TK_leftbrack 504
#define TK_rightbrack 505
#define TK_leftcurl 506
#define TK_rightcurl 507
#define TK_backslash 508
#define TK_singlequote 509
#define TK_doublequote 510

int is_delimiter_token(int t) {
    return (t==TK_semicolon || t==TK_comma || t==TK_leftparen || t==TK_rightparen ||
            t==TK_leftbrack || t==TK_rightbrack || t==TK_leftcurl || t==TK_rightcurl ||
            t==TK_backslash || t==TK_singlequote || t==TK_doublequote);
}

%}


%%

[ \t\n]+                    ;   /* ignore whitespace, tabs, and new line characters */
"//".*                      ;   /* ignore single line comment */
"/*"([^*]|\*+[^*/])*\*+"/"  ;   /* ignore multi-line comment */

"void"                      { EMIT(TK_void); }
"int"                       { EMIT(TK_int); }
"double"                    { EMIT(TK_double); }
"float"                     { EMIT(TK_float); }
"char"                      { EMIT(TK_char); }
"const"                     { EMIT(TK_const); }
"static"                    { EMIT(TK_static); }

"if"                        { EMIT(TK_if); }
"else"                      { EMIT(TK_else); }
"switch"                    { EMIT(TK_switch); }
"case"                      { EMIT(TK_case); }
"break"                     { EMIT(TK_break); }
"do"                        { EMIT(TK_do); }
"while"                     { EMIT(TK_while); }
"for"                       { EMIT(TK_for); }
"return"                    { EMIT(TK_return); }
"continue"                  { EMIT(TK_continue); }

"struct"                    { EMIT(TK_struct); }
"class"                     { EMIT(TK_class); }
"public"                    { EMIT(TK_public); }
"private"                   { EMIT(TK_private); }
"protected"                 { EMIT(TK_protected); }
"Vector"                    { EMIT(TK_vector); }
"array"                     { EMIT(TK_array); }

"=="                        { EMIT(TK_equalequal); }
"!="                        { EMIT(TK_notequal); }
">="                        { EMIT(TK_greaterequal); }
"<="                        { EMIT(TK_lesserequal); }
"+="                        { EMIT(TK_plusequal); }
"-="                        { EMIT(TK_minusequal); }
"*="                        { EMIT(TK_multiplyequal); }
"/="                        { EMIT(TK_divideequal); }
"="                         { EMIT(TK_equal); }
"++"                        { EMIT(TK_plusplus); }
"--"                        { EMIT(TK_minusminus); }
"+"                         { EMIT(TK_plus); }
"-"                         { EMIT(TK_minus); }
"*" {
    if (is_type_token(prev_token) ||
        prev_token == TK_pointer ||
        prev_token == TK_leftparen ||
        prev_token == TK_comma)
    {
        EMIT(TK_pointer);
    }
    else
    {
        EMIT(TK_multiply);
    }
}
"/"                         { EMIT(TK_divide); }
">>"                        { EMIT(TK_input); }
">"                         { EMIT(TK_greaterthan); }
"<<"                        { EMIT(TK_output); }
"<"                         { EMIT(TK_lessthan); }
"&&"                        { EMIT(TK_and); }
"&" {
    if (prev_token == TK_identifier ||
        prev_token == TK_number ||
        prev_token == TK_rightparen)
    {
        EMIT(TK_and);
    }
    else
    {
        EMIT(TK_address);
    }
}
"||"                        { EMIT(TK_or); }
"|"                         { EMIT(TK_pipe); }
"?"                         { EMIT(TK_questionmark); }
"^"                         { EMIT(TK_carrot); }
"%"                         { EMIT(TK_modulo); }

";"                         { EMIT(TK_semicolon); }
","                         { EMIT(TK_comma); }
"("                         { EMIT(TK_leftparen); }
")"                         { EMIT(TK_rightparen); }
"["                         { EMIT(TK_leftbrack); }
"]"                         { EMIT(TK_rightbrack); }
"{"                         { EMIT(TK_leftcurl); }
"}"                         { EMIT(TK_rightcurl); }
"\\"                        { EMIT(TK_backslash); }
"'"                         { EMIT(TK_singlequote); }
"\""                        { EMIT(TK_doublequote); }

[a-zA-Z_][_a-zA-Z0-9]*      { EMIT(TK_identifier); }
[0-9]+                      { EMIT(TK_number); }

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
