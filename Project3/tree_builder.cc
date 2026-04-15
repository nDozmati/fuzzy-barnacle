/**
 * @file tree_builder.cc
 * @author Matthew Carpenter and Nicolas Dozmati
 * @brief Driver for TreeBuilder lexical analyzer
 * @date 2026-04-15
 * 
 */

#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <map>

#include "parse_tree.h"

using namespace std;

// Flex interface (C linkage)
extern "C" {
    int yyparse();
    int yylex();
    extern FILE* yyin;
}

extern compound_statement *root;

// Shared output file (used by sprout.l)
FILE* out;

int main(int argc, char* argv[]) {
    // Check for input file
    if (argc < 2) {
        cerr << "Usage: ./TreeBuilder <inputfile>\n";
        return 1;
    }

    // Open input file
    FILE* inFile = fopen(argv[1], "r");
    if (!inFile) {
        cerr << "Error: cannot open file " << argv[1] << "\n";
        return 1;
    }

    yyin = inFile;

    // Parse the input file and build the parse tree (root)
    if (yyparse() == 0) {
        cout << "Parsing successful.\n";
        // Evaluate the parse tree to build the actual tree structure
        map<string,int> sym_tab;
        if (root) {
            root->evaluate_statement(sym_tab);
        }
    } else {
        cerr << "Parsing failed.\n";
    }

    fclose(inFile);
    return 0;
}
