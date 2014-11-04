from scipy import *
from combinations import *

N = 8 # This is a chain of N+2 beads (first direction fixed)
D = array([[1,0],[0,1],[-1,0],[0,-1]],dtype=int)
inf_energy = None

S = array(zeros(N+1,dtype=int))

def RX(S):
    X = zeros((N+2,2),dtype=int)
    X[1] = X[0] + D[0]
    for i in xrange(2,N+2):
        X[i] = X[i-1] + D[S[i-2]]
    return X

def above_plane(s):

    if 3 not in s: return s

    s = array(s)
    ups   = where(s==1)[0]
    downs = where(s==3)[0]

    #print "UPODS", ups, downs

    if not ups.size or downs[0] < ups[0]:
        s[ups]   = 3
        s[downs] = 1

    return s


def overlap(X):
    U = unique(map(tuple,X.tolist()))
    return U.shape != X.shape

def nearest_neigh(x1,x2):
    return abs(x1-x2).sum() == 1

def energy_func(X):
    if overlap(X): return None

    Hres = set([1,2,7,8])
    Pres = set([0,9])
    pos_charge_res = set([3,])
    neg_charge_res = set([6,])

    NNset = set()
    for i in xrange(N+2):
        for j in xrange(i+2,N+2):
            if nearest_neigh(X[i],X[j]):
                NNset.add( (i,j) )

    Ehh, Epp, Ehp, Epolar = [0,]*4
    for item in NNset:
        i,j = item
        if i in Hres and j in Hres: Ehh += 1
        if i in Pres and j in Pres: Epp += 1
        if i in Hres and j in Pres: Ehp += 1
        if j in Hres and i in Pres: Ehp += 1
        if i in pos_charge_res and j in neg_charge_res: Epolar += 1
        if j in pos_charge_res and i in neg_charge_res: Epolar += 1

    return (Ehh,Epp,Ehp,Epolar)

    E = (Ehh,Epp,Ehp,Epolar)

    #b1 = nearest_neigh(X[0],X[9])
    #b2 = nearest_neigh(X[1],X[8])
    #b3 = nearest_neigh(X[2],X[7])
    #b4 = nearest_neigh(X[3],X[6])
    #return (b1,b2,b3,b4)


if __name__ == "__main__":
    print "Enumerating all states"
    ALL_STATES = map(array,list(xselections(range(len(D)),N)))
    VALID_STATES = dict()
    for s in ALL_STATES:
        above_s = above_plane(s)

        if array_equal(s,above_s):
  
            #if s[0]==1:
            #    s = [(x-1)%4 for x in s]

            X = RX(s)
            E = energy_func(X)
            if E != None and s[0]==0:
                VALID_STATES[tuple(s)] = E

    FOUT = open("data/states_energies.txt",'w')

    for s in VALID_STATES:
        txt = "%s, %s"% (s, VALID_STATES[s])
        FOUT.write("%s\n"%txt)
    FOUT.close()





