#ifndef SEMANTICS_H
#define SEMANTICS_H
#include "funcdraw.tab.h"
#include <stdio.h>
#include <stdlib.h>

#define MAX_CHARS 200

typedef double(*MathFuncPtr)(double);
typedef double(*FuncPtr)(double);

struct Token
{
	char* lexeme;
	int type;
	double value;
	double (*FuncPtr)(double);
};

struct ExprNode
{
	enum yytokentype OpCode;
	union
	{
		struct{struct ExprNode *Left, *Right;}CaseOperator;
		struct{struct ExprNode *Child; FuncPtr MathFuncPtr;}CaseFunc;
		double CaseConst;
		double *CaseParmPtr;
	}Content;
};

extern void Clean();
extern void Sleep();
extern struct ExprNode* MakeExprNode(enum yytokentype opcode,...);
extern void DrawLoop(double Start,
					 double End,
					 double Step,
					 struct ExprNode *HorPtr,
					 struct ExprNode *VerPtr);
extern void DrawPixel(unsigned long x,
					  unsigned long y);
extern double GetExprValue(struct ExprNode *root);
extern int yyparse();

#endif

