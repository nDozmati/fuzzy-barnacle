/**
 * @file tree_builder.l
 * @brief lexical analyzer for TreeBuilder language
 * @date 2026-04-22
 * @author Nicolas Dozmati & Matthew Carpenter
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Include parse tree definitions */
#include "parse_tree.h"
/* Include parser-generated token definitions */
#include "tree_builder.tab.h"

/* yylval is defined by yacc */
extern YYSTYPE yylval;

extern "C" int yylex();
%}

/* FLEX OPTIONS */
%option yylineno

/* moved token declarations to yacc file... */

/* REGULAR EXPRESSIONS */
VARIABLE    [a-zA-Z_][_a-zA-Z0-9]*
INT         [0-9]+
STRING      \"([^\"\\]|\\.)*\"
WHITESPACE  [ \t\n]+

%%

{WHITESPACE}    ;   /* ignore whitespace, tabs, and new line characters */

{STRING} {
    char *s = strdup(yytext + 1);
    s[strlen(s) - 1] = '\0';
    yylval.strval = s;
    return TK_string;
}

{INT} {
    yylval.intval = atoi(yytext);
    return TK_integer;
}

"buildnode"     { return TK_buildnode; }
"name"          { return TK_name; }
"weight"        { return TK_weight; }
"isachildof"    { return TK_isachildof; }

"print"         { return TK_print; }
"for"           { return TK_for; }
"in"            { return TK_in; }

{VARIABLE} {
    yylval.strval = strdup(yytext);
    return TK_variable;
}

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

"{"             { return '{'; }
"}"             { return '}'; }
"["             { return '['; }
"]"             { return ']'; }
"("             { return '('; }
")"             { return ')'; }
"'"             { return '\''; }
";"             { return ';'; }
":"             { return ':'; }

. {
    fprintf(stderr, "Unexpected character '%s' at line %d\n", yytext, yylineno);
}

%%

/* No main, handled by parser */
