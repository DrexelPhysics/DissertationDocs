# Approximation of the specific heat to the higher energies
from pylab import *
from scipy.integrate import quad
from pylab_params import *
def E(x): return x-6
def g(x): return exp(-(x-3)**2/2)
def G(A,B):
    return quad(g,A,B)[0]

cut  = -1
from sys import argv
try: cut = float(argv[1])
except:
    print "First param is the cut from 3"
    exit()


left_end, right_end = 0, 6
points = 200
X = linspace(left_end, right_end, points)
XC= linspace(cut,right_end, points)

subplot(1,2,1)
plot(X,g(X),'k',lw=6)
fill_between(XC,g(XC), color='r',alpha=.8)
xlabel(r'$x$')
ylabel(r'$g(x)$')

from matplotlib.patches import Rectangle
r = Rectangle((0, 0), 1, 1,color='r',alpha=.8) # creates rectangle patch for legend use.
legend([r], ["macrostate"])

axis('tight')

def CV(BETA,X,a,b,cut):
    cv = []
    dx = float(b-a)/len(X)
    GX = array([G(y,y+dx) for y in X])
    EX = E(X)

    for beta in BETA:
        Z    = sum(GX*exp(-beta*EX))
        EXv  = sum(GX*exp(-beta*EX)*EX) / Z
        EX2v = sum(GX*exp(-beta*EX)*EX**2) / Z
        cv.append( (EX2v-EXv**2)*beta**2 )
    return cv

def CV_approx(BETA,X,a,b,cut):
    X2 = X[X<cut]
    Xother = X[X>=cut]
    
    dx = float(b-a)/len(X2)
    GX = array([G(y,y+dx) for y in X2])
    cv = []
    EX = E(X2)

    GX_other = array([G(y,y+dx) for y in Xother])
    Eavg = E(Xother)*GX_other
    Eavg = Eavg/GX_other.sum()
    Eavg = Eavg.mean()
    GX_other_total = GX_other.sum()

    val= GX_other_total/(GX_other_total+GX.sum())

    for beta in BETA:
        Z    = sum(GX*exp(-beta*EX))

        Z += GX_other_total * exp(-beta*Eavg)
    
        EXv  = sum(GX*exp(-beta*EX)*EX) 
        EX2v = sum(GX*exp(-beta*EX)*EX**2)

        EXv  += GX_other_total * exp(-beta*Eavg) * Eavg
        EX2v += GX_other_total * exp(-beta*Eavg) * Eavg**2

        EXv  /= Z
        EX2v /= Z
        cv.append( (EX2v-EXv**2)*beta**2 )
    return cv,val

B = linspace(.1,20,2000)

subplot(1,2,2)

CV1 = CV(B, X, left_end,right_end,cut)
plot(B, CV1,lw=3,alpha=.8,label=r'exact')


CV2,val = CV_approx(B,X,left_end,right_end,cut)
plot(B, CV2,'r--',lw=3,label=r'$CV_\epsilon$')
xlabel(r'$T$')
ylabel(r'$C_V$')
ylim(0,4)
legend()

from pylab_params import PDF_SAVECHOP
f = "macrostate_epsilon_%s_%s" % (str(val).split('.')[1], int(cut))

PDF_SAVECHOP(f)
#show()
