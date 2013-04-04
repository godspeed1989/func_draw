%{
	#include <math.h>
	#include <stdlib.h>
	#include "semantics.h"
	#include "funcdraw.tab.h"
	unsigned int LineNo;
	struct Token tokens;
%}

%x comment_entry c_comment_entry

name		[a-z]([_]?[a-z0-9])*
number		[0-9]+
ws			[\t]+
newline		\n
comments	"//"|"--"
c_comments	"/*"

%%

{comments}		BEGIN comment_entry;
{c_comments}	  BEGIN c_comment_entry;
{ws}			  ;
{newline}		 LineNo++;

"origin"|"原点"		return ORIGIN;
"scale"|"横纵比例"	return SCALE;
"rot"|"旋转角度"		return ROT;
"is"|"是"			return IS;
"for"|"令"			return FOR;
"from"|"自"			return FROM;
"to"|"至"			return TO;
"step"|"步长"		return STEP;
"draw"|"绘制"		return DRAW;
"sleep"|"等"			return SLEEP;
"clean"|"清屏"		return CLEAN;
"bold"|"笔画"		return BOLD;
"color"|"颜色"		return COLOR;
"red"|"红"			return RED;
"black"|"黑"			return BLACK;
"blue"|"蓝"			return BLUE;
"t"					return T;

"pi"	tokens.type=CONST_ID; tokens.value=3.14159; return CONST_ID;
"e"		tokens.type=CONST_ID; tokens.value=2.71928; return CONST_ID;

"sin"	tokens.type=FUNC; tokens.FuncPtr=sin;  return FUNC;
"cos"	tokens.type=FUNC; tokens.FuncPtr=cos;  return FUNC;
"tan"	tokens.type=FUNC; tokens.FuncPtr=tan;  return FUNC;
"exp"	tokens.type=FUNC; tokens.FuncPtr=exp;  return FUNC;
"ln"	tokens.type=FUNC; tokens.FuncPtr=log;  return FUNC;
"sqrt"	tokens.type=FUNC; tokens.FuncPtr=sqrt; return FUNC;

"+"		return PLUS;
"-"		return MINUS;
"*"		return MUL;
"/"		return DIV;
","		return COMMA;
";"		return SEMICO;
"("		return L_BRACKET;
")"		return R_BRACKET;
"**"	return POWER;

{number}(\.{number}+)? {
	tokens.value = atof(yytext);
	tokens.type = CONST_ID;
	return CONST_ID;
}

{name}		return ERRTOKEN;
(\32)+		;

<comment_entry>.		;
<comment_entry>\n		BEGIN 0; LineNo++;

<c_comment_entry>.		;
<c_comment_entry>"*/"	BEGIN 0;
<c_comment_entry>\n		LineNo++;

%%

#include <stdio.h>
int yywrap()
{
	printf("In yywrap.\n");
	return 1;
}

