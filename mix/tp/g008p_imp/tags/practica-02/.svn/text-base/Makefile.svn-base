CAMLC=ocamlc
CAMLLEX=ocamllex
CAMLYACC=ocamlyacc
CAMLDEP=ocamldep
CAMLDOC=ocamldoc

# Directorio donde se encuentra la librería oUnit
OUNIT_LIB=~/lib/ounit-1.0.2
DOC_DIR=doc-imp

OBJS_TEST=tipos.cmo lexer.cmo parser.cmo lector.cmo env.cmo eval.cmo
OBJS=$(OBJS_TEST) main.cmo

SRC_DOC=tipos.ml lector.ml env.ml eval.ml main.ml


all: imp 


imp : $(OBJS)
	$(CAMLC) -o $@ $(OBJS)
	
tests: $(OBJS) tests.ml
	$(CAMLC) -o tests  -I $(OUNIT_LIB) $(OBJS_TEST) unix.cma oUnit.cma tests.ml

doc: $(OBJS)
	if [ ! -d $(DOC_DIR) ]; then mkdir $(DOC_DIR); fi
	$(CAMLDOC) -html -all-params -t "Intérprete IMP" -d $(DOC_DIR) $(SRC_DOC) 

%.ml %.mli : %.mly
	$(CAMLYACC) $<

%.ml : %.mll
	$(CAMLLEX) $<

%.cmi : %.mli
	$(CAMLC) -c $<

%.cmo : %.ml
	$(CAMLC) -c $<
	
depend :  $(OBJS:.cmo=.ml)
	$(CAMLDEP) $(OBJS:.cmo=.ml) *.mli > .depend

clean :
	rm -rf imp tests *.cmi *.cmo parser.ml parser.mli lexer.ml $(DOC_DIR) *% *~ 

# dependencias

ifeq (.depend,$(wildcard .depend))
include .depend
endif
