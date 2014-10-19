import pickle, numpy
from copy import deepcopy
from pylab_params import cmap_discretize
from pylab import *
from pylab_params import PDF_SAVECHOP

from sys import argv
try:
    eigen_cutoff = float(argv[1])
except:
    print "python grid_traj.py [eigen_cutoff]"
    exit()

prefix = "data/"
fin1  = "markov_matrix.txt"
fout1 = "clusters.txt"

FIN = open("%s%s"%(prefix,fin1),'rb')
from cPickle import *
T,time,M = load(FIN)

def row_norm(M):
    MR = (M.T/M.sum(1).T)  # Row normalize a matrix
    return MR.T

def eigen_sort(L,V):
    idx = argsort(abs(L))
    return L[idx], V[:,idx]

# Find and assign the sign structure
def sign_structure(M, eigen_cut):
    zero_threshold = 0.0001 # to account for rounding errors
   
    L,V    = eigen_sort(*eig(M))
       
    idx = L > eigen_cut
    U = real(V[:, idx])  # CUT eigenvector matrix
    idx = U > zero_threshold

    Usgn = zeros(U.shape,dtype=int)
    Usgn[idx]  =  1
    Usgn[~idx] = -1

    keys = set(map(tuple,Usgn.tolist())) # Unique directions
    USET = dict.fromkeys(keys)

    for k in keys:
        USET[k] = []
        for n,row in enumerate(Usgn):
            if tuple(row)==k:
                USET[k].append(n)

    return L,V,USET


#*************************************************************

def permuted_matrix(M,VSET,ZKEYS):
    idx = reduce(lambda x,y:x+y, [VSET[z] for z in ZKEYS])
    return M[idx,:][:,idx]

#*************************************************************

def steady_subM(M, VSET):
    from scipy.linalg import eig

    # Calculate the sub-matrices and their steady-states
    ALL_SUBPI = dict().fromkeys(VSET)

    for ortho_direction in VSET:
        idx = VSET[ortho_direction]

        # Find the submatrix and make it a proper markov
        M2 = M[idx,:][:, idx]

        # Remove bad rows (that don't flow anywhere)
        bad_idx = M2.sum(1)==0
        if bad_idx.any():
            b = array(bad_idx.T.tolist()[0])
            M2[b,b] = 1
            #M2 = M2[~b,:][:,~b]
        
        M2 = row_norm(M2)

        # Find the steady state
        L,V =  eig(M2,left=True,right=None)
        Lmax_idx = argmax(abs(L))
        pi = V[:,Lmax_idx]
        pi = real(pi) / real(pi).sum()
        #print pi
        ALL_SUBPI[ortho_direction] = abs(pi)

    return ALL_SUBPI
   
def block_transistion(M, VSET,ALL_SUBPI):

    #from numpy.linalg import *
    n = len(VSET)
    Z = zeros((n,n))
    ZKEYS = VSET.keys()

    # Sort the keys so the largest element is last
    vset_size_idx = argsort(map(len,VSET.values()))
    ZKEYS = map(tuple,array(ZKEYS)[vset_size_idx])

    print ZKEYS
    print vset_size_idx

    for i,d1 in enumerate(ZKEYS):
        idx = VSET[d1]
        pi = ALL_SUBPI[d1]

        # Set the intial vector to the sub-steady state and advance it one step
        b  = zeros(M.shape[0])
        
        b[idx] = pi
        b      = dot(b,M)

        # Compute the transistion from one block to another
        for j,d2 in enumerate(ZKEYS):
            idx2 = VSET[d2]
            Z[i,j] = b[:,idx2].sum()

    return Z, ZKEYS

def latex_print_matrix(A):
    n = A.shape[0]
    #f = '|'.join(["r"]*n)

    print r"\begin{equation}"
    print r"\begin{bmatrix}"
    for row in A:
        print ' & '.join(["%.3f" % item if item>.001 else "" for item in row]),
        print r"\\"
    print r"\end{bmatrix}"
    print r"\end{equation}"


# MAIN
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=
# Beta-hairpin model

print "M Matrix loaded"
M  = row_norm(M)

L,V,VSET = sign_structure(M, eigen_cutoff)

print "There are %s clusters" % len(VSET)
print " cluster sizes are", sorted([len(VSET[x]) for x in VSET])

ALL_SUBPI = steady_subM(M,VSET)
Z,ZKEYS = block_transistion(M,VSET,ALL_SUBPI)

FOUT = open("%s%s"%(prefix, fout1),'wb')
dump( (VSET, ZKEYS,ALL_SUBPI, Z), FOUT )

print "L,V calculated"
#latex_print_matrix(Z)

matrix_view_threshold = .0005

# PLOT - RAW MARKOV TRANSISTION MATRIX
MSHOW = M.copy()
MSHOW[MSHOW<matrix_view_threshold] = None
matshow(MSHOW,fignum=1)
PDF_SAVECHOP('markov_matrix_unpermuted')

MP = permuted_matrix(MSHOW,VSET,ZKEYS)
matshow(MP,fignum=2)
PDF_SAVECHOP('markov_matrix_permuted')

ZSHOW = Z.copy()
ZSHOW[ZSHOW<matrix_view_threshold] = None
matshow(ZSHOW,fignum=3)

Lsort = sorted((abs(L)))[::-1]
print Lsort[:30]

#figure(4)
#plot(sorted(log(abs(L)))[::-1],lw=3,alpha=.8)
#ylabel(r'$\log | \lambda |$')
#axis('tight')

#PDF_SAVECHOP('eigenvalue_spectrum')

#figure(4)
#plot_config_space(VSET)
#PDF_SAVECHOP('cluster_locations')

from os import system
system('xpdf pictures/markov_matrix_permuted.pdf &')
#system('xpdf pictures/markov_matrix_permuted.pdf &')
#system('xpdf pictures/markov_matrix_permuted.pdf &')

#show()

    



