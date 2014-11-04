from pylab import *
g = array([1,2,5])
E = array([-4,-2,0])

T = linspace(.01, 5, 100)

P = array(zip(*[g*exp(-E/t) / (g*exp(-E/t)).sum() for t in T]))

figure(1)

th = 5
a = .7
plot(T,P[0],lw=th,label=r'$E_1$',alpha=a)
plot(T,P[1],lw=th,label=r'$E_2$',alpha=a)
plot(T,P[2],lw=th,label=r'$E_3$',alpha=a)
xlabel(r'$kT$')
ylabel(r'$P(E)$')
legend()
savefig('three_level_E.pdf')

figure(2)
CV = zeros(T.shape)
for n,t in enumerate(T):
    Z = g*exp(-E/t)
    Ex  = ((E*Z)/Z.sum()).sum()
    Ex2 = ((E*E*Z)/Z.sum()).sum()
    CV[n] = Ex2-Ex**2

plot(T,CV,'k',lw=th)
xlabel(r'$kT$')
ylabel(r'$C_V(T)$')
savefig('three_level_CV.pdf')
show()

#for t in T:
#    Z = g*exp(-E/t)
#    print Z
