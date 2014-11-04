from pylab import *
from pylab_params import *
from os import system

SMOOTH = 1000   # ramp up for smoother plots

def xt(beta,n):
    x = exp(beta*log(n))
def lnZ(beta,n):
    x = exp(beta*log(n))
    return log(n**5+n**4*x+2*n**3*x**2+n**2*x**3+n**2*x**4+n*x**5)

def lnZ(beta,n):
    return (n**5+n**(4+beta)+2*n**(3+2*beta)+n**(2+3*beta)+n**(2+4*beta)+n**(1+5*beta))


B = linspace(.01, 2, SMOOTH)
N = 100**4

ZX = lnZ(B,N)


P5 = N**5 / ZX
P4 = N**(4+B) /  ZX
P3 = (2*N**(3+2*B)) / ZX
P2 = N**(2+3*B)/ ZX
P1 = N**(2+4*B)/ ZX
P0 = N**(1+5*B)/ ZX

th = 3
a = .6

plot(B,P5,lw=th+3,label=r'monomers',alpha=a)
plot(B,P4,lw=th,alpha=a)
plot(B,P3,lw=th,alpha=a)
plot(B,P2,lw=th,alpha=a)
plot(B,P1,'k--',lw=th-1,label=r'dimers',alpha=a)
plot(B,P0,lw=th,label=r'pentamers',alpha=a)
xlabel(r'$\beta$')
ylabel('$P(k)$')
legend()

f = 'pictures/N=5_PZ'
savefig(f+'.pdf')
system('pdfcrop %s.pdf' % f)
system('mv %s-crop.pdf %s.pdf' % (f,f))




figure(2)

def CVcalc(n,beta):
    return beta**2*log(n)**2*(4*n**(5+4*beta)+34*n**(5+5*beta)+24*n**(4+6*beta)+2*n**(4+5*beta)+19*n**(3+7*beta)+4*n**(2+8*beta)+n**(2+9*beta)+11*n**(6+3*beta)+16*n**(6+4*beta)+8*n**(7+2*beta)+n**(8+beta))/(n*(n**4+n**(3+beta)+2*n**(2+2*beta)+n**(1+3*beta)+n**(1+4*beta)+n**(5*beta))**2)

CV = CVcalc(N, B)
plot(B,CV,'k',lw=5,alpha=.8)
xlabel(r'$\beta$')
ylabel('$C_V$')

f = 'pictures/N=5_CV'
savefig(f+'.pdf')
system('pdfcrop %s.pdf' % f)
system('mv %s-crop.pdf %s.pdf' % (f,f))

show()
