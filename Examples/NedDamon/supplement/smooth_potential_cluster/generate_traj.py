from __future__ import division
from math import exp
from pylab import *
from scipy import integrate
from pylab_params import *

TMAX = 200*10**3
dt   = .2

gamma = .0702
q     = .12

def L(x,y,xr,yr):
    return exp(-sqrt((x-xr)**2+(y-yr)**2))
def V(x,y): 
    return L(x,y,0,0) + L(x,y,2,2) + L(x,y,0,-2)
def dxV(x,y): 
    return -x*exp(-sqrt(x**2+y**2))/sqrt(x**2+y**2)-(1/2)*(2*x-4)*exp(-sqrt(x**2-4*x+8+y**2-4*y))/sqrt(x**2-4*x+8+y**2-4*y)-x*exp(-sqrt(x**2+y**2+4*y+4))/sqrt(x**2+y**2+4*y+4)
def dyV(x,y): 
    return -y*exp(-sqrt(x**2+y**2))/sqrt(x**2+y**2)-(1/2)*(2*y-4)*exp(-sqrt(x**2-4*x+8+y**2-4*y))/sqrt(x**2-4*x+8+y**2-4*y)-(1/2)*(2*y+4)*exp(-sqrt(x**2+y**2+4*y+4))/sqrt(x**2+y**2+4*y+4)

msize,mdx = 4, .05
Y,X = mgrid[-msize:msize:mdx, -msize:msize:mdx]
Z = V(X,Y)

from random import uniform

def dX_dt(X,t=0):
    x,y   = X[0],X[1]
    vx,vy = X[2],X[3]

    theta = uniform(0,6.28318531)
    Fvx = -dxV(x,y) - gamma*vx + (q/dt)*cos(theta)
    Fvy = -dyV(x,y) - gamma*vy + (q/dt)*sin(theta)

    return array([-vx, -vy, Fvx, Fvy])

def simple_rk4(X0,F,time):  # No time-dependent potentials!
    R = [X0,]
    for t0,t1 in zip(time,time[1:]):
        dt = t1-t0
        X  = R[-1]
        k1 = dt*F(X)
        k2 = dt*F(X+k1/2)
        k3 = dt*F(X+k2/2)
        k4 = dt*F(X+k3)
        R.append( X+(k1+2*k2+2*k3+k4)/6 )
    return R



if __name__ == "__main__":

    # Generate a long trajectory
    T  = arange(0,TMAX,dt)
    X0 = [0,.1,.65,.45]
    R = simple_rk4(X0, dX_dt, T)
    X,Y,VX,VY = zip(*R)

    skip = 5

    from pickle import *
    FOUT = open("traj.dat",'w')
    dump(X[::skip],FOUT)
    dump(Y[::skip],FOUT)
    FOUT.close()

    print "Drawing picture now"

    figure(1)
    subplot(1,2,1)
    imshow(Z, origin='lower', extent=[-msize,msize,-msize,msize], alpha = .7)

    subplot(1,2,2)
    traj_show = 30*10**3
    plot(X[:traj_show],Y[:traj_show],'k',alpha=.7)
    imshow(Z, origin='lower', extent=[-msize,msize,-msize,msize], alpha = .7)
    xlim(-msize,msize)
    ylim(-msize,msize)

    from pylab_params import PDF_SAVECHOP
    PDF_SAVECHOP('smooth_potential_traj',PNG=True)

    show()



