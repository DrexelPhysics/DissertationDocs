from __future__ import division
from pylab import *
v = 1/5
A = array([[1-v,0,v,0,0],[0,1-v,v,0,0],[v/3,v/3,1-v,v/3,0],[0,0,v/2,1-v,v/2],[0,0,0,v,1-v]])

iterations = 50

AN = [A,]
for n in xrange(iterations):
    AN.append( dot(AN[-1],A) )
AN = array(AN)

AX = AN[:,1,:].T

styles = ['s','p','x','o','v']*5

for n in xrange(5):
    #scatter(AX[n], range(len(AX[n])), styles[n], label="v_%s"%n, alpha=.6, lw=20)
    #scatter(range(len(AX[n])), AX[n], s=80, marker=styles[n], label="v_%s"%n, alpha=1)
    plot(AX[n], '-', label=r"$v_%s$"%n, alpha=.6, lw=10)


legend()
show()
print AX
