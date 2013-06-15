%{
	#include "y.tab.h"
	
	void yyerror (char *);
%}
NUM ([1-9][0-9]*)|[0]
WSP [ \t]
%%
{NUM}	{ yylval.string = strdup(yytext); return T_LITERAL; }	/*We return the yylval as string to the Bison.*/
[\n]	{ return T_NL; }										/*For the rest Bison need only the token.*/
[(]		{ return T_LP; }
[)]		{ return T_RP; }
[+]		{ return T_PLUS; }
[-]		{ return T_MIN; }
[*]		{ return T_MUL; }
[/]		{ return T_DIV; }
{WSP}+	{ ; }													/*The whitespace is dropped*/
.		{ yyerror("Invalid character"); }						/*And we return an error if flex detect an invalid token*/
%%
int yywrap (void) {
	return 1; //we use stdin
}

