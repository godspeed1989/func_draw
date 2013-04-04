header{
	#include "semantics.hpp"
	#include <math.h>
	#include <stdio.h>
	#include <stdlib.h>
	using namespace antlr;
}
options{
	language="Cpp";
}
/*----------------------------------------*/
/*				Tree Parser				  */
/*----------------------------------------*/
class DrawTreeWalker extends TreeParser;
options{
	importVocab = DrawParser;
}

progTree:
		(
			for_draw_stmtTree	|
			origin_stmtTree		|
			scale_stmtTree		|
			rot_stmtTree		|
			sleep_stmtTree		|
			bold_stmtTree		|
			color_stmtTree		|
			equ_stmtTree
		)*
	;
/*
 * Statement Trees
 */
origin_stmtTree:
	#(ORIGIN origin_x=exprTree
			 origin_y=exprTree)
	{
		printf("set origin (%.3lf,%.3lf)\n",
				origin_x, origin_y);
	}
	;
scale_stmtTree:
	#(SCALE scale_x=exprTree
			scale_y=exprTree)
	{
		if(scale_x>0&&scale_y>0)
			printf("set scale (%.3lf,%.3lf)\n",
					scale_x, scale_y);
		else
			printf("!!!scale must be positive.\n");
	}
	;
rot_stmtTree:
	#(ROT rot=exprTree)
	{
		printf("set rot %lf\n", rot);
	}
	;
sleep_stmtTree
	{double length=0;}
	:
	#(SLEEP length=exprTree)
	{
		int len = (int)length;
		printf("sleep %d second(s)\n", len);
		Sleep(len);
	}
	;
bold_stmtTree
	{double temp=0;}
	:
	#(BOLD temp=exprTree)
	{
		bold = (int)temp;
		printf("set bold %d\n", bold);
	}
	;
for_draw_stmtTree
	{double begin=0,end=0,step=0;T_val=0;}
	:
	#(FOR begin=exprTree
			end=exprTree
			step=exprTree
			px : exprTree
			py : exprTree)
	{
		printf("Draw from %lf to %lf step %lf\n",
				begin, end, step);
		if( (begin<end && step>0) ||
			(begin>end && step<0) )
		{
			T_val=begin;
			while(T_val<=end)
			{
				double x,y,t;
				x = exprTree(RefAST(#px));
				y = exprTree(RefAST(#py));
				x*=scale_x; y*=scale_y;
				t = x*cos(rot)+y*sin(rot);
				y = y*cos(rot)-x*sin(rot);
				x = t;
				x+=origin_x; y+=origin_y;
				DrawPixel(x,y);
				T_val+=step;
			}
		}
		else
		{
			printf("!!!'FOR' stmt error.Abort.\n");
		}
	}
	;
equ_stmtTree
	{double temp_idx=0,temp=0;}
	:
	/*REG EQU^ expr SEMICO!*/
	#(EQU temp=exprTree {temp_idx=reg_idx;} temp=exprTree)
	{
		reg_idx = temp_idx;
		regs[reg_idx] = temp;
		printf("%c = %.3lf\n", 'a'+reg_idx, temp);
	}
	;
color_stmtTree
	{colour=0;}
	:
	#(COLOR colour=colorsTree)
	{
		printf("set color ");
		switch(colour)
		{
			case RED:   printf("red\n");	 break;
			case GREEN: printf("green\n");   break;
			case BLUE:  printf("blue\n");	break;
			default:	printf("unknown\n"); break;
		}
	}
	;
colorsTree returns [int value=0]
	:
	  RED	 { value=RED;   }
	| GREEN   { value=GREEN; }
	| BLUE	{ value=BLUE;  }
	;
/*
 * Exprs
 */
exprTree returns [double value=0]
	{double e1=0,e2=0;}
	:
	  #(PLUS e1=exprTree e2=exprTree)
		{ value = e1+e2; }
	| #(MINUS e1=exprTree e2=exprTree)
		{ value = e1-e2; }
	| #(MUL e1=exprTree e2=exprTree)
		{ value = e1*e2; }
	| #(DIV e1=exprTree e2=exprTree)
		{
			if(e2>1e-10)
				value = e1/e2;
			else
			{
				printf("!!!Div error.exit.\n");
				exit(-1);
			}
		}
	| #(UNARY_MINUS e1=exprTree)
		{ value = -e1; }
	| i:NUM
		{ value = atof(i->getText().c_str()); }
	| PI
		{ value = 3.14159; }
	| E
		{ value = 2.71828; }
	| T
		{ value = T_val; }
	| #(SIN e1=exprTree)
		{ value = sin(e1); }
	| #(COS e1=exprTree)
		{ value = cos(e1); }
	| #(TAN e1=exprTree)
		{ value = tan(e1); }
	| #(EXP e1=exprTree)
		{ value = exp(e1); }
	| #(LOG e1=exprTree)
		{ value = log(e1); }
	| #(POWER e1=exprTree e2=exprTree)
		{ value = pow(e1,e2); }
	| s:REG
	{
		reg_idx = s->getText().c_str()[0]-'a';
		value = regs[reg_idx];
	}
	;

termTree:
		;

factorTree:
			#(UNARY_MINUS factorTree)
			| componentTree
			;

componentTree:
			#(POWER componentTree)
			| atomTree
			;

atomTree:
		;

func_callTree:
			 ;

