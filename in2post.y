%{
	/***************************************************************\
	*                                                               *
	* Copyright (c) 2013 Manolis Agkopian                           *
	* See the file LICENCE for copying permission.                  *
	*                                                               *
	\***************************************************************/

	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <errno.h>
	#include <math.h>
	#include "stack.h"
	
	#define isdigit(c) ((c >= '0' && c <= '9') ? 1 : 0)
	
	int yylex (void);
	void yyerror (char *);
	int calculate_postfix (char *postfix); //calculates and returns the result of a postfix expression
	void clean_up (void); //we register this function with atexit to be executed at the end, and free up the memmory we allocated
	
	char tmp[4096]; //we place here the result of each action until we allocate memory for $$
	char **tmpptr; //we keep here the tmp pointer to free them at the end, it is used by the clean_up function
	int tmpptr_i = 0; //tmpptr counter
	
	extern FILE *yyin;
%}

%token T_NL T_LP T_RP T_PLUS T_MIN T_MUL T_DIV T_MOD T_POW

%union { //we need the numbers to return as string from flex
	char *string;
}

%token <string> T_LITERAL

%type <string> expr
%type <string> term
%type <string> efact
%type <string> fact
%%
program:									/* (6) The Root*/
/*NULL*/									/*The complete program is either empty or,*/

| program line								/*a complete program is a complete program folowed by a line*/
;


line:										/* (5) */
  T_NL										/*Then, a program line can be just a new line character,*/
  
| expr T_NL	{ 								/*or an expression that end with a new line character.*/
	int res = 0;
	
	res = calculate_postfix($1);
	if (res == -1 && errno == EDOM) { //if division by zero occurred
		fprintf(stderr, "Error: Division by zero\n");
		printf("%s the result is undefined\n", $1);
	}
	else {
		printf("%s is equal to %d\n", $1, res);
	}
}
;


expr:										/* (4) */
  term										/*Then, an expression can be just a term,*/
  
| expr T_PLUS term {						/*or an other expression followed by a '+' sign and a term*/
	sprintf(tmp, "%s %s +", $1, $3);
	
	//allocate memmory for the $$ string
	if (($$ = strdup(tmp)) == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	//resize the table with the tmp pointers
	tmpptr = realloc( tmpptr, sizeof(char *) * (tmpptr_i + 1) );
	if (tmpptr == NULL) {
		perror("yyparse: realloc");
		exit(1);
	}
	
	//register the new pointer to the table
	tmpptr[tmpptr_i++] = $$;
}
	
| expr T_MIN term {							/*or an other expression followed by a '-' sign and a term.*/
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


term:											/* (3) */
  efact											/*Then, a term can be just a expfactor,*/
  
| term T_MUL efact {							/*or an other term followed by a '*' sign and a expfactor,*/
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
  
| term T_DIV efact {							/*or an other term followed by a '/' sign and a expfactor.*/
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

| term T_MOD efact {							/*or an other term followed by a '%' sign and a expfactor.*/
	sprintf(tmp, "%s %s %%", $1, $3); 
	
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

efact:											/* (2) */
  fact											/*Then, an expfactor can be just a factor,*/
  
| efact T_POW fact {							/*or an other expfactor followed by a '^' sign and a factor.*/
	sprintf(tmp, "%s %s ^", $1, $3); 
	
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

fact:										/* (1) */
  T_LITERAL									/*A factor can be a literal,*/
  
| T_LP expr T_RP {							/*or a '(' symbol followed by an expression and a ')' symbol.*/
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
int main (int argc, char **argv) {
	FILE *fp;

	//register the clean_up function
	if (atexit(clean_up) != 0) {
		fprintf(stderr, "error while setting exit function\n");
		return 1;
	}
	
	if (argc == 2) { //if user provides a file use this as input
		if ((fp = fopen(argv[1], "r")) == NULL) {
			perror(argv[0]);
			return 1;
		}
		yyin = fp;
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
	
	if (yyin != stdin) {
		close(yyin);
	}
}

int calculate_postfix (char *postfix) {
	int i, k, a, b;
	char num_buf[100]; //just to prevent segmentation faults from bad usage (max unsigned int is just 10 digits long)

	errno = 0; //clear errno
	for (i = 0, k = 0; postfix[i] != '\0'; ++i) {
		if (isdigit(postfix[i])) {
			num_buf[k++] = postfix[i]; //extract the digits of a number
		}
		else if (isdigit(postfix[i-1]) && postfix[i] == ' ') { //if finished reading the number
			num_buf[k] = '\0';
			if (push(atoi(num_buf)) == -1) { //push it then to the stack
				return -1; //stack overflow!
			}
			
			k = 0;
		}
		else if (postfix[i] != ' ') { //then we have an operator
			if (pop(&b) == -1) {
				return -1; //stack underflow!
			}
			else if (pop(&a) == -1) {
				return -1; //stack underflow!
			}
			
			switch (postfix[i]) {
				case '+':
					if (push(a+b) == -1) {
						return -1; //stack overflow!
					}			
					break;
				case '-':
					if (push(a-b) == -1) {
						return -1; //stack overflow!
					}		
					break;
				case '*':
					if (push(a*b) == -1) {
						return -1; //stack overflow!
					}			
					break;
				case '/':
					if (b == 0) { //division by zero
						errno = EDOM; //set errno
						return -1;
					}
				
					if (push(a/b) == -1) {
						return -1; //stack overflow!
					}		
					break;
				case '%':
					if (b == 0) { //division by zero
						errno = EDOM; //set errno
						return -1;
					}
				
					if (push(a%b) == -1) {
						return -1; //stack overflow!
					}		
					break;
				case '^':
					if (push( (int) pow(a, b)) == -1) {
						return -1; //stack overflow!
					}			
					break;
			}
		}
		
		//else postfix[i-1] is an operator && postfix[i] == ' ' so we continue
	}

	if (pop(&a) == -1) {
		return -1; //stack underflow!
	}
	return a; //return the result
}





