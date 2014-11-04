from pylab_params import *
from pylab import *

plot_points = 200

def CV_eq(beta):
    return beta**2*(n-1)*J**2*exp(J*beta)*(-1+q)/(exp(J*beta)-1+q)**2

J = -1.0
n = 10**6
q = 2


beta = linspace(0,10,plot_points)
CV = CV_eq(beta)/n

plot(beta,CV,lw=6,alpha=.7)

xlabel(r'$\beta$')
ylabel(r'$C_V / N$')
ylim(0,.5)

# See MAPLE sheet for these values

beta_c = 2.399357280
CV_c   = 0.4392284008

scatter( [beta_c,],[CV_c], s=800, alpha=.5,color='r')
text(beta_c+.5,CV_c-.01,r"$\beta_C=%.4f$" % beta_c,fontsize=30)

from pylab_params import PDF_SAVECHOP
PDF_SAVECHOP("CV_curve_potts_1N_ladder")

show()

