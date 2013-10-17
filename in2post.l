%{
	/***************************************************************\
	*                                                               *
	* Copyright (c) 2013 Manolis Agkopian                           *
	* See the file LICENCE for copying permission.                  *
	*                                                               *
	\***************************************************************/

	#include "y.tab.h"
	
	void yyerror (char *);
	
	extern int tmpptr_i;
	extern char **tmpptr;
%}

NUM ([1-9][0-9]*)|[0]
WSP [ \t]
%%
{NUM}	{ 
		
		if ((yylval.string = strdup(yytext)) == NULL) {			/*We return the yylval as string to the Bison.*/
			perror("yyparse: realloc");
			exit(1);
		}
		
		tmpptr = realloc( tmpptr, sizeof(char *) * (tmpptr_i + 1) );
		if (tmpptr == NULL) {
			perror("yyparse: realloc");
			exit(1);
		}
	
		tmpptr[tmpptr_i++] = yylval.string;

		return T_LITERAL;
		
}
[\n]	{ return T_NL; }										/*For the rest Bison need only the token.*/
[(]		{ return T_LP; }
[)]		{ return T_RP; }
[+]		{ return T_PLUS; }
[-]		{ return T_MIN; }
[*]		{ return T_MUL; }
[/]		{ return T_DIV; }
[%]		{ return T_MOD; }
[\^]		{ return T_POW; }
{WSP}+	{ ; }													/*The whitespace is dropped*/
.		{ 														/*And we return an error if flex detect an invalid token*/
		char itk[20];
		sprintf(itk, "invalid character `%c`", yytext[0]);
		yyerror(itk);
}
%%
int yywrap (void) {
	return 1; //we use stdin
}

