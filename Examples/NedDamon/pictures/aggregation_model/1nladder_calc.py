from mpmath import *
from pylab_params import *
from pylab import *
from math import log
from cmath import exp as cexp, isnan

# DEBUG at 3.0, final at 7.0
num_points = 10**(7.0)
MAXV = 10.**100

def Z(beta):
    n = 200
    q = 2
    J1 = -1
    v1 = cexp(J1*beta)-1
    zx = q*(v1+q)**(n-1)
    return zx


def scaleZ(beta):
    try:
        zx = Z(beta)
    except: return MAXV
    if isnan(zx) or isinf(zx): return MAXV
    
    zx = Z(beta)
    vx = abs(zx)
    s = log(vx)/5
    #s = vx
    return zx * (s/vx)

def scaleZ_inv(beta):
    try:
        zx = Z(1./beta)
    except: return MAXV
    if isnan(zx) or isinf(zx): return MAXV
    
    vx = abs(zx)
    s = log(vx)/5
    #s = vx
    return zx * (s/vx)

ax  = subplot(1,2,1)
cplot(scaleZ, [-3,3],[-3,3],points=num_points,verbose=True,axes=ax)
xlabel(r'Re($\beta$)')
ylabel(r'Im($\beta$)')

ax  = subplot(1,2,2)
span = .5
cplot(scaleZ_inv, [-span,span],[-span,span],
      points=num_points,verbose=True,axes=ax)
xlabel(r'Re($T$)')
ylabel(r'Im($\beta$)')
#ylabel(r'')
#ax.set_yticks([])



from os import system
f = 'pictures/zeros_parition_func_1N_ladder_2'
savefig(f+'.pdf',
        pad_inches=0,transparent=True)
system('pdfcrop %s.pdf' % f)
system('mv %s-crop.pdf %s.pdf' % (f,f))


show()

