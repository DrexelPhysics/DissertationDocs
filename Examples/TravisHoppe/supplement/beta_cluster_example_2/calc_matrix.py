from find_states import *

prefix = "data/"
fin1   = "states_energies.txt"
fin2   = "states_adj.txt"
fout1  = "markov_matrix.txt"

def compute_W(T,method):
    assert method in ['glauber','metro']
    
    FIN1 = open("%s%s"%(prefix,fin1),'r')
    FIN2 = open("%s%s"%(prefix,fin2),'r')

    states   = dict()
    states_E = dict()

    for n,line in enumerate(FIN1):
        s,e = eval(line)
        states[n] = s
        Ehh,Epp,Ehp,Epolar = e

        ev_hh    = -0.6
        ev_pp    = -0.5
        ev_hp    =  0.10
        ev_polar = -1.5
       
        states_E[s] = ev_hh*Ehh + ev_pp*Epp + ev_hp*Ehp + ev_polar*Epolar

    # Quick CV plot
    from pylab import *
    ion()
    EX    = array(states_E.values())
    beta  = linspace(.05, 10, 1000)
    ZT = array([log(exp(-EX*b).sum()) for b in beta])
    plot( beta[2:],diff(ZT,2)*beta[2:]**2)

    #exit()
    
    sN = len(states)
    W = zeros((sN,sN))

    for n,line in enumerate(FIN2):
        i,j = eval(line)
        if i!=j:
            E1 = states_E[states[i]]
            E2 = states_E[states[j]]

            # Metropolis
            if method=='metro':
                if E2<=E1: v = 1.0
                else     : v = exp(-(E2-E1)/T)

            # Glauber
            if method=='glauber':
                ep = exp(-(E2-E1)/T)
                v = ep / (1.0 + ep)
            
            W[i,j] = v

    for i in xrange(W.shape[0]):
        W[i,i] = -sum(W[:,i])

    return W

if __name__ == "__main__":

    from sys import argv

    try:
        T     = float(argv[1])
        time  = float(argv[2])
        method = argv[3]
    except:
        print "calc_matrix.py [T] [time] [metro:glauber]"
    finally:
        T     = float(argv[1])
        time  = float(argv[2])
        method = argv[3]

    print "Computing rate matrix"
    W = compute_W(T,method)

    print "Computing markov matrix"
    import scipy.linalg as lin
    M = lin.expm(time*W)

    print "Saving data"
    from cPickle import *
    FOUT = open("%s%s"%(prefix,fout1),'w')
    dump((T,time,M),FOUT)
    FOUT.close()

    print "Computation complete!"

