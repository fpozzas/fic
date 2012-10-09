default | all:
	yacc -d parser.y
	lex escaner.l
	gcc -o aventura y.tab.c lex.yy.c -ly -ll -g
clean:
	-rm *~ p6 y.tab.h lex.yy.c y.tab.c y.output aventura
