#ifndef SEMANTICS_H
#define SEMANTICS_H

#include <X11/Xlib.h>

extern double T_val;
extern double rot, scale_x, scale_y;
extern double origin_x, origin_y;
extern int bold, colour;
extern double regs[26];
extern int reg_idx;

void DrawPixel(double x, double y);
void Sleep(int len);

extern Display* display;
extern Window window;
extern GC gc;
extern unsigned int width;
extern unsigned int height;

#endif
