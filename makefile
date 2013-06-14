default: in2post

y.tab.c y.tab.h: in2post.y
	bison -y -d in2post.y

lex.yy.c: in2post.l
	flex in2post.l

y.tab.o: y.tab.c
	gcc -c y.tab.c -o y.tab.o

lex.yy.o: lex.yy.c y.tab.h
	gcc -c lex.yy.c -o lex.yy.o

in2post: lex.yy.o y.tab.o y.tab.h
	gcc lex.yy.o y.tab.o -o in2post

clean:
	rm y.tab.c lex.yy.c y.tab.h y.tab.o lex.yy.o in2post
