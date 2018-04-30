all : drexel-thesis.pdf drexel-thesis.cls example.pdf example-draft.pdf

drexel-thesis.pdf : drexel-thesis.dtx
	pdflatex $<
	makeindex drexel-thesis.glo -s gglo.ist -o drexel-thesis.gls
	pdflatex $<

drexel-thesis.cls template.tex example.tex example-draft.tex \
		example-1.tex example-a.tex example-ref.bib : \
		drexel-thesis.ins drexel-thesis.dtx
	pdflatex $<

example.pdf : example.tex example-1.tex example-a.tex example-ref.bib \
		drexel-thesis.cls
	#pdflatex -interaction=batchmode $<
	pdflatex $<
	bibtex example
	pdflatex $<
	pdflatex $<

example-draft.pdf : example-draft.tex example-1.tex example-a.tex \
		example-ref.bib drexel-thesis.cls
	pdflatex $<
	bibtex example-draft
	pdflatex $<
	pdflatex $<

temp-clean :
	rm -f *.aux *.log *.out *.lof *.lot *.toc \
                *.ilg *.glo *.gls *.idx *.ind \
		*.bbl *.blg *.dvi drexel-thesis

semi-clean : temp-clean
	rm -f *.bib *.tex

clean : semi-clean
	rm -f drexel-thesis.pdf example.pdf example-draft.pdf \
		drexel-thesis.cls drexel-thesis.tar.gz $(USEFUL_PACKAGES)

dist : drexel-thesis.tar.gz

CLASS_FILES = Makefile README drexel-thesis.dtx drexel-thesis.ins \
	drexel-thesis.cls drexel-thesis.pdf
EXAMPLE_FILES = template.tex example.tex example-draft.tex drexel-logo.pdf \
	example-1.tex example-a.tex example-ref.bib \
	example.pdf example-draft.pdf
EXTRA_FILES = contrib
USEFUL_PACKAGES = blindtext.sty draftmark.sty etextools.sty etoolbox.sty \
	floatrow.sty forloop.sty fr-subfig.sty lastpage.sty ltxnew.sty \
	pagerange.sty tocloft.sty xifthen.sty

drexel-thesis.tar.gz : $(CLASS_FILES) $(EXAMPLE_FILES) $(EXTRA_FILES) \
		$(USEFUL_PACKAGES)
	rm -f $@
	mkdir drexel-thesis
	cp -p $(CLASS_FILES) drexel-thesis/
	mkdir drexel-thesis/examples
	cp -p $(EXAMPLE_FILES) drexel-thesis/examples/
	cp -rp $(EXTRA_FILES) drexel-thesis/
	mkdir drexel-thesis/packages
	cp $(USEFUL_PACKAGES) drexel-thesis/packages/
	tar -chozf $@ drexel-thesis
	rm -rf drexel-thesis

$(USEFUL_PACKAGES) : % :
	cp $(shell kpsewhich $@) $@
