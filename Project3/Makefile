# @file Makefile
# @author Matthew Carpenter and Nicolas Dozmati
# @brief Build Sprout lexical analyzer
# @date 2026-03-30

CXX = g++
CC  = gcc
CXXFLAGS = -Wall -std=c++17
CFLAGS = -Wall
LEX = flex

# Default target
all: TreeBuilder

# Generate lexer
lex.yy.c: tree_builder.l
	$(LEX) tree_builder.l

# Compile lexer (C)
lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -c lex.yy.c

# Build final executable (C++ + lexer)
TreeBuilder: tree_builder.cc lex.yy.o
	$(CXX) $(CXXFLAGS) tree_builder.cc lex.yy.o -lfl -o TreeBuilder

# Run on a sample file
run: all
	./TreeBuilder Examples/ex1.tree

# Clean
clean:
	rm -f lex.yy.c lex.yy.o TreeBuilder Branch_out.txt

.PHONY: all clean run