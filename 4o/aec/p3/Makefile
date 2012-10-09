default:
	@echo "Uso:"
	@echo "   p3a:      Comprimido con double"
	@echo "   p3b:      Comprimido con float"
	@echo "   p3c:      Comprimido con float"
	@echo "   clean:   Borrar ficheros ejecutables y temporales"

p3a: practica3a.c
	gcc -march=athlon64 -o p3a practica3a.c -lm

p3b: practica3b.c
	gcc -march=athlon64 -o p3b practica3b.c -lm

p3c1: practica3c1.c
	gcc -march=athlon64 -o p3c1 practica3c1.c -lm
p3c2: practica3c2.c
	gcc -march=athlon64 -o p3c2 practica3c2.c -lm
clean:
	-rm *~ p3a p3b p3c1 p3c2


