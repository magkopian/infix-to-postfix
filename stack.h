/***************************************************************\
*                                                               *
* Copyright (c) 2013 Manolis Agkopian                           *
* See the file LICENCE for copying permission.                  *
*                                                               *
\***************************************************************/

#ifndef STACK_H
#define STACK_H

#define STACK_SZ 1000

/*
* Pushes an integer to the stack.
* In case of stack overflow it returns -1 otherwise 0.
*/
int push (int element);

/*
* Pops an integer from the stack.
* In case of stack underflow it returns -1 otherwise 0.
*/
int pop (int *element);

/*The stack pointer points to the position that the next element will be pushed*/
extern int sp;

/*The stack itself*/
int stack[STACK_SZ];

#endif /*STACK_H*/
