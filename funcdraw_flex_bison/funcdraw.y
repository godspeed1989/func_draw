%{
#define YYSTYPE struct ExprNode *

#include <stdarg.h>
#include <stdio.h>
#include <X11/Xlib.h>
#include "semantics.h"

extern int yylex(void);
extern unsigned char* yytext;
extern unsigned int LineNo;
extern struct Token tokens;
extern Display* display;
extern GC gc;

double Parameter=0,
		start=0, end=0, step=0,
		Origin_x=0, Origin_y=0,
		Scale_x=1, Scale_y=1,
		Rot_angle=0, Bold=1,
		Sleep_len=0;
int Color;
void yyerror(const char* msg);
%}

%token ORIGIN SCALE ROT IS FOR FROM TO STEP DRAW T CONST_ID FUNC;
%token COMMA SEMICO L_BRACKET R_BRACKET SLEEP CLEAN BOLD ERRTOKEN;
%token COLOR RED BLACK BLUE
%left PLUS MINUS;
%left MUL DIV;
%right UNSUB;
%right POWER;
%start Program;

%%
Program:
	|Program Statement SEMICO
	;

Statement:
	FOR Expr FROM Expr TO Expr STEP Expr DRAW L_BRACKET Expr COMMA Expr R_BRACKET
	{
		start = GetExprValue($4);
		end = GetExprValue($6);
		step = GetExprValue($8);
		printf("Draw: start=%d; end=%d; step=%d;\n",(int)start,(int)end,(int)step);
		DrawLoop(start, end, step, $11, $13);
	}
	|ORIGIN IS L_BRACKET Expr COMMA Expr R_BRACKET
	{
		Origin_x = GetExprValue($4);
		Origin_y = GetExprValue($6);
		XSetClipOrigin(display, gc, (int)Origin_x, (int)Origin_y);
		printf("Origin(%d, %d)\n",(int)Origin_x,(int)Origin_y);
	}
	|SCALE IS L_BRACKET Expr COMMA Expr R_BRACKET
	{
		Scale_x = GetExprValue($4);
		Scale_y = GetExprValue($6);
		printf("Scale(%d, %d)\n",(int)Scale_x,(int)Scale_y);
	}
	|ROT IS Expr
	{
		Rot_angle = GetExprValue($3);
		printf("Rotate(%d)\n",(int)Rot_angle);
	}
	|BOLD IS Expr
	{
		Bold = GetExprValue($3);
	}
	|COLOR IS Colors
	{
		switch(Color)
		{
			case RED: printf("Color is red.\n"); break;
			case BLACK: printf("Color is black\n"); break;
			case BLUE: printf("Color is blue\n"); break;
			default: printf("Unkonw color\n"); break;
		}
	}
	|SLEEP Expr
	{
		Sleep_len = GetExprValue($2);
		printf("Sleep(%d)\n",(int)Sleep_len);
		Sleep();
	}
	|CLEAN
	{
		printf("Clean the scence.\n");
		Clean();
	}
	;

Colors:RED	 {  Color = RED;  }
	  |BLACK	{  Color = BLACK;  }
	  |BLUE	{  Color = BLUE;  }
	  ;

Expr:
	T					{ $$ = MakeExprNode(T); }
	|CONST_ID			{ $$ = MakeExprNode(CONST_ID, tokens.value); }
	|Expr PLUS Expr		{ $$ = MakeExprNode(PLUS, $1, $3); }
	|Expr MINUS Expr	{ $$ = MakeExprNode(MINUS, $1, $3); }
	|Expr MUL Expr		{ $$ = MakeExprNode(MUL, $1, $3); }
	|Expr DIV Expr		{ $$ = MakeExprNode(DIV, $1, $3); }
	|Expr POWER Expr	{ $$ = MakeExprNode(POWER, $1, $3); }
	|L_BRACKET Expr R_BRACKET		{ $$ = $2; }
	|PLUS Expr %prec UNSUB			{ $$ = $2; }
	|MINUS Expr %prec UNSUB
		{ $$ = MakeExprNode(MINUS,MakeExprNode(CONST_ID,0.0),$2); }
	|FUNC L_BRACKET Expr R_BRACKET
		{ $$ = MakeExprNode(FUNC, tokens.FuncPtr, $3); }
	|ERRTOKEN
		{ yyerror("error token in input\n"); }
	;
%%

void yyerror(const char* msg)
{
	printf("yyerror(): Line %d '%s'\n", LineNo, yytext);
}

struct ExprNode* MakeExprNode(enum yytokentype opcode,...)
{
	va_list ArgPtr;
	struct ExprNode* ExprPtr = malloc(sizeof(struct ExprNode));
	ExprPtr->OpCode = opcode;
	va_start(ArgPtr, opcode);
	switch(opcode)
	{
		case CONST_ID:
			ExprPtr->Content.CaseConst
				 = (double)va_arg(ArgPtr,double);
			break;
		case T:
			ExprPtr->Content.CaseParmPtr = &Parameter;
			break;
		case FUNC:
			ExprPtr->Content.CaseFunc.MathFuncPtr
				 = (FuncPtr)va_arg(ArgPtr,FuncPtr);
			ExprPtr->Content.CaseFunc.Child
				 = (struct ExprNode *)va_arg(ArgPtr, struct ExprNode *);
			break;
		default:
			ExprPtr->Content.CaseOperator.Left
				 = (struct ExprNode *)va_arg(ArgPtr, struct ExprNode *);
			ExprPtr->Content.CaseOperator.Right
				 = (struct ExprNode *)va_arg(ArgPtr, struct ExprNode *);
			break;
	}
	va_end(ArgPtr);
	return ExprPtr;
}

