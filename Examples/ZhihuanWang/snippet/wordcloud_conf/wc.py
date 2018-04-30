from __future__ import division
from pylab import *
import sys
filename = sys.argv[1]

try: 
    threshold = float(sys.argv[2])
except:
    threshold = .15

stop = set([f.strip() for f in open("stopwords.txt",'r')])
stop2 = set([f.strip() for f in open("extra_stop.txt",'r')])

stop = stop.union( stop2 )

W = dict()

for line in open(filename,'r'):
    words =  map(str.lower, line.strip().split(' '))
    for w in words:
        while w and w[-1] in [".",",",";",":","?","!"]:
            w = w[:-1]
        #w = ''.join([letter for letter in w if letter.isalpha() or w=='+' or w=='-'])
        if w not in stop and w and len(w)>2:
            if w not in W: W[w] = 1
            else: W[w] += 1


bad_plurals = ['stres']

for w in W.keys():
    if w in W and w+'s' in W and w not in bad_plurals:
        W[w] += W[w+'s']
        del W[w+'s']

Y = array(W.keys())
X = array([W[y] for y in Y])

#idx = argsort(X)
#X = X[idx][-words_to_keep:]
#Y = Y[idx][-words_to_keep:]

idx = argsort(Y)
Y = Y[idx]
X = X[idx]/max(X)

X = log(X+1)

#idx = argsort(X)
#X = X[idx[-20:]]
#Y = Y[idx[-20:]]

idx = X>threshold
X = X[idx]
Y = Y[idx]

#print X
#print log(X+1)*50
#exit()

X = X*80
max_x = max(X)
magic_text = [r' \text{%s}{%s}'%(y,int(x)) for x,y in zip(X,Y)]


#print magic_text

S = r'''\documentclass[10pt]{article} 
\usepackage{fix-cm}
\usepackage[none]{hyphenat}

\thispagestyle{empty}

\newcommand{\baseline}[0]{%s}
\newcommand{\text}[2]{\fontsize{#2}{\baseline}\selectfont #1}

\begin{document}
\centering
\noindent %s
\end{document}
''' % (max_x*(2/3),''.join(magic_text))

#print S
FOUT = open('tex_wc.tex', 'w')
FOUT.write(S)
FOUT.close()

from os import system
system('pdflatex tex_wc.tex 1>/dev/null')
system('pdfcrop tex_wc.pdf tex_wc_crop.pdf 1>/dev/null')

filename = ''.join(filename.split('.')[:-1]) + '_wc_%s.pdf' % int(threshold*10)
system('mv tex_wc_crop.pdf %s' % filename)


try: 
    sys.argv[3]
    system('xpdf %s' % filename)
except: None



#for x,y in zip(X,Y):
#    print x,y




#print len(X)
#from pylab import *
#hist(map(log,X))
#show()
