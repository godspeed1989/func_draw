#include "semantics.h"
#include <math.h>
#include <unistd.h>
#include <X11/Xlib.h>
#include <stdio.h>
//extern stuff
extern double Parameter,
			  start, end, step,
			  Origin_x, Origin_y,
			  Scale_x, Scale_y,
			  Rot_angle, Bold,
			  Sleep_len;
extern unsigned int LineNo;
extern Display* display;
extern Window window;
extern GC gc;
//inner functions(already declared in semantics.h)
void Clean();
void Sleep();
void DrawLoop(double Start,
			  double End,
			  double Step,
			  struct ExprNode *HorPtr,
			  struct ExprNode *VerPtr);
void DrawPixel(unsigned long x, unsigned long y);
double GetExprValue(struct ExprNode *root);

/*-----------------------------------------------*/
static void CalcCoord(struct ExprNode *Hor_Exp,
					  struct ExprNode *Ver_Exp,
					  double *Hor_x,
					  double *Ver_y)
{
	double HorCord, VerCord, Hor_tmp;

	HorCord = GetExprValue(Hor_Exp);
	VerCord = GetExprValue(Ver_Exp);
	
	HorCord *= Scale_x;
	VerCord *= Scale_y;
	
	Hor_tmp = HorCord*cos(Rot_angle) + VerCord* sin(Rot_angle);
	VerCord = VerCord*cos(Rot_angle) - HorCord* sin(Rot_angle);
	HorCord = Hor_tmp;

	HorCord += Origin_x;
	VerCord += Origin_y;

	*Hor_x = HorCord;
	*Ver_y = VerCord;
}

void Sleep()
{
	sleep(Sleep_len);
}

void Clean()
{
	XClearWindow(display, window);
}

void DrawLoop(double Start,
			  double End,
			  double Step,
			  struct ExprNode *HorPtr,
			  struct ExprNode *VerPtr)
{
	double x,y;
	for(Parameter=Start; Parameter<=End; Parameter+=Step)
	{
		CalcCoord(HorPtr, VerPtr, &x, &y);
		DrawPixel((unsigned long)x, (unsigned long)y);
	}
}

void DrawPixel(unsigned long x, unsigned long y)
{
	int i;
	//printf("draw:%ld--%ld\n",x,y);
	
	for(i=0 ; i<(Bold+1)/2 ; i++)
	{
		XDrawPoint(display, window, gc, x+i, y);
		XDrawPoint(display, window, gc, x, y+i);
		XDrawPoint(display, window, gc, x-i, y);
		XDrawPoint(display, window, gc, x, y-i);
	}
	XFlush(display);
}

double GetExprValue(struct ExprNode *root)
{
	if(root==NULL)
	{
		return 0.0;
	}
	switch(root->OpCode)
	{
		case PLUS:
			return GetExprValue(root->Content.CaseOperator.Left)+
				   GetExprValue(root->Content.CaseOperator.Right);
		case MINUS:
			return GetExprValue(root->Content.CaseOperator.Left)-
				   GetExprValue(root->Content.CaseOperator.Right);
		case MUL:
			return GetExprValue(root->Content.CaseOperator.Left)*
				   GetExprValue(root->Content.CaseOperator.Right);
		case DIV:
			return GetExprValue(root->Content.CaseOperator.Left)/
				   GetExprValue(root->Content.CaseOperator.Right);
		case POWER:
			return pow(GetExprValue(root->Content.CaseOperator.Left),
					 GetExprValue(root->Content.CaseOperator.Right));
		case FUNC:
			return (*root->Content.CaseFunc.MathFuncPtr)
				   ( GetExprValue(root->Content.CaseFunc.Child) );
		case CONST_ID:
			return root->Content.CaseConst;
		case T:
			return *(root->Content.CaseParmPtr);
		default:
			return 0.0;
	}
}

