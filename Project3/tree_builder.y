%{
#include <stdio.h>
#include <stdlib.h>
#include "parse_tree.h"

extern int yylex();
void yyerror(const char *s);

compound_statement *root;
%}

%union {
    int intval;
    char *strval;
    integer_expression *int_expr;
    boolean_expression *bool_expr;
    statement *stmt;
    compound_statement *compound;
}

%token <intval> TK_integer
%token <strval> TK_variable
%token <strval> TK_string

%token TK_buildnode TK_name TK_weight TK_isachildof
%token TK_print TK_for TK_in

%type <int_expr> expr
%type <bool_expr> bool_expr
%type <stmt> statement
%type <compound> stmt_list

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
    TK_variable '=' expr ';'
        { $$ = new assignment_statement($1, $3); }

  | TK_print expr ';'
        { $$ = new print_statement($2); }

  | '{' stmt_list '}'
        { $$ = $2; }

  | TK_for TK_variable TK_in expr '{' stmt_list '}'
        {
            $$ = new while_statement(
                new greater_expr($4, new int_constant(0)),
                $6
            );
        }

  | TK_buildnode TK_variable TK_weight TK_integer ';'
        { $$ = new buildnode_statement($2, $4); }

  | TK_variable TK_isachildof TK_variable ';'
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

bool_expr:
    expr '<' expr  { $$ = new less_expr($1, $3); }
  | expr '>' expr  { $$ = new greater_expr($1, $3); }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}
