%{
    //declarations
    #include <iostream>
    #include <cstdio>

    using namespace std;
    FILE  *ofile;
    %}
// definitions 
WS [ \t\n]+  
ID [a-zA-Z_][a-zA-Z0-9_]*
NUM [0-9]+

%%
// Remove Whitespace
{WS} { }
// keywords
"int"|"if"|"while"|"else"|"return" {fprintf(ofile, "001 ");}
//Identifiers 
{ID} {fprintf(ofile, "002 ");}
// number values
{NUM} {fprintf(ofile, "003 ");}
// operators 
"+"|"-"|"="|"=="|">="|"<="|"!="      {fprintf(ofile, "004 ");}
// delimiters 
";"|"("|")"|"{"|"}"|","   {fprintf(ofile, "005")}

//Comments 
"//".*            { }
"/*"([^*]|\*+[^*/])*\*+"/"   { }


// everything else
.         { }

%%

int main(){
   ofile = fopen("tokens.txt", "w");
   yylex();
   fclose(ofile);
    return 0;
}