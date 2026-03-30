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
all: sprout

# Generate lexer
lex.yy.c: sprout.l
	$(LEX) sprout.l

# Compile lexer (C)
lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -c lex.yy.c

# Build final executable (C++ + lexer)
sprout: sprout.cc lex.yy.o
	$(CXX) $(CXXFLAGS) sprout.cc lex.yy.o -lfl -o sprout

# Run on a sample file
run: all
	./sprout Examples/ex1.tree

# Clean
clean:
	rm -f lex.yy.c lex.yy.o sprout sprout_out.txt

.PHONY: all clean run