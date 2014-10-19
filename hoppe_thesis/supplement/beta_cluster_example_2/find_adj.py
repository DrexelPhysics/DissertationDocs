from scipy import *
from combinations import *
from find_states import *
from copy import deepcopy

prefix = "data/"
fin1   = "states_energies.txt"
fout1  = "states_adj.txt"

if __name__ == "__main__":
    states = dict()
    
    FIN = open("%s%s"%(prefix,fin1),'r')
    for n,line in enumerate(FIN):
        s,e = eval(line)
        states[s] = n

FOUT = open("%s%s"%(prefix,fout1),'w')

print "Finding adj states"

for s in states:
    for i,spot_val in enumerate(s):
        for j in range(4):
            if j != spot_val and i>0:
                s2 = array(s)
                s2[i] = j

                if not overlap(RX(s2)):
                    s2 = above_plane(s2)

                    txt = "%s,%s"% (states[tuple(s)], states[tuple(s2)])
                    FOUT.write("%s\n"%txt)
FOUT.close()








