#!/usr/bin/python

from math import log


g = 0.5772156649
kB = 1.3806504e-23
T = 300
p = 3.7e-10
v = 1e-6
Kc = 0.05
Kwlc = 0.18
dx = 0.225e-9
ko = 5e-5
f = kB*T/dx

def kappa(i, Kc=Kc, Kwlc=Kwlc):
    return 1.0/(1.0/Kc + i/Kwlc)

def theory(i, N, Kc=Kc, Kwlc=Kwlc, ko=ko, dx=dx, v=v, T=T, kB=kB, g=g):
    f = kB*T/dx;
    return f*(log((kappa(i, Kc, Kwlc)*v)/((N-i)*ko*f)) - g)

def atheory(*args, **kwargs):
    """Call theory with abs() of all arguments, since the fitting
    routine may attempt negative values.
    """
    for i,x in enumerate(args):
        args[i] = abs(x)
    for k,v in kwargs.items():
        kwargs[k] = abs(v)
    return theory(*args, **kwargs)
