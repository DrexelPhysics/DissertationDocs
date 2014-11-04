from scipy import *
import pydot
FIN = open("adj_petersen.txt",'r')

A = zeros((10,10),dtype='int')
E = []
EX = []
for i,line in enumerate(FIN):
    for j,x in enumerate(line.strip()):
        A[i][j] = int(x)
        if i<j and A[i][j]:
            E.append( (str(i),str(j)) )
            EX.append( (i+1,j+1) )

'''
g=pydot.graph_from_edges(E)
print A
  
g.write_png('graph_petersen.png', prog='circo')

from os import system
system('eog graph_petersen.png')
'''

from operator_agg import *

E = sorted(E)

P = state_poly()


P = state_poly()
V = set(range(1,10+1))


dlist = set()
alist = set()

for n,e in enumerate(EX):
    if e[0] not in alist:
        alist.add(e[0])
        print "   * Adding vertex ", e[0]
        P.A(e[0])

    if e[1] not in alist:
        alist.add(e[1])
        print " Adding vertex ", e[1]
        P.A(e[1])
    
    print "Adding edge: ", n, e

    P.W(e[0],e[1])

    r1,r2 = map(set,zip(*EX[n:]))
    r = r1.union(r2)

    for dv in V.symmetric_difference(r).symmetric_difference(dlist):
        print "   * Removing vertex", dv
        P.D(dv)
        dlist.add(dv)

    print "Vertices remaining: ", r

print P.final()



