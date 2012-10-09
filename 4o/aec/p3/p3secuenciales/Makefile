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

p3c: practica3c.c
	gcc -march=athlon64 -o p3c practica3c.c -lm

clean:
	-rm *~ p3a p3b p3c


