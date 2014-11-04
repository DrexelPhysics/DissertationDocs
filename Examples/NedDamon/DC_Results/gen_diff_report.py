#!/usr/bin/python
from subprocess import *
from os import system
from sys import argv

try:
    N = int(argv[1])
except:
    print "gen_diff_report.py [revsions back]"
    exit()

def one_line(cmd):
    output = Popen([cmd], stdout=PIPE, shell=True)
    return [x.strip() for x in output.stdout][0]

change_n = N
id = int(one_line("hg id -n").replace('+',''))

#tmpdir = ''
#system('mkdir %s' % tmpdir)
system('rm diff_report.pdf')
system('cp report.tex __tmp_report.tex')
system('hg revert -r %s report.tex' % (id-change_n))
system('latexdiff report.tex __tmp_report.tex > diff_report.tex')
exit()
#system('mv __tmp_report.tex report.tex')

# Add version numbers to diff_report
W = ''.join([f for f in open("diff_report.tex",'r')])
W = W.split('\\title')

preamble = W[0]
title = W[1].split('}')[0]
body  = W[1].split('}')[1:]
title = '%s [Revisions $%s \\rightarrow %s$]' % (title, id-change_n, id)
title  = '\\title'+title+'}'
body   = ''.join('%s}'%x for x in body)
W = ''.join([preamble,title,body])

FOUT = open('diff_report.tex','w')
FOUT.write(W)
FOUT.close()

system('pdflatex diff_report.tex -interaction=batchmode')
system('bibtex diff_report.aux')
system('pdflatex diff_report.tex -interaction=batchmode')
system('pdflatex diff_report.tex -interaction=batchmode')
#system('rm diff_report.log diff_report.aux report.tex.orig diff_reportNotes.bib diff_report.tex')
system('xpdf diff_report.pdf')



