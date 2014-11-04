from tempfile import mkdtemp
from os import system, chdir, getcwd
from glob import *
from sys import argv

quiet = ["", "1>/dev/null"][0]

try:
    FIN = open(argv[1],'r')
except:
    print "blocktext.py [input textfile] [font]"
    exit()

try:
    fontname = ' '.join(argv[2:])
except:
    fontname = "TradeGothic LT Bold"

print " ** Fonts matching your selection: %s **", fontname
system ('fc-list | grep "%s"' % fontname)

text = [x.strip() for x in FIN]
odir = getcwd()
wdir = mkdtemp()

system("cp %s/* %s"%(odir, wdir))
chdir(wdir)

raw = r'''
\documentclass{minimal}
\usepackage{xcolor}
\usepackage{graphicx}
\usepackage{fontspec}
\begin{document}
\fontspec{%s}
\fontsize{18pt}{18pt}
\selectfont
%s
\end{document}
'''

special = dict()

for n,T in enumerate(text):
    if T[0]==":": special[n] = T
    if T[0]!=":":
        special[n] = None
        F = raw % (fontname, T)
        fin  = "tmpblock.tex"
        FIN  = open(fin, 'w')
        FIN.write(F)
        FIN.close()
        system('xelatex %s %s'%(fin,quiet))
        pdf_name = fin.replace('.tex','.pdf')
        new_name = 'pg_%.4i.pdf' % n
        print "Block %s: %s"%(n,T)
        system('mv %s %s' % (pdf_name, new_name))

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
%s
\end{textblock*}
\settototalheight\textblockheighttmp{%s}
\setlength{\textblockheight}{\textblockheight + \textblockheighttmp}
'''

T = []
pcount = 0
for n in range(len(special)):
    if special[n]: 
        v = special[n][1:].lstrip()
    else: 
        v = r"\includegraphics[width=\textblocklength]{%s}" % pics[pcount]
        pcount += 1
    T.append(gline%(v,v))
T = ''.join(T)
F = raw % T

print wdir

fin  = "%s/tmpblock.tex"%wdir
FIN  = open(fin, 'w')
FIN.write(F)
FIN.close()
system('pdflatex %s 1>/dev/null'%fin)
#system('pdflatex %s'%fin)
system('pdfcrop %s out.pdf 1>/dev/null'%fin.replace('.tex','.pdf'))
#system('pdfcrop %s out.pdf'%fin.replace('.tex','.pdf'))
system('cp out.pdf %s/text_block.pdf' % odir)
chdir(odir)
system('evince text_block.pdf')






