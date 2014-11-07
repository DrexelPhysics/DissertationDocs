#!/usr/bin/python

DATA="./data/raw"
UNFOLD_FORCE_COL=0
UNFOLD_RATE_COL=1
SPRING_CONST_COL=2
LOAD_RATE_COL=3

from avg_data import KCUTS

Ks = [24.33, None, 131.98]   # HACK!
OFILEs = [None, None, None]

for i,K in enumerate(Ks):
    if K == None:
        continue
    OFILEs[i] = open('loading-rate.d/loading_rate_%.2f.dat' % K, 'w')

for line in open(DATA, 'r'):
    if line[0] == '#':
        continue
    fields = line.strip().split()
    F = float(fields[UNFOLD_FORCE_COL])
    V = float(fields[UNFOLD_RATE_COL])
    K = float(fields[SPRING_CONST_COL])
    L = float(fields[LOAD_RATE_COL])
    
    ispring = 0
    while ispring < len(KCUTS) and K > KCUTS[ispring]:
        ispring += 1
    if ispring == 1:
        continue # drop middle spring constants
    
    OFILEs[ispring].write('{}\t{}\n'.format(L, F))

for i,K in enumerate(Ks):
    if K == None:
        continue
    OFILEs[i].close()
    OFILEs[i] = None
