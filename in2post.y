%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	
	int yylex (void);
	void yyerror (char *);
	void clean_up (void); //we register this function with atexit to be executed at the end, and free up the memmory we allocated
	
	char tmp[4096]; //we place here the result of each action until we allocate memory for $$
	char **tmpptr; //we keep here the tmp pointer to free them at the end, it is used by the clean_up function
	int tmpptr_i = 0; //tmpptr counter
%}

%token T_NL T_LP T_RP T_PLUS T_MIN T_MUL T_DIV

%union { //we need the numbers to return as string from flex
	char *string;
}

%token <string> T_LITERAL

%type <string> expr
%type <string> term
%type <string> fact
%%
program:						/* (5) The Root*/
/*NULL*/						/*The complete program is either empty or,*/

| program line					/*a complete program is a complete program folowed by a line*/
;


line:							/* (4) */
  T_NL							/*Then, a program line can be just a new line character,*/
  
| expr T_NL	{ 					/*or an expression that end with a new line character.*/
	printf("%s\n", $1);
}
;


expr:																	/* (3) */
  term																	/*Then, an expression can be just a term,*/
  
| expr T_PLUS term {													/*or an other expression followed by a '+' sign and a term*/
	sprintf(tmp, "%s %s +", $1, $3);
	
	if (($$ = strdup(tmp)) == NULL) { //allocate memmory for the $$ string
		perror("yyparse: realloc");
		exit(1);
	}
	
	tmpptr = realloc( tmpptr, sizeof(char *) * (tmpptr_i + 1) ); //resize the table with the tmp pointers
	if (tmpptr == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	tmpptr[tmpptr_i++] = $$; //register the new pointer to the table
}
	
| expr T_MIN term {														/*or an other expression followed by a '-' sign and a term.*/
	sprintf(tmp, "%s %s -", $1, $3);
	
	if (($$ = strdup(tmp)) == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	tmpptr  = realloc( tmpptr, sizeof(char *) * (tmpptr_i + 1) );
	if (tmpptr == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	tmpptr[tmpptr_i++] = $$;
}
;


term:																	/* (2) */
  fact																	/*Then, a term can be just a factor,*/
  
| term T_MUL fact {														/*or an other term followed by a '*' sign and a factor,*/
	sprintf(tmp, "%s %s *", $1, $3);
	
	if (($$ = strdup(tmp)) == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	tmpptr = realloc( tmpptr, sizeof(char *) * (tmpptr_i + 1) );
	if (tmpptr == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	tmpptr[tmpptr_i++] = $$;
}
  
| term T_DIV fact {														/*or an other term followed by a '/' sign and a factor.*/
	sprintf(tmp, "%s %s /", $1, $3); 
	
	if (($$ = strdup(tmp)) == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
  
	tmpptr = realloc( tmpptr, sizeof(char *) * (tmpptr_i + 1) );
	if (tmpptr == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	tmpptr[tmpptr_i++] = $$;
}
;


fact:																	/* (1) */
  T_LITERAL																/*A factor can be a literal,*/
  
| T_LP expr T_RP {														/*or a '(' symbol followed by an expression and a ')' symbol.*/
	sprintf(tmp, "%s", $2);
	
	if (($$ = strdup(tmp)) == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	tmpptr = realloc( tmpptr, sizeof(char *) * (tmpptr_i + 1) );
	if (tmpptr == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	tmpptr[tmpptr_i++] = $$;
}
;

%%
int main (void) {	
	if (atexit(clean_up) != 0) { //register the clean_up function
		fprintf(stderr, "error while setting exit function\n");
		exit(1);
	}
	
	yyparse(); //call the parser
	
	return 0;
}

void yyerror (char *s) {
	fprintf(stderr, "%s\n", s);
}

void clean_up (void) {
	int i;

	for (i = 0; i < tmpptr_i; ++i) {
		free(tmpptr[i]);
	}
	free(tmpptr);
}
