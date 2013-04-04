CC=gcc
LEX=flex
YACC=bison
CFLAGS=-lm -O2 -lX11 -Wall

all: lex.yy.o main.o
	$(CC) *.o $(CFLAGS) -o funcdraw

lex.yy.o: funcdraw.l funcdraw.tab.o
	$(LEX) -i funcdraw.l
	$(CC) $(CFLAGS) -c -o lex.yy.o lex.yy.c

funcdraw.tab.o: funcdraw.y
	$(YACC) -d funcdraw.y
	$(CC) $(CFLAGS) -c -o funcdraw.tab.o funcdraw.tab.c

semantics.o: semantics.c funcdraw.tab.o XWindow.o
	$(CC) $(CFLAGS) -c -o semantics.o semantics.c

main.o: semantics.o XWindow.o lex.yy.o
	$(CC) $(CFLAGS) -c -o main.o main.c

XWindow.o: XWindow.c
	$(CC) $(CFLAGS) -c -o XWindow.o XWindow.c

clean:
	rm -f lex.yy.c lex.yy.o
	rm -f funcdraw.tab.c funcdraw.tab.h funcdraw.tab.o
	rm -f semantics.o main.o XWindow.o

clean_all:
	rm -f funcdraw
	rm -f lex.yy.c lex.yy.o
	rm -f funcdraw.tab.c funcdraw.tab.h funcdraw.tab.o
	rm -f semantics.o main.o XWindow.o

