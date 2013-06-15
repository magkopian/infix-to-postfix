#include "stack.h"

/*The stack pointer points to the position that the next element will be pushed*/
int sp = 0;

/*
* Pushes an integer to the stack.
* In case of stack overflow it returns -1 otherwise 0.
*/
int push (int element) {
	if (sp == STACK_SZ) return -1; //in case of stack overflow
	
	stack[sp++] = element; //else push the element
	return 0;
}

/*
* Pops an integer from the stack.
* If the stack is empty it returns -1 otherwise the popped element.
*/
int pop (int *element) {
	if (sp == 0) return -1; //in case of empty stack
	
	*element = stack[--sp]; //else pop the element
	return 0;
}








