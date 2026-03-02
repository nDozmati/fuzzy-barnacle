%{
    //declarations
    #include <iostream>
    #include <cstdio>

    using namespace std;

   #define TKKEYWORD   001
   #define TKID        002
   #define TKNUMBER    003
   #define TKOP        004
   #define TKDEL       005
    %}
// definitions 
WS [ \t\n]+  
ID [a-zA-Z_][a-zA-Z0-9_]*
NUM [0-9]+

%%
// Remove Whitespace
{WS} { }
// keywords 
"int" {return TKKEYWORD;}
"if"  {return TKKEYWORD;}
"while" {return TKKEYWORD;}
"else"  {return TKKEYWORD;}
"return" {return TKKEYWORD;}
//Identifiers 
{ID} {return TKID;}
// number values
{NUM} {return TKNUMBER;}
// operators 
"+"       {return TKOP}
"-"       {return TKOP}
"="       {return TKOP}
// delimiters 
";"       {return TKDEL;}
"|"       {return TKDEL;}

.         { }

%%

int main(){
    yylex();
    return
}