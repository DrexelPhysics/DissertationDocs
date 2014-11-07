#!/usr/bin/python

import numpy, sys

DATAFILE='./data/raw'
KFILE='./data/spring-constants'
AVGFILE='./data/averaged-data'

KCUTS=[45, 90]

def read_raw(Kcuts=KCUTS, datafile=DATAFILE):
    FofV = {}
    Ks = []
    for i in range(len(Kcuts)+1):
        Ks.append([])
    for line in open(datafile, 'r'):
        if line[0] == '#':
            continue # ignore comments
        fields = line.strip().split('\t')
        force = float(fields[0])
        rate = float(fields[1])
        spring = float(fields[2])

        ispring = 0
        while ispring < len(Kcuts) and spring > Kcuts[ispring]:
            ispring += 1
        Ks[ispring].append(spring)
        if rate not in FofV.keys():
            FofV[rate]=[]
            for i in range(len(Ks)):
                FofV[rate].append([])
        FofV[rate][ispring].append(force)
    return (Ks, FofV)

def write_k_file(Ks, kfile=KFILE):
    avgK = [0]*len(Ks)
    stdK = [0]*len(Ks)
    numK = [0]*len(Ks)
    kf = open(kfile, 'w')
    for i in range(len(Ks)):
        K = numpy.array(Ks[i])
        avgK[i] = K.mean()
        stdK[i] = K.std()
        numK[i] = len(K)

        if i == 1:
            continue # poor calibration bumps for the older cantilevers
        kf.write('K({}) = {} +/- {}, (# {})\n'.format(
                i, avgK[i], stdK[i], numK[i]))
    kf.close()
    return (avgK, stdK, numK)

def write_average_file(FofV, avgK, avgfile=AVGFILE):
    Vs = sorted(FofV.keys())
    af = open(AVGFILE, 'w')
    af.write('{}{}\n'.format(
            '#', '\t'.join(
                ['Pulling speed (nm/s)','Spring constant (pN/nm)',
                 'Mean force (pN)','Std. force (pN)','Events (#)'])))
    for V in Vs:
        for i,k in enumerate(avgK):
            if i == 1:
                continue # poor calibration bumps for the older cantilevers
            F = numpy.array(FofV[V][i])
            if len(F) == 0:
                continue
            outs= [V, k, F.mean(), F.std(), len(F)]
            souts = ['{:.2f}'.format(x) for x in outs]
            souts[-1] = str(outs[-1])  # special treatment for the integer
            af.write('\t'.join(souts))
            af.write('\n')
    af.close()

if __name__ == '__main__':
    Ks,FofV = read_raw()
    avgK,stdK,numK = write_k_file(Ks)
    write_average_file(FofV, avgK)
