#include "DrawLexer.hpp"
#include "DrawParser.hpp"
#include "DrawTreeWalker.hpp"
#include "semantics.hpp"
#include <fstream>
#include <unistd.h>
#include <stdio.h>
using namespace std;

extern void init_XWindow();
extern void close_XWindow();

int main(int argc, char* argv[])
{
	printf("===You can use reg 'a' 'b' 'c' 'd'===\n");
	init_XWindow();
	bold = 1;
	rot = 0;
	scale_x = scale_y = 1;
	origin_x = origin_y = 0;
	
	ifstream in;
	if(argc>=2)
		in.open(argv[1], ios_base::in);
	else
		in.open("test", ios_base::in);

	printf("***Initial Lexer Parser...\n");
	DrawLexer lexer(in);
	DrawParser parser(lexer);
	
	printf("***Initial ASTFactory...\n");
	ASTFactory my_factory;
	parser.initializeASTFactory(my_factory);
	parser.setASTFactory(&my_factory);
	parser.prog();
	
	printf("***Initial TreeWalker...\n");
	DrawTreeWalker treeWalker;
	treeWalker.initializeASTFactory(my_factory);
	treeWalker.progTree(RefAST(parser.getAST()));
	
	printf("***Finish...\n");
	in.close();
	sleep(3);
	close_XWindow();
	return 0;
}

