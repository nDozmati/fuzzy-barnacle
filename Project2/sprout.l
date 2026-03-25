/**
 * @file sprout.l
 * @author Matthew Carpenter and Nicolas Dozmati
 * @brief lexical analyzer for a custom TreeBuilder language
 * @date 2026-03-25
 * 
 */

%{
#include <stdio.h>
#include <stdlib.h>

FILE *out;              /* global output file pointer */
int prev_token = -1;    /* track previous token */

/* HELPER MACROS */

/* Print a matched TK_id to outfile */
#define EMIT(token) do { fprintf(out, "%d ", token); prev_token = token; } while(0)

/* DEFINED TOKENS */

/* tree structures */
#define TK_buildnode 101
#define TK_name 102
#define TK_weight 103
#define TK_isachildof 104

/* keywords */
#define TK_print 201
#define TK_for 202
#define TK_in 203

/* operators */
#define TK_equalequal 301
#define TK_notequal 302
#define TK_greaterequal 303
#define TK_lesserequal 304
#define TK_plusequal 305
#define TK_minusequal 306
#define TK_starequal 307
#define TK_slashequal 308
#define TK_equal 309
#define TK_greaterthan 310
#define TK_lesserthan 311
#define TK_plusplus 312
#define TK_plus 313
#define TK_minusminus 314
#define TK_minus 315
#define TK_star 316
#define TK_slash 317

/* delimiters */
#define TK_opencurly 401
#define TK_closecurly 402
#define TK_openbrack 403
#define TK_closebrack 404
#define TK_openparen 405
#define TK_closeparen 406
#define TK_quotation 407
#define TK_semicolon 408
#define TK_colon 409

/* identifiers */
#define TK_variable 901
#define TK_integer 902


%}


%%

[ \t\n]+                    ;   /* ignore whitespace, tabs, and new line characters */
"//".*                      ;   /* ignore single line comment */
"/*"([^*]|\*+[^*/])*\*+"/"  ;   /* ignore multi-line comment */

"buildnode"                 { EMIT(TK_buildnode); }
"name"                      { EMIT(TK_name); }
"weight"                    { EMIT(TK_weight); }
"isachildof"                { EMIT(TK_isachildof); }

"print"                     { EMIT(TK_print); }
"for"                       { EMIT(TK_for); }
"in"                        { EMIT(TK_in); }

"=="                        { EMIT(TK_equalequal); }
"!="                        { EMIT(TK_notequal); }
">="                        { EMIT(TK_greaterequal); }
"<="                        { EMIT(TK_lesserequal); }
"+="                        { EMIT(TK_plusequal); }
"-="                        { EMIT(TK_minusequal); }
"*="                        { EMIT(TK_starequal); }
"/="                        { EMIT(TK_slashequal); }
"="                         { EMIT(TK_equal); }
">"                         { EMIT(TK_greaterthan); }
"<"                         { EMIT(TK_lesserthan); }
"++"                        { EMIT(TK_plusplus); }
"+"                         { EMIT(TK_plus); }
"--"                        { EMIT(TK_minusminus); }
"-"                         { EMIT(TK_minus); }
"*"                         { EMIT(TK_star); }
"/"                         { EMIT(TK_slash); }

"{"                         { EMIT(TK_opencurly); }
"}"                         { EMIT(TK_closecurly); }
"["                         { EMIT(TK_openbrack); }
"]"                         { EMIT(TK_closebrack); }
"("                         { EMIT(TK_openparen); }
")"                         { EMIT(TK_closeparen); }
"\""                        { EMIT(TK_quotation); }
";"                         { EMIT(TK_semicolon); }
":"                         { EMIT(TK_colon); }

[a-zA-Z_][_a-zA-Z0-9]*      { EMIT(TK_variable); }
[0-9]+                      { EMIT(TK_integer); }

.                           ;   /* ignore anything not previously matched */

%%


int main() {
    out = fopen("sprout_out.txt", "w"); /* overwrite each time */
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
