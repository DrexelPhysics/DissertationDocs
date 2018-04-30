all:
	pdflatex thesis.tex
	bibtex thesis.aux
	latexmk thesis.tex
	#pdflatex thesis.tex

OS := $(shell uname)
view:
ifeq ($(OS),Darwin)
		open thesis.pdf
else
		evince thesis.pdf
endif

cleanext = ~ .out .log .toc .aux .log .lof .bbl .blg .fls .fdb_latexmk .lot

clean:
	$(foreach x,$(cleanext),find . -name '*$(x)' | xargs -I {} rm -vf {};)
