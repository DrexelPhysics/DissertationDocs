from tempfile import mkdtemp
from os import system, chdir, getcwd
from glob import *
from sys import argv

try:
    FIN = open(argv[1],'r')
except:
    print "blocktext.py [input textfile] [font]"
    exit()

text = [x.strip() for x in FIN]
odir = getcwd()
fontname = "palatino"
quiet = ["", "1>/dev/null"][0]

raw = r'''
\batchmode
\documentclass{article}
\usepackage{%s}
\usepackage{graphicx}
\usepackage[paperwidth=\maxdimen,paperheight=\maxdimen]{geometry}
\usepackage[active,tightpage,pdftex,floats,graphics,displaymath]{preview}
\setlength\PreviewBorder{0pt}
\begin{document}
%s
\end{document}
'''

T = '\n'.join([r"\begin{preview}{\strut %s}\end{preview}"%x for x in text])
F = raw % (fontname, T)

wdir = mkdtemp()
fin  = "%s/tmpblock.tex"%wdir
FIN  = open(fin, 'w')
FIN.write(F)
FIN.close()

chdir(wdir)
system('pdflatex %s %s '%(fin,quiet))
system('pdftk %s burst'%fin.replace('.tex','.pdf'))


raw = r'''
\batchmode
\documentclass{article}
\usepackage{graphicx}
\usepackage{calc}
\usepackage[absolute]{textpos}

\newlength\textblockheight
\newlength\textblockheighttmp

\newlength\textblocklength
\setlength{\textblocklength}{8 cm}

\begin{document}
\pagestyle{empty}
%s
\end{document}
'''

pics = sorted(glob("pg_*.pdf"))
for p in pics:
    system('pdfcrop %s tmp.pdf 1>/dev/null'%p)
    system('mv tmp.pdf %s'%p)

gline = r'''
\begin{textblock*}{\textblocklength}(0 pt,\textblockheight)
\noindent
\includegraphics[width=\textblocklength]{%s}
\end{textblock*}
\settototalheight\textblockheighttmp{\includegraphics[width=\textblocklength]{%s}}
\setlength{\textblockheight}{\textblockheight + \textblockheighttmp}
'''

T = ''.join([gline%(x,x) for x in pics])
F = raw % T

fin  = "%s/tmpblock.tex"%wdir
FIN  = open(fin, 'w')
FIN.write(F)
FIN.close()
system('pdflatex %s 1>/dev/null'%fin)
system('pdfcrop %s out.pdf 1>/dev/null'%fin.replace('.tex','.pdf'))
system('cp out.pdf %s/text_block.pdf' % odir)

chdir(odir)
#system('evince text_block.pdf')
system('open text_block.pdf')
