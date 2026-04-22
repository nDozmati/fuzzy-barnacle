/**
 * @file tree_builder.y
 * @brief syntax analyzer for TreeBuilder language
 * @date 2026-04-22
 * @author Nicolas Dozmati & Matthew Carpenter
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include "parse_tree.h"

extern "C" int yylex();
extern "C" int yyparse();
void yyerror(const char *s);

compound_statement *root;
%}

%union {
    int intval;
    char *strval;
    integer_expression *int_expr;
    boolean_expression *bool_expr;
    string_expression *str_expr;
    statement *stmt;
    compound_statement *compound;
    struct { integer_expression *lower; integer_expression *upper; } range_t;
}

%token <intval> TK_integer
%token <strval> TK_variable
%token <strval> TK_string

%token TK_buildnode TK_name TK_weight TK_isachildof
%token TK_print TK_for TK_in

%type <int_expr> expr
%type <str_expr> str_expr
%type <stmt> statement
%type <compound> stmt_list
%type <range_t> range

%left '+' '-'
%left '*' '/' '%'

%%

program:
    stmt_list { root = $1; }
;

stmt_list:
    statement stmt_list { $$ = new compound_statement($1, $2); }
  | /* empty */         { $$ = NULL; }
;

statement:
    // Variable assignment: var = expr;
    TK_variable '=' expr ';'
        { $$ = new assignment_statement($1, $3); }

  | // Print the tree: print(expr);
    TK_print str_expr ';'
        { $$ = new print_statement($2); }

  | // Compound statement: { stmt_list }
    '{' stmt_list '}'
        { $$ = $2; }

  | // For loop: for var in [low:high] { body }
    TK_for TK_variable TK_in range '{' stmt_list '}' ';'
        {
            $$ = new for_statement($2, $4.lower, $4.upper, $6);
        }

  | // Build root node: buildnode { name=expr; weight=expr; };
    TK_buildnode '{' TK_name '=' str_expr ';' TK_weight '=' expr ';' '}' ';'
        { $$ = new buildnode_statement($5, $9, NULL); }

  | // Build node with parent: buildnode { name=expr; weight=expr; isachildof=expr; };
    TK_buildnode '{' TK_name '=' str_expr ';' TK_weight '=' expr ';' TK_isachildof '=' str_expr ';' '}' ';'
        { $$ = new buildnode_statement($5, $9, $13); }

  | // Add child relationship: var isachildof var;
    TK_variable TK_isachildof TK_variable ';'
        { $$ = new childof_statement($1, $3); }
;

expr:
    expr '+' expr { $$ = new plus_expr($1, $3); }
  | expr '-' expr { $$ = new minus_expr($1, $3); }
  | expr '*' expr { $$ = new mult_expr($1, $3); }
  | expr '/' expr { $$ = new div_expr($1, $3); }
  | expr '%' expr { $$ = new mod_expr($1, $3); }
  | '(' expr ')'  { $$ = $2; }
  | TK_integer    { $$ = new int_constant($1); }
  | TK_variable   { $$ = new variable($1); }
;

str_expr:
    str_expr '+' expr { $$ = new string_concat_int($1, $3); }
  | str_expr '+' str_expr { $$ = new string_concat($1, $3); }
  | '(' str_expr ')'  { $$ = $2; }
  | TK_string    { $$ = new string_constant($1); }
;

range:
    '[' expr ':' expr ']' { $$.lower = $2; $$.upper = $4; }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}
