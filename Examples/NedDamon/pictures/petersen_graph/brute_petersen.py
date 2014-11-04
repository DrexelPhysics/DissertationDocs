from scipy import *
from combinations import *

prefix = "data/"
fout1  = "chi_peterson.txt"

def find_clusters(A):
    C = set()
    seen = set()
    for i,row in enumerate(A):
        queue,cluster = set(), set()

        if i not in seen: 
            queue.add(i)
            seen.add(i)
            cluster.add(i)

        while queue:
            item = queue.pop()
            edges = set(where(A[item])[0])
            for x in edges:
                if x not in seen:
                    queue.add(x)
                    seen.add(x)
                    cluster.add(x)

        if cluster: yield array(list(cluster))


def cluster_count(A,cluster):
    e = (A[cluster,:][:,cluster]).sum()/2
    n = cluster.size
    return n,e



    

FIN = open("adj_petersen.txt",'r')
FOUT1 = open("%s%s"%(prefix,fout1), 'w')

A = zeros((10,10),dtype='int')
for i,line in enumerate(FIN):
    for j,x in enumerate(line.strip()):
        A[i][j] = int(x)

edges = [x for x in zip(*where(A)) if x[0]<x[1]]
N = len(edges)

S = dict()


for n in xrange(0,N+1):
    #print n

    for subgraph_edge_set in xuniqueCombinations(edges,n):
        #print subgraph_edge_set
        
        B   = A.copy()
        idx = zip(*subgraph_edge_set)
        B[idx] = B[idx[::-1]] = 0

        X = [cluster_count(B,c) for c in find_clusters(B)]
        X = tuple(sorted(X))
        
        if X not in S: S[X] = 0
        
        S[X] += 1

print "Subgraphs counted", sum(S.values())
        
for X in S.keys():
    txt = "%i : %s" % (S[X],X)
    FOUT1.write("%s\n"%txt)
FOUT1.close()






        



