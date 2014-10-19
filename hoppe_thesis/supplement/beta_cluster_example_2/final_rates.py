import pickle, numpy
from os import system
from scipy import *
from scipy.linalg import logm


prefix = "data/"
fin1 = "clusters.txt"

FIN1 = open("%s%s"%(prefix,fin1),'rb')
from cPickle import *
C, ZKEYS, ALL_SUBPI, Z = load(FIN1); FIN1.close()


def row_norm(M):
    MR = (M.T/M.sum(1).T)  # Row normalize a matrix
    return MR.T

powers_advanced = 3
for n in xrange(powers_advanced):
    Z = dot(Z,Z)
Z = row_norm(Z)

# G_0 -> unfolded (everything else), 21?
# G_1 -> intermediate (17,18)
# G_2 -> final (11)




def latex_print_matrix(A):
    n = A.shape[0]
    cutoff = .0000000000000000000001

    print r"\begin{equation}"
    print r"\begin{bmatrix}"
    for row in A:
        print ' & '.join(["%.5f" % item if item>cutoff else "" for item in row]),
        print r"\\"
    print r"\end{bmatrix}"
    print r"\end{equation}"


GC = dict()
#GC[0] = [n for n in range(len(Z)) if n not in [17,18,11]]
GC[0] = [21,]
GC[1] = [17,18]
GC[2] = [11]
print GC

G = zeros((3,3),dtype=float)

print GC

for i in range(3):
    for j in range(3):
        G[i,j] = Z[GC[i],:][:,GC[j]].sum()

G = row_norm(G)

print G
latex_print_matrix(G)
latex_print_matrix(logm(G))
print logm(G)

