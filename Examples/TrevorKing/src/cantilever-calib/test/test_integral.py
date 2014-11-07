import matplotlib
matplotlib.use('Agg') # select backend that doesn't require X Windows
from pylab import *
from numpy import *

N=1000
root_height = 1
i = complex(0,1)

def d(a,b,x) : # know denominator
    return (x, ((a**2 - x**2)**2 + (b*x)**2))
def rm(r, height) : # root marker
    return ([r, r], float(height) * array([0.0001,1]))
def zr(a,b,p,q) : # p, q \in {-1,1}
    return p*i*b/2.0 * (1 + q*sqrt(complex(1,0) - (2*a/b)**2))
def zrc(c,b,p,q) : # p, q \in {-1,1}
    return p*i*b/2.0 * (1 + q*sqrt(complex(1,0) - (2*c)**2))
def dr(a,b,x) : # attempt at factoring
    c = float(a)/b
    return (x, (x-zrc(c,b,+1,+1)) \
              *(x-zrc(c,b,-1,+1)) \
              *(x-zrc(c,b,+1,-1)) \
              *(x-zrc(c,b,-1,-1))   )

def numeric(a,b,x) :
    (x, dt) = d(a,b,x)
    dx = x[1]-x[0]
    return (1/dt).mean()*(x[-1]-x[0])*2 # 2 because we want int from -inf to inf
def theory_residue_thm(a,b) :
    c = complex(a,0)/b
    zpp = zrc(c,b,+1,+1)
    zmp = zrc(c,b,-1,+1)
    zpm = zrc(c,b,+1,-1)
    zmm = zrc(c,b,-1,-1)
    return 2*pi*i* ( 1/((zpp-zpm)*(zpp-zmp)*(zpp-zmm)) + 1/((zpm-zpp)*(zpm-zmp)*(zpm-zmm)) )
def theory_before_plugging_in_roots(a,b) :
    c = complex(a,0)/b
    zpp = zrc(c,b,+1,+1)
    zmp = zrc(c,b,-1,+1)
    zpm = zrc(c,b,+1,-1)
    zmm = zrc(c,b,-1,-1)
    return pi*i/(zpp**2 - zpm**2) * ( 1/zpp - 1/zpm )
def theory_before_mc(a,b) :
    c = complex(a,0)/b
    zpp = zrc(c,b,+1,+1)
    zmp = zrc(c,b,-1,+1)
    zpm = zrc(c,b,+1,-1)
    zmm = zrc(c,b,-1,-1)
    sq = sqrt(1-4*c**2)
    return (-4*pi/b**2) \
           / ((1+sq)**2 - (1-sq)**2)  *  ((1-sq) - (1+sq)) \
                                         /(b/2*(1+sq)*(1-sq))
def theory_final(a,b) :
    return pi/(complex(b)* a**2)

theory = theory_final

PLOT_COMPARISONS = False

def test(a) :
    x = linspace(0,8*a,N-1)
    nA = [] ; tA = []
    if PLOT_COMPARISONS == True :
        figure()
    for b in linspace(a/10.0, 8*a, 500) :
        if PLOT_COMPARISONS == True :
            (x1, dt) = d(a,b,x)
            plot(x1, 1/dt, 'r.')
            (x1, dt) = dr(a,b,x)
            plot(x1, 1/dt, 'b-')
        nA.append(numeric(a,b,x))
        tA.append(theory(a,b))
    figure()
    plot(nA, 'r.', tA, 'b-')

test(10)
test(1)
test(0.1)

show()
