import matplotlib
matplotlib.use('Agg') # select backend that doesn't require X Windows
from pylab import *
from numpy import *

N=100
root_height = 1
i = complex(0,1)

def d(a,b,x) : # know denominator
    return (x, ((a**2 - x**2)**2 + (b*x)**2))
def rm(r, height) : # root marker
    return ([r, r], float(height) * array([0.0001,1]))
def zr(a,b,p,q) : # p, q \in {-1,1}
    return p*i*b/2.0 * (1 + q*sqrt(complex(1,0) - (2*a/b)**2))
def rp(a,b,p,q,h) : # plot root
    (x,d) = rm(zr(a,b,p,q), h)
    if x[0].imag == 0 and x[0] > 0 : plot(x,d,'-x')
    print "Root at ", x[0]
def dr(a,b,x) : # attempt at factoring
    return (x, (x-zr(a,b,+1,+1)) \
              *(x-zr(a,b,-1,+1)) \
              *(x-zr(a,b,+1,-1)) \
              *(x-zr(a,b,-1,-1))   )
def testroots(a,b,x) :
    figure()
    hold(True)
    (x,dt) = d(a, b, x)
    plot(x,dt,'.')
    print "For a = %g, b = %g" % (a, b)
    rp(a,b,+1,+1, root_height)
    rp(a,b,-1,+1, root_height*2)
    rp(a,b,+1,-1, root_height*3)
    rp(a,b,-1,-1, root_height*4)
    title("For a = %g, b = %g" % (a, b))
def testfn(a,b,x) :
    figure()
    hold(True)
    (x,dt) = d(a, b, x)
    plot(x,1/dt,'-')
    (x,dt) = dr(a, b, x)
    plot(x,1/dt,'.')
    title("For a = %g, b = %g" % (a, b))

ioff()

plot = semilogy

# critically damped for b^2 = 4a^2
#for b in [0.1, 1, 2, 4, 6] :
#    testroots(a,b,x)
a = 10.0
x = linspace(0,4*a,N-1)
for b in linspace(a/10, 4*a, 5) :
    testfn(a,b,x)
a = 1.0
x = linspace(0,4*a,N-1)
for b in linspace(a/10, 4*a, 5) :
    testfn(a,b,x)
a = .1
x = linspace(0,4*a,N-1)
for b in linspace(a/10, 4*a, 5) :
    testfn(a,b,x)

show()
