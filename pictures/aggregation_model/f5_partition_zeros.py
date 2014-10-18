from mpmath import *
from pylab import *
from math import log
from pylab_params import *
from cmath import exp as cexp, isnan

# DEBUG at 3.0, final at 7.0
num_points = 10**(7.0)

def Z(beta):
    n = 100
    v =n**5+n**(4+beta)+2*n**(3+2*beta)+n**(2+3*beta)+n**(2+4*beta)+n**(1+5*beta)
    v = v/abs(v)
    return v


def scaleZ(beta):
    zx = Z(beta)
    return zx

    a,b = map(float,[zx.real, zx.imag])
    a = log(abs(a))*sign(a)
    b = log(abs(b))*sign(b)
    zx = complex(a,b)
    return zx

def scaleZ_inv(T):
    zx = Z(1./T)
    return zx 
    a,b = map(float,[zx.real, zx.imag])
    a = log(abs(a))*sign(a)
    b = log(abs(b))*sign(b)
    zx = complex(a,b)
    return zx

fade =  [(0.0,  0.0, 0.0),
         (0.5,  0.5, 1.0),
         (1.0,  1.0, 1.0)
         ]

def fade(x=1.0):
    return ((0.0, x, 0.0),
            (0.25,x/2,x/2),
            (0.5, x, x),
            (1.0, 0.0, 0.0)
            )


from matplotlib.colors import *
cdict = {'red': fade(1.0),
         'green': fade(1.0),
         'blue':  fade(1.0)}


CM = LinearSegmentedColormap('blend_map', cdict)
#register_cmap(cmap=CM)
twopi = 3.1415*2
#print CM(linspace(0,1,20))
#exit()

ZEROS = []

def complex_color(z):
    if abs(z) < .5:

        ZEROS.append(z)
        print z
       
    phase = arg(z)
    while phase < 0: phase += twopi
    while phase >= twopi: phase -= twopi
    phase /= twopi
    #c = CM(float(phase))
    c = cm.hsv(float(phase))
    return c[:-1]


ax  = subplot(1,2,1)
cplot(scaleZ, [0,2],[-1,1],
      points=num_points,verbose=True,axes=ax,
#      color=complex_color
      )

xlabel(r'Re($\beta$)')
ylabel(r'Im($\beta$)')

ax  = subplot(1,2,2)
cplot(scaleZ_inv, [0,2],[-1,1],points=num_points,verbose=True,axes=ax)
xlabel(r'Re($T$)')
ylabel(r'')
ax.set_yticks([]) 


from os import system
f = 'pictures/f5_part_func_zeros'
savefig(f+'.pdf',
        pad_inches=0,transparent=True)
system('pdfcrop %s.pdf' % f)
system('mv %s-crop.pdf %s.pdf' % (f,f))


show()
