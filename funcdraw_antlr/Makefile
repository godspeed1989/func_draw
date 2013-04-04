NAME=funcdraw
CC=g++
LIBS=-lm -lX11 -lantlr
RM=rm -f
CLS=clear
ANTLR=java antlr.Tool
CFLAGS= -Wall 

all:
	make gen
	make compile
	make link

gen:
	$(ANTLR) Parser.g
	@echo ----------------------------
	$(ANTLR) TreeParser.g
	@echo ----------------------------

compile:
	$(CC) $(CFLAGS) *.cpp $(INCLUDEPATH) -c
	@echo ----------------------------

link:
	$(CC) $(CFLAGS) *.o $(LIBS) -o $(NAME)
	@echo ----------------------------

clean:
	$(RM) *.o
	$(RM) DrawLexer.hpp
	$(RM) DrawLexer.cpp
	$(RM) DrawParser.cpp
	$(RM) DrawParser.hpp
	$(RM) DrawParserTokenTypes.hpp
	$(RM) DrawParserTokenTypes.txt
	$(RM) DrawTreeWalker.cpp
	$(RM) DrawTreeWalker.hpp
	$(RM) DrawTreeWalkerTokenTypes.hpp
	$(RM) DrawTreeWalkerTokenTypes.txt
	$(CLS)

clean_all:
	$(RM) $(NAME)
	make clean

