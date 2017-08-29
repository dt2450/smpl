TARFILES = Makefile scanner.mll parser.mly ast.mli printast.ml semantic_checker.ml compile.ml smpl.ml

OBJS = ast.cmo parser.cmo scanner.cmo printast.cmo semantic_checker.cmo compile.cmo smplc.cmo

smplc : $(OBJS)
	ocamlc str.cma -o smplc $(OBJS)

scanner.ml : scanner.mll
	ocamllex scanner.mll

parser.ml parser.mli : parser.mly
	ocamlyacc parser.mly

%.cmi : %.mli
	ocamlc -c $<

%.cmo : %.ml
	ocamlc -c $<

smplcompiler.tar.gz : $(TARFILES)
	cd .. && tar zcf smplcompiler/smplcompiler.tar.gz $(TARFILES:%=smplcompiler/%)

.PHONY : clean
clean :
	rm -f smplc parser.ml parser.mli scanner.ml *.cmo *.cmi

# Generated by ocamldep *.ml *.mli
ast.cmo:
ast.cmx:
compile.cmo: semantic_checker.cmo ast.cmo
compile.cmx: semantic_checker.cmx ast.cmx
parser.cmo: ast.cmo parser.cmi
parser.cmx: ast.cmx parser.cmi
printast.cmo: ast.cmo
printast.cmx: ast.cmx
scanner.cmo: parser.cmi
scanner.cmx: parser.cmx
semantic_checker.cmo: ast.cmo
semantic_checker.cmx: ast.cmx
smplc.cmo: semantic_checker.cmo scanner.cmo printast.cmo parser.cmi \
    compile.cmo
smplc.cmx: semantic_checker.cmx scanner.cmx printast.cmx parser.cmx \
    compile.cmx
parser.cmi: ast.cmo
