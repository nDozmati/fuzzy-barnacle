/**
 * @file sprout.l
 * @author Matthew Carpenter and Nicolas Dozmati
 * @brief lexical analyzer for a custom TreeBuilder language
 * @date 2026-03-30
 * 
 */

%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *out;       /* global output file pointer */
int prev_token = -1;    /* track previous token */

/* HELPER MACROS */

/* Print a matched TK_id to outfile */
#define EMIT(token) do { fprintf(out, "%d ", token); prev_token = token; } while(0)


/* DEFINED TOKENS */

/* tree structures */
#define TK_buildnode 301
#define TK_name 302
#define TK_weight 303
#define TK_isachildof 304

/* tree keywords */
#define TK_print 401
#define TK_for 402
#define TK_in 403

/* multi-char operators */
#define TK_equalequal 501
#define TK_notequal 502
#define TK_greaterequal 503
#define TK_lesserequal 504
#define TK_plusequal 505
#define TK_minusequal 506
#define TK_starequal 507
#define TK_slashequal 508
#define TK_plusplus 509
#define TK_minusminus 510

/* single-char operators (ascii token < 256) */
#define TK_equal '='
#define TK_greaterthan '>'
#define TK_lesserthan '<'
#define TK_plus '+'
#define TK_minus '-'
#define TK_star '*'
#define TK_slash '/'
#define TK_backslash '\\'
#define TK_percent '%'
#define TK_caret '^'

/* delimiters (ascii token < 256) */
#define TK_opencurly '{'
#define TK_closecurly '}'
#define TK_openbrack '['
#define TK_closebrack ']'
#define TK_openparen '('
#define TK_closeparen ')'
#define TK_quotation '\"'
#define TK_apostrophe '\''
#define TK_semicolon ';'
#define TK_colon ':'

/* identifiers */
#define TK_variable 901
#define TK_integer 902
#define TK_string 903
#define TK_eof 999


%}

/* REGULAR EXPRESSIONS */
VARIABLE    [a-zA-Z_][_a-zA-Z0-9]*
INT         [0-9]+
STRING      \"([^\"\\]|\\.)*\"
WHITESPACE  [ \t\n]+
/* EOF */

/* FLEX OPTIONS (line numbers) */
%option yylineno

%%

{WHITESPACE}    ;   /* ignore whitespace, tabs, and new line characters */

{STRING}        { return(TK_string); }
{INT}           { return(TK_integer); }      

"buildnode"     { return(TK_buildnode); }
"name"          { return(TK_name); }
"weight"        { return(TK_weight); }
"isachildof"    { return(TK_isachildof); }

"print"         { return(TK_print); }
"for"           { return(TK_for); }
"in"            { return(TK_in); }

{VARIABLE}      { return(TK_variable); }

"=="            { return(TK_equalequal); }
"!="            { return(TK_notequal); }
">="            { return(TK_greaterequal); }
"<="            { return(TK_lesserequal); }
"+="            { return(TK_plusequal); }
"-="            { return(TK_minusequal); }
"*="            { return(TK_starequal); }
"/="            { return(TK_slashequal); }
"++"            { return(TK_plusplus); }
"--"            { return(TK_minusminus); }

"="             { return(TK_equal); }
">"             { return(TK_greaterthan); }
"<"             { return(TK_lesserthan); }
"+"             { return(TK_plus); }
"-"             { return(TK_minus); }
"*"             { return(TK_star); }
"/"             { return(TK_slash); }
"\\"            { return(TK_backslash); }
"%"             { return(TK_percent); }
"^"             { return(TK_caret); }

"{"             { return(TK_opencurly); }
"}"             { return(TK_closecurly); }
"["             { return(TK_openbrack); }
"]"             { return(TK_closebrack); }
"("             { return(TK_openparen); }
")"             { return(TK_closeparen); }
"\""            { return(TK_quotation); }
"'"             { return(TK_apostrophe); }
";"             { return(TK_semicolon); }
":"             { return(TK_colon); }


.               ;   /* ignore anything not previously matched */

%%

/* main moved to sprout.cc */
