header
{
	#include <math.h>
	using namespace antlr;
}
options
{
	language="Cpp";
}
/*---------------------------------------*/
/*					Parser				 */
/*---------------------------------------*/
class DrawParser extends Parser;
options
{
	k=3;
	buildAST = true;
}
tokens
{
	UNARY_MINUS;
}

prog: 
	(
		for_draw_stmt	|
		scale_stmt		|
		origin_stmt		|
		rot_stmt		|
		sleep_stmt		|
		bold_stmt		|
		color_stmt		|
		equ_stmt
	)*
	;
/*
 * Statements
 */
scale_stmt:
		SCALE^ IS!
		LPAREN! expr COMMA! expr RPAREN! SEMICO!
	;
origin_stmt:
		ORIGIN^ IS!
		LPAREN! expr COMMA! expr RPAREN! SEMICO!
	;
for_draw_stmt:
		FOR^ T! FROM! expr TO! expr STEP! expr
		DRAW!
		LPAREN! expr COMMA! expr RPAREN! SEMICO!
	;
rot_stmt:
		ROT^ IS! expr SEMICO!
	;
sleep_stmt:
		SLEEP^ expr SEMICO!
	;
bold_stmt:
		BOLD^ IS! expr SEMICO!
	;
equ_stmt:
		REG EQU^ expr SEMICO!
	;
color_stmt:
		COLOR^ IS! colors SEMICO!
	;
colors:
		( RED | GREEN | BLUE )
	;
/*
 * Exprs
 */
expr:
		term ((PLUS^|MINUS^)term)*
	; 

term:
		factor ((MUL^|DIV^)factor)*
	;

factor:
		component |
		( PLUS! | MINUS^ {
					  #MINUS->setType(UNARY_MINUS);
				  }
		)factor
		;

component:
			atom (POWER^ component)?
			;

atom:
		(NUM | PI | E | T | func_call
		| REG | LPAREN! expr RPAREN!)
	;

func_call:
			SIN^ LPAREN! expr RPAREN! |
			COS^ LPAREN! expr RPAREN! |
			TAN^ LPAREN! expr RPAREN! |
			EXP^ LPAREN! expr RPAREN! |
			LOG^ LPAREN! expr RPAREN! |
			SQRT^ LPAREN! expr RPAREN!
			;
/*----------------------------------------*/
/*					Lexer				  */
/*----------------------------------------*/
class DrawLexer extends Lexer;
options
{
	k=4;
	caseSensitive=false;
	caseSensitiveLiterals=false;
}

EQU:	'=';
SLEEP:	"sleep";
BOLD:	"bold";
COLOR:	"color";
RED:	"red";
GREEN:	"green";
BLUE:	"blue";

/*for convinent use 4 regs*/
REG: ('a'..'d');

ORIGIN:	"origin";
SCALE:	"scale";
ROT:	"rot";
FOR:	"for";
T:		"t";
DRAW:	"draw";
FROM:	"from";
STEP:	"step";
IS:		"is";
TO:		"to";

PLUS:	'+';
MINUS:	'-';
MUL:	'*';
DIV:	'/';
POWER:	"**";

SEMICO:	';';
LPAREN:	'(';
RPAREN:	')';
COMMA:	',';

PI:		pi";
E:		'e';

NUM: ('0'..'9')('0'..'9')*('.'('0'..'9')*)?;

SIN:	"sin";
COS:	"cos";
TAN:	"tan";
LOG:	"log";
EXP:	"exp";
SQRT:	"sqrt";

COMMENT:
		(
			"//"(~('\n'|'\r'))*
		|	"--"(~('\n'|'\r'))*
		|	"/*"
			(
				options{greedy=false;}
				:.{if(LA(1)=='\n') newline();}
			)*
			"*/"
		){ $setType(Token::SKIP); }
	;

WS:
	( ' '|'\t'|'\r'|'\n' {newline();} )
	{ $setType(Token::SKIP); }
	;
