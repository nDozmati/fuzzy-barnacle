/**
 * @file tree_builder.cc
 * @author Matthew Carpenter and Nicolas Dozmati
 * @brief Driver for TreeBuilder language: parses input, builds tree, and outputs tree-nodes format
 * @date 2026-04-22
 * 
 */

#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <map>

#include "parse_tree.h"

using namespace std;

// Global tree structures
unordered_map<string, Node*> node_map;
Node* tree_root = nullptr;
ofstream debug_out;

// Function to print the tree in the required format
void print_tree(Node* node, ostream& out) {
    out << node->name;
    if (!node->children.empty()) {
        out << "[";
        for (size_t i = 0; i < node->children.size(); ++i) {
            if (i > 0) out << ",";
            print_tree(node->children[i], out);
        }
        out << "]";
    }
}

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

    // Open debug output file
    debug_out.open("debug.txt");
    if (!debug_out.is_open()) {
        cerr << "Error: cannot open debug.txt\n";
        return 1;
    }

    // Parse the input file and build the parse tree (root)
    if (yyparse() == 0) {
        cout << "Parsing successful!\n";
        cout << "Check debug.txt for details on tree construction.\n";
        // Evaluate the parse tree to build the actual tree structure
        map<string,int> sym_tab;
        root->evaluate_statement(sym_tab);
    } else {
        cout << "Parsing failed...\n";
    }

    debug_out.close();
    fclose(inFile);
    return 0;
}
