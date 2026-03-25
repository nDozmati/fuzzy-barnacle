/**
 * @file sprout.l
 * @author Matthew Carpenter and Nicolas Dozmati
 * @brief lexical analyzer for a custom Tree language
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

/* define here */

%}


%%

[ \t\n]+                    ;   /* ignore whitespace, tabs, and new line characters */
"//".*                      ;   /* ignore single line comment */
"/*"([^*]|\*+[^*/])*\*+"/"  ;   /* ignore multi-line comment */

/* emit here */

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
