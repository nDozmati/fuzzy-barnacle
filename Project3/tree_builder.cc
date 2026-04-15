/**
 * @file tree_builder.cc
 * @author Matthew Carpenter and Nicolas Dozmati
 * @brief Driver for TreeBuilder lexical analyzer
 * @date 2026-03-30
 * 
 */

#include <cstdio>
#include <cstdlib>
#include <iostream>

using namespace std;

// Flex interface (C linkage)
extern "C" {
    int yylex();
    extern FILE* yyin;
}

// Shared output file (used by sprout.l)
FILE* out;

int main(int argc, char* argv[]) {
    // Check for input file
    if (argc < 2) {
        cerr << "Usage: ./sprout <inputfile>\n";
        return 1;
    }

    // Open input file
    FILE* inFile = fopen(argv[1], "r");
    if (!inFile) {
        cerr << "Error: cannot open file " << argv[1] << "\n";
        return 1;
    }

    yyin = inFile;

    // Open output file
    out = fopen("sprout_out.txt", "w");
    if (!out) {
        cerr << "Error: cannot open output file\n";
        fclose(inFile);
        return 1;
    }

    // Run lexer
    // yylex();

    // Debugging: print tokens or literal characters using lexer output
    int token;
    while ((token = yylex()) != 0) {
        if (token < 256) {
            fprintf(out, "'%c' ", (char)token); // literal char
        } else {
            fprintf(out, "%d ", token);         // keyword, operator, or identifier
        }
    }
    fprintf(out, "\n");

    fclose(inFile);
    fclose(out);

    cout << "Lexical analysis complete. Output in sprout_out.txt\n";
    return 0;
}
