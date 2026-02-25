# Compiler settings
CXX = g++
CC  = gcc
CXXFLAGS = -Wall -std=c++17
CFLAGS = -Wall
LEX = flex

# Targets
all: scanner cmos

# Build scanner from Flex file
scanner: lex.yy.c
	$(CC) $(CFLAGS) lex.yy.c -o scanner -lfl

# Generate lex.yy.c from cmos.l
lex.yy.c: cmos.l
	$(LEX) cmos.l

# Build plagiarism scoring program
cmos: cmos.cpp
	$(CXX) $(CXXFLAGS) cmos.cpp -o cmos

# Run full detection pipeline
run: all
	bash PlagiarismDetector Examples

# Clean generated files
clean:
	rm -f scanner cmos lex.yy.c tokens.txt PlagarismReport.txt

.PHONY: all clean run
