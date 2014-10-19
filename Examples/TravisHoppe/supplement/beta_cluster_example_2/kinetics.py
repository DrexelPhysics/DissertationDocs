import pickle, numpy
from copy import deepcopy
from pylab_params import cmap_discretize
from pylab import *
from pylab_params import PDF_SAVECHOP
from find_states import RX, nearest_neigh

total_time = 10**5*1.5
powers_advanced = 2
listed_clusters = []
 
prefix = "data/"
fin1 = "clusters.txt"
fin2 = "states_energies.txt"
fout1= "interesting_clusters.txt"

rcParams.update({'figure.subplot.bottom':.3})

def row_norm(M):
    MR = (M.T/M.sum(1).T)  # Row normalize a matrix
    return MR.T

def avg_energy(C):
    return [0,len(C)]


FIN1 = open("%s%s"%(prefix,fin1),'rb')
from cPickle import *
C, ZKEYS, ALL_SUBPI, Z = load(FIN1); FIN1.close()

for n in xrange(powers_advanced):
    Z = dot(Z,Z)
Z = row_norm(Z)

#ZC = Z[listed_idx,:][:,listed_idx]
#ZC[2,:] += ZC[3,:]
#ZC[:,2] += ZC[:,3]
#ZC[3,:] = 0
#ZC[:,3] = 0
#ZP = log(ZC)
#print where(eye(5,5,dtype=int))
#ZP[where(eye(5,5,dtype=int))]=0
#print ZP
#matshow(ZP)
#show()



#print [Z[n,:].sum() for n in range(Z.shape[0])] # Z**2 does not sum to 1!

Cinv = dict( (v,k) for k in C for v in C[k] )
CX = dict().fromkeys(ZKEYS)  # A dictionary list of the X pos. for drawing

state_clusters = dict()
energy_clusters= dict()

for c in C:
    state_clusters[c] = []
    energy_clusters[c] = []
    CX[c] = []

FIN2 = open("%s%s"%(prefix,fin2),'rb')
for n,state in enumerate(FIN2):
    s,e = eval(state)
    if (zeros(len(s))==s).all():
        print "Unfolded state",s,n
        unf = n
        
    if s[:8]==(0,0,0,1,2,2,2,2):
        print "Native_state", s,n
        fidx = n
   
    CX[ Cinv[n] ].append(s)
FIN2.close()

keys = array(ZKEYS)


unf_key = array(Cinv[unf])      # unfolded state key
key_size = len(unf_key)

unf_idx = where((keys==unf_key).sum(1) == key_size)[0]

fkey = Cinv[fidx]
f_idx = where((keys==fkey).sum(1) == key_size)[0]
print "Unfolded cluster" , unf_idx
print "native   cluster" , f_idx
print "%s total clusters"% len(C)


# Set the inital conditions
B = zeros(len(C))
B[unf_idx] = 1

BT = [B,B,]

ax = subplot(111)
ax.set_xscale('log')

lw = 4; alpha = .7

for n in xrange(int(total_time)):
    BT.append( dot(BT[-1],Z) )

size_n = len(zip(*BT)[0])

for cn,cluster_tx in enumerate(zip(*BT)):
    maxv = max(cluster_tx)
    if maxv > 0: #.02:
        x,y = argmax(cluster_tx), maxv
        if x<2:
            y-= .1
            x+= 1.5
        if x>size_n-100:
            x /= 5
            y -= .05
        y += .01
           
        k = tuple(keys[cn])
        Eavg,statelen = avg_energy(CX[k])
        
        #Specific adjustments
        #if cn==9: y +=.01
        #if cn==5 : x = x*2
        #if cn==0 : x *= 1.5

        if x<=0: x+= 1
        #print x,y
        #txt = r"$c_{%s}(%s), \left <E \right >=%.3f$" % (cn, statelen, Eavg)
        txt = r"$c_{%s}(%s)$" % (cn, statelen)

        if cn == unf_idx:
            text(x,y,txt,fontsize=20)
            plot(cluster_tx,'k',lw=lw,alpha=alpha)
           
        elif y > 0.15:# or (x>100 and y>.04):
            text(x,y,txt,fontsize=20)
            plot(cluster_tx,'k',lw=lw,alpha=alpha)
            listed_clusters.append( cn ) 
        else:
            plot(cluster_tx,'r',lw=3,alpha=.4)

print "Interesting clusters ", listed_clusters
FOUT = open('%s%s'%(prefix,fout1), 'w')
for c in listed_clusters: FOUT.write('%s\n'%c)
FOUT.close()

axis('tight')
xlabel(r'$t$')
ylabel(r'$P(c_i)$')

f = 'kinetics_beta_cluster'
pdfname = PDF_SAVECHOP(f)
from os import system
system('xpdf %s &'%pdfname)



