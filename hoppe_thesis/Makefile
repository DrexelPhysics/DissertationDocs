all:
	pdflatex thesis.tex
	bibtex thesis.aux
	pdflatex thesis.tex
	pdflatex thesis.tex

view:
	evince thesis.pdf


cleanext = ~ .out .log .toc .aux .log .lof .bbl .blg

clean:
	$(foreach x,$(cleanext),find . -name *$(x) | xargs -I {} rm -vf {};)
	rm -vf thesis.pdf
