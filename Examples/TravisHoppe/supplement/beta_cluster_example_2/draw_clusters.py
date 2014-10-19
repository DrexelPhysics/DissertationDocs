import pickle, numpy
from copy import deepcopy
from pylab_params import cmap_discretize
from pylab import *
from pylab_params import PDF_SAVECHOP
from find_states import RX, nearest_neigh
from os import system

prefix = "data/"
fin1 = "interesting_clusters.txt"
fout1 = 'pictures/view_figs.tex'

# Load the interesting cluster list
FIN1 = open('%s%s'%(prefix,fin1),'r')
listed_idx = [int(x) for x in FIN1]
FIN1.close()

# Remove the old figures
system('rm -rf view_figs.pdf')
system('rm -rf pictures/? pictures/??')


FOUT1 = open(fout1, 'w')
S = r'''
\documentclass[]{report}
\usepackage[pdftex]{graphicx}
\begin{document}
'''
FOUT1.write(S)

def row_norm(M):
    MR = (M.T/M.sum(1).T)  # Row normalize a matrix
    return MR.T

def plot_stateclusters(C,name_id):
    
    VN = len(C)
    avg_E = 0#avg_energy(C)
    FOUT1.write('\\section{Cluster %s $\\left < E \\right > = %s$} \n'
                % (name_id,avg_E) )
    
    for n,s in enumerate(C):
        #subplot(int(ceil(VN/3.)),3,n+1)

        X = RX(s)
        x,y = zip(*X)

        plot(x,y,'k',lw=20)

        Hres = set([1,2,7,8])
        Pres = set([0,9])
        pos_charge_res = set([3,])
        neg_charge_res = set([6,])

        N = 8
        NNset = set()
        for i in xrange(N+2):
            for j in xrange(i+2,N+2):
                if nearest_neigh(X[i],X[j]):
                    NNset.add( (i,j) )

        for item in NNset:
            i,j = item
            xc = [X[i][0],X[j][0]]
            yc = [X[i][1],X[j][1]]

            dot_size = 2500
            if i in Hres and j in Hres:
                scatter( xc,yc, color='r', s=dot_size,zorder=10)
            if i in Pres and j in Pres:
                scatter( xc,yc, color='b', s=dot_size,zorder=10)
            #if (i in Hres and j in Pres) or (j in Hres and i in Pres):
            #    plot( xc,yc, color='r')
            if (i in pos_charge_res and j in neg_charge_res) or (j in pos_charge_res and i in neg_charge_res):
                scatter( xc,yc, color='g', s=dot_size*3,zorder=5,alpha=.7)

        scatter([5,],[5,],s=0)
        axis('equal')
        dx = .4
        xlim(min(x)-dx,max(x)+dx)
        ylim(min(y)-dx,max(y)+dx)

        axis('off')

        from os import system, mkdir
        sdir = 'pictures/%s' % name_id
        try: mkdir(sdir)
        except: pass
        
        f = "%s/state_cluster_shapes_%s" % (sdir, n)
        #print f
        #PDF_SAVECHOP(f)
        savefig("%s.pdf"%f,pad_inches=0,transparent=True)
        FOUT1.write('\\includegraphics[scale=.1]{%s.pdf} \n'%f)
        clf()

prefix = "data/"
fin1 = "clusters.txt"
fin2 = "states_energies.txt"

FIN1 = open("%s%s"%(prefix,fin1),'rb')
from cPickle import *
C, ZKEYS, ALL_SUBPI, Z = load(FIN1)
FIN1.close()

Cinv = dict( (v,k) for k in C for v in C[k] )
CX = dict().fromkeys(C)  # A dictionary list of the X pos. for drawing

# Simply use a hard-coded set of interesting states from other sim


# Find interesting states where Z[i,i]>threshold
#ID = eye(Z.shape[0],dtype=bool)
#idx = where(Z[ID]>.4)[0]
#print idx
#print Cinv[8], C[ Cinv[8] ]
#exit()

state_clusters = dict()
energy_clusters= dict()

for c in C:
    state_clusters[c] = []
    energy_clusters[c] = []
    CX[c] = []

FIN2 = open("%s%s"%(prefix,fin2),'rb')
for n,state in enumerate(FIN2):
    s,e = eval(state)
    #print n,s, Cinv[n]
    
    CX[ Cinv[n] ].append(s)


    
FIN2.close()

for n,cluster in enumerate(ZKEYS):
    #if avg_energy(CX[cluster])[0]<-.1:
    if n in listed_idx:
        print "Plotting figure %s/%s with %s clusters"% (n,len(CX),len(CX[cluster])), " Z[i,i]=", Z[n,n]
        figure(n)
        plot_stateclusters(CX[cluster], n)

FOUT1.write('\\end{document}\n')
FOUT1.close()

system('pdflatex pictures/view_figs.tex 1>/dev/null 2>/dev/null')
system('rm *.aux *.log && xpdf view_figs.pdf &')




