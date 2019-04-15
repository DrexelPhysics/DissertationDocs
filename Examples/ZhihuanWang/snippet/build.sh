#!/bin/sh

pdflatex -shell-escape root &&
if [ -f bu1.aux ]; then
	for AUXFILE in bu[0-9]*.aux; do
		bibtex $(basename "${AUXFILE}" .aux);
	done;
fi &&
bibtex root &&
makeindex root.nlo -s nomencl.ist -o root.nls &&
./figures/asy/build-asy.py figures/scratch/ &&
pdflatex -shell-escape root &&
bibtex root &&
pdflatex -shell-escape root &&
pdflatex -shell-escape root &&
pdflatex -shell-escape root
