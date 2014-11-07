import matplotlib
matplotlib.use('Agg') # select backend that doesn't require X Windows
from pylab import *
from numpy import *

N=100
root_height = 1
i = complex(0,1)

def zr(a,b,p,q) : # p, q \in {-1,1}
    return p*i*b/2.0 * (1 + q*sqrt(complex(1,0) - (2*a/b)**2))
def zrc(c,b,p,q) : # p, q \in {-1,1}
    return p*i*b/2.0 * (1 + q*sqrt(complex(1,0) - (2*c)**2))
def loc_roots(c,b) :
    figure()
    subplot(311)
    hold(True)
    dpp = zrc(c,b,+1,+1)
    dmp = zrc(c,b,-1,+1)
    dpm = zrc(c,b,+1,-1)
    dmm = zrc(c,b,-1,-1)
    plot(dpp.real,dpp.imag,'ro', label="++")
    plot(dmp.real,dmp.imag,'b+', label="-+")
    plot(dpm.real,dpm.imag,'gx', label="+-")
    plot(dmm.real,dmm.imag,'k.', label="--")
    title('plane')
    legend(loc='upper right')
    subplot(312)
    plot(c, dpp.real,'ro',
         c, dmp.real,'b+',
         c, dpm.real,'gx',
         c, dmm.real,'k.')
    title('real')
    subplot(313)
    plot(c, dpp.imag,'ro',
         c, dmp.imag,'b+',
         c, dpm.imag,'gx',
         c, dmm.imag,'k.')
    title('imag')

ioff()

# critically damped for b^2 = 4a^2
# so for c = a/b = 0.5
#for b in [0.1, 1, 2, 4, 6] :
#    testroots(a,b,x)
c = linspace(0,4,N-1)
loc_roots(c,1)

        FIGURE.savefig("figure.png")
show()
