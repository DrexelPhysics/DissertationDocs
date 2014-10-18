import pickle, numpy
from copy import deepcopy
from pylab import *
from pylab_params import PDF_SAVECHOP, cmap_discretize

FIN = open("traj.dat",'r')
X = pickle.load(FIN)
Y = pickle.load(FIN)

N = 45
min_count = 2

def find_and_remove(STATES,H,M):
    # Count the states and label them
    INVSTATES = dict()
    for n,s in enumerate(STATES): 
        STATES[s]    = n
        INVSTATES[n] = s

    # Create a matrix of these counts
    # ignoring rows that have been skipped previously
    MN = len(STATES)
    M  = numpy.matrix( numpy.zeros( (MN,MN),float) )
    for z in H:
        try: 
            i,j = STATES[z[0]], STATES[z[1]]
            M[i,j] = H[z]
        except: False

    # Identify the weak entries where the row counts are < min_count
    is_matrix_complete = True

    for n in xrange(M.shape[0]):
        if M[n,:].sum() < min_count: 
            is_matrix_complete = False
            STATES.pop( INVSTATES[n] )
            INVSTATES.pop( n )

    # Recount the states
    for n,s in enumerate(STATES): STATES[s] = n

    return is_matrix_complete, M


def row_norm(M):
    MR = (M.T/M.sum(1).T)  # Row normalize a matrix
    return MR.T

# Find and assign the sign structure
def sign_structure(M, eigen_cut):
    zero_threshold = 0.0001 # to account for rounding errors
   
    L,V    = eig(M)
    
    idx = L > eigen_cut
    U = real(V[:, idx])  # CUT eigenvector matrix
    idx = U > zero_threshold

    Usgn = zeros(U.shape,dtype=int)
    Usgn[idx]  =  1
    Usgn[~idx] = -1

    #print "There are %s eigenvectors" % sum(idx>0)

    keys = set(map(tuple,Usgn.tolist())) # Unique directions
    USET = dict.fromkeys(keys)

    for k in keys:
        USET[k] = []
        for n,row in enumerate(Usgn):
            if tuple(row)==k:
                USET[k].append(n)

    return L,V,USET


#*************************************************************
def potential_function(x,y): 
    return  exp(-((sqrt(x**2+y**2)))) + exp(-((sqrt((x-2)**2+(y-2)**2)))) +  exp(-((sqrt((x)**2+(y+2)**2))))

def plot_config_space(VSET):
    INV_VSET = dict( (v,k) for k in VSET for v in VSET[k] )
    COLORS   = dict( (x,n) for n,x in enumerate(VSET) )

    djet = cmap_discretize(cm.copper, len(VSET), alpha=.7)

    MX,MY = meshgrid(range(N),range(N))
    MZ    = zeros((N,N,4))

    for idx in ndindex(N,N):
        if idx in STATES:
                n = STATES[idx]
                s = INV_VSET[n]
                c = COLORS[s]+1 - .01
                c-=1
                MZ[idx[1],idx[0],:] = djet(float(c)/len(VSET))

    msize,mdx = 4, .01
    Y,X = mgrid[-msize:msize:mdx, -msize:msize:mdx]
    Z = potential_function(X,Y)

    imshow(Z, origin='lower',
           extent=[-msize,msize,-msize,msize], alpha = .6)

    imshow(MZ, interpolation='nearest',
           origin='lower', extent=[-msize,msize,-msize,msize])

    dx = 1.0/len(VSET)
    tick_loc = [(.5+n)*dx for n in range(len(VSET))]
    tick_lbl = [r"$c_{%s}(%s)$"%(n,len(VSET[x])) for n,x in enumerate(VSET)]

    #cb = colorbar()
    #cb.set_cmap(djet)
    #cb.set_ticks(tick_loc)
    #cb.set_ticklabels(tick_lbl)
    #cb.draw_all()

    #imshow(Z, origin='lower',
    #       extent=[-msize,msize,-msize,msize], alpha = .4)

def permuted_matrix(M,VSET):
    idx = reduce(lambda x,y:x+y, VSET.values())
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
        
        M2 /= M2.sum(1)

        # Find the steady state
        L,V =  eig(M2,left=True,right=None)
        Lmax_idx = argmax(abs(L))
        pi = V[:,Lmax_idx]
        pi = real(pi) / abs(pi).sum()
        ALL_SUBPI[ortho_direction] = abs(pi)

    return ALL_SUBPI
   
def block_transistion(M, VSET,ALL_SUBPI):
    #from numpy.linalg import *
    n = len(VSET)
    Z = zeros((n,n))

    for i,d1 in enumerate(VSET):
        idx = VSET[d1]
        pi = ALL_SUBPI[d1]

        # Set the intial vector to the sub-steady state and advance it one step
        b  = zeros(M.shape[0])
        
        b[idx] = pi
        b      = dot(b,M)

        # Compute the transistion from one block to another
        for j,d2 in enumerate(VSET):
            idx2 = VSET[d2]
            Z[i,j] = b[:,idx2].sum()
    return Z

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

def latex_print_matrix_rates(A):
    n = A.shape[0]
    #f = '|'.join(["r"]*n)

    print r"\begin{equation}"
    print r"\begin{bmatrix}"
    for row in A:
        print ' & '.join(["%.4f" % item if item>.0001 or item<0 else "" for item in row]),
        print r"\\"
    print r"\end{bmatrix}"
    print r"\end{equation}"
    


# MAIN
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=


H = dict()
old_name = (int((X[0]+4)/8*N), int((Y[0]+4)/8*N))

for xvalue,yvalue in zip(X,Y):
    ax,ay = (xvalue+4)/8, (yvalue+4)/8
    x,y = int(N*ax), int(N*ay)
    name = (x,y)

    a,b  = name, old_name

    try   : H[ (a,b) ] += 1
    except: H[ (a,b) ]  = 1

    old_name = name

# Identify the unqiue states
STATES = dict.fromkeys( reduce(lambda x,y:x.union(y), map(set,zip(*H.keys()))) )

is_matrix_complete, M  = False, numpy.matrix( numpy.zeros( (0,0),float) )
while not is_matrix_complete:
    is_matrix_complete, M  = find_and_remove(STATES,H,M)
    print "Pruning matrix down to: ", len(STATES)

M  = row_norm(M)

L,V,VSET = sign_structure(M, .85)
ALL_SUBPI = steady_subM(M,VSET)
Z = block_transistion(M,VSET,ALL_SUBPI)

# PLOT - RAW MARKOV TRANSISTION MATRIX
MSHOW = M.copy()
MSHOW[MSHOW==0] = None
matshow(MSHOW,fignum=1)
PDF_SAVECHOP('markov_matrix_unpermuted')

MP = permuted_matrix(MSHOW,VSET)
matshow(MP,fignum=2)
PDF_SAVECHOP('markov_matrix_permuted')

matshow(Z,fignum=3)

figure(4)
plot_config_space(VSET)

fs = 40

text(.25,2.5,r'$c_{0}$',fontsize=fs)
text(2,-2,r'$c_{1}$',fontsize=fs)
text(-2,0,r'$c_{2}$',fontsize=fs)
text(-.1,1.5,r'$c_{3}$',fontsize=fs)

PDF_SAVECHOP('cluster_locations', PNG=True)

latex_print_matrix(Z)

from scipy.linalg import logm
W = logm(Z)

latex_print_matrix_rates(W)


show()

    



