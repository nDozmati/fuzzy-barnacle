# @file Makefile
# @brief Build TreeBuilder (Flex + Bison)
# @author Matthew Carpenter and Nicolas Dozmati
# @date 2026-04-15

CXX = g++
CC  = gcc
CXXFLAGS = -Wall -std=c++17 -Wno-unused-function  # Suppress unused function warnings from Flex-generated code
CFLAGS = -Wall

LEX = flex
YACC = bison -d

# Default target
all: TreeBuilder

# Generate parser
tree_builder.tab.c tree_builder.tab.h: tree_builder.y
	$(YACC) tree_builder.y

# Generate lexer
lex.yy.c: tree_builder.l tree_builder.tab.h
	$(LEX) tree_builder.l

# Compile parser
tree_builder.tab.o: tree_builder.tab.c
	$(CXX) $(CXXFLAGS) -c tree_builder.tab.c

# Compile lexer
lex.yy.o: lex.yy.c
	$(CXX) $(CXXFLAGS) -c lex.yy.c

# Build final executable
TreeBuilder: tree_builder.cc lex.yy.o tree_builder.tab.o
	$(CXX) $(CXXFLAGS) tree_builder.cc lex.yy.o tree_builder.tab.o -lfl -o TreeBuilder

# Run
run: all
	./TreeBuilder Examples/ex1.tree

# Clean
clean:
	rm -f lex.yy.c lex.yy.o tree_builder.tab.c tree_builder.tab.h tree_builder.tab.o TreeBuilder

.PHONY: all clean run
