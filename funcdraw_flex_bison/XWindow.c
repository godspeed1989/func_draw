#include <X11/Xlib.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

Display* display;
Window window;
GC gc;

Window create_simple_window(Display* display,
							int width, int height,
							int x, int y)
{
	int screen_num = DefaultScreen(display);
	int win_border_width = 5;
	Window win;

	win = XCreateSimpleWindow(display, RootWindow(display,screen_num),
							  x, y, width, height, win_border_width,
							  WhitePixel(display, screen_num),
							  BlackPixel(display, screen_num));

	XMapWindow(display, win);
	XFlush(display);
	return win;
}

GC create_GC(Display* display, Window win, int reverse_video)
{
	GC gc;
	unsigned long valuemask = 0;
	XGCValues values;
	int screen_num = DefaultScreen(display);

	gc = XCreateGC(display, win, valuemask, &values);
	if(gc < 0)
	{
		fprintf(stderr, "XCreateGC Error\n");
	}
	else 
	{
		XSetForeground(display, gc, WhitePixel(display,screen_num));
		XSetBackground(display, gc, BlackPixel(display,screen_num));
	}
	
	unsigned int line_width = 2;
	int line_style = LineSolid;
	int cap_style = CapButt;
	int join_style = JoinBevel;
	XSetLineAttributes(display, gc, line_width,
					   line_style, cap_style, join_style);

	XSetFillStyle(display, gc, FillSolid);

	return gc;
}

extern void init_XWindow()
{
	char* display_name = getenv("DISPLAY");
	display = XOpenDisplay(display_name);
	if(display == NULL)
	{
		fprintf(stderr, "%d can't connnect to X server '%s'\n",
				getpid(), display_name);
		exit(-1);
	}
	int display_screen_num = DefaultScreen(display);
	unsigned int display_width = DisplayWidth(display, display_screen_num);
	unsigned int display_height = DisplayHeight(display, display_screen_num);
	unsigned int width = (display_width/3);
	unsigned int height = (display_height/3);
  
	window = create_simple_window(display, width, height, 50, 50);
	gc = create_GC(display, window, 0);
	
	XSync(display, True);
}

extern void close_XWindow()
{
	XFreeGC(display, gc);
	XCloseDisplay(display);
}

