/**
 * @file tree_builder.l
 * @brief lexical analyzer for TreeBuilder language
 * @date 04/15/2026
 * @author Nicolas Dozmati & Matthew Carpenter
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Include parser-generated token definitions */
#include "y.tab.h"

/* yylval is defined by yacc */
extern YYSTYPE yylval;
%}

/* FLEX OPTIONS */
%option yylineno

/* moved token declarations to yacc file... */

/* REGULAR EXPRESSIONS */
VARIABLE    [a-zA-Z_][_a-zA-Z0-9]*
INT         [0-9]+
STRING      \"([^\"\\]|\\.)*\"
WHITESPACE  [ \t\n]+
<<EOF>>     { return 0; }

%%

/* Ignore whitespace */
{WHITESPACE}    ;   /* ignore whitespace, tabs, and new line characters */

/* LITERALS */
{STRING} {
    yylval.strval = strdup(yytext);
    return TK_string;
}

{INT} {
    yylval.intval = atoi(yytext);
    return TK_integer;
}

/* KEYWORDS */
"buildnode"     { return TK_buildnode; }
"name"          { return TK_name; }
"weight"        { return TK_weight; }
"isachildof"    { return TK_isachildof; }

"print"         { return TK_print; }
"for"           { return TK_for; }
"in"            { return TK_in; }

/* IDENTIFIERS */
{VARIABLE} {
    yylval.strval = strdup(yytext);
    return TK_variable;
}

/* OPERATORS */
"="             { return '='; }
">"             { return '>'; }
"<"             { return '<'; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"\\"            { return '\\'; }
"%"             { return '%'; }
"^"             { return '^'; }

/* DELIMITERS */
"{"             { return '{'; }
"}"             { return '}'; }
"["             { return '['; }
"]"             { return ']'; }
"("             { return '('; }
")"             { return ')'; }
"'"             { return '\''; }
";"             { return ';'; }
":"             { return ':'; }

/* ERROR HANDLING */
. {
    fprintf(stderr, "Unexpected character '%s' at line %d\n", yytext, yylineno);
}

%%

/* No main, handled by parser */
