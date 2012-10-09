default | all:
	yacc -d p6.y
	lex p6.l
	gcc -o p6 y.tab.c lex.yy.c -ly -ll
clean:
	-rm *~ p6 y.tab.h lex.yy.c y.tab.c
