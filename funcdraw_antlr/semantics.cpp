#include "semantics.hpp"
#include <stdio.h>
#include <unistd.h>

double T_val;
double rot, scale_x, scale_y;
double origin_x, origin_y;
double regs[26];
int reg_idx;
int bold, colour;

bool chk_pt(long x, long y)
{
	if(x<=width&&y<=height)
		return true;
	else
	{
		printf("Point out of bound.\n");
		return false;
	}
}
void DrawPixel(double x, double y)
{
	long _x = (long)x;
	long _y = (long)y;
	//printf("(%ld,%ld) ", _x, _y);
	for(int i=0 ; i<bold ; i++)
	{
		if(chk_pt(_x+i,_y))XDrawPoint(display,window,gc,_x+i,_y);
		if(chk_pt(_x,_y+i))XDrawPoint(display,window,gc,_x,_y+i);
		if(chk_pt(_x-i,_y))XDrawPoint(display,window,gc,_x-i,_y);
		if(chk_pt(_x-i,_y))XDrawPoint(display,window,gc,_x,_y-i);
	}
	XFlush(display);
}

void Sleep(int len)
{
	sleep(len);
}

