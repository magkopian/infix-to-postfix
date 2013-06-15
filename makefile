CC = gcc
LEX = flex
YACC = bison
OBJ = lex.yy.o y.tab.o stack.o

default: in2post

stack.o: stack.c stack.h
	$(CC) -c stack.c -o stack.o
	
y.tab.c y.tab.h: in2post.y
	$(YACC) -y -d in2post.y

lex.yy.c: in2post.l
	$(LEX) in2post.l

y.tab.o: y.tab.c
	$(CC) -c y.tab.c -o y.tab.o

lex.yy.o: lex.yy.c y.tab.h
	$(CC) -c lex.yy.c -o lex.yy.o

in2post: $(OBJ) y.tab.h stack.h
	$(CC) $(OBJ) -o in2post

clean:
	rm y.tab.c lex.yy.c y.tab.h $(OBJ) in2post
