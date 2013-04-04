#include "semantics.h"
#include <stdio.h>
#include <X11/Xlib.h>
#include <assert.h>
extern int yyparse();
extern int yylex();
extern FILE *yyin;
extern Display* display;
extern void init_XWindow();
extern void close_XWindow();
int main(int argc, char* argv[])
{
	int retn;
	FILE* InFile;
	if(argc!=1)
		InFile = fopen(argv[1], "r");
	else
		InFile = fopen("test", "r");
	assert(InFile!=NULL);
	
	init_XWindow();
	
	yyin = InFile;
	retn = yyparse();
	printf("yyparse() ret %d\n", retn);
	fclose(InFile);

	close_XWindow();
	
	return 0;
}

