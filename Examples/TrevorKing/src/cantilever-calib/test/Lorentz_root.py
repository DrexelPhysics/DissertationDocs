from numpy import sqrt, complex

w = 1

def f(g) :
    g = complex(g)
    if g == 0 :
        groupAp = 0
        groupAm = 0
    else :
        rootA = sqrt(1.0-4.0*w**2/complex(g**2))
        groupAp = g**2 /2.0 * (1+ rootA)
        groupAm = g**2 /2.0 * (1- rootA)
    rootBp = sqrt(w**2 - groupAp)
    rootBm = sqrt(w**2 - groupAm)
    return (rootBp, rootBm)

if __name__ == "__main__" :
    import matplotlib
    matplotlib.use('Agg') # select backend that doesn't require X Windows
    import pylab
    from numpy import linspace, array

    gammas = linspace(0,4*w,100)
    roots = []
    for g in gammas :
        Bp, Bm = f(g)
        roots.append( [Bp, Bm, -Bp, -Bm] )
    roots = array(roots)
    print roots.shape
    pylab.figure()
    pylab.subplot(311)
    pylab.plot(roots[:,0].real, roots[:,0].imag, 'r+')
    pylab.plot(roots[:,1].real, roots[:,1].imag, 'bx')
    pylab.plot(roots[:,2].real, roots[:,2].imag, 'k.')
    pylab.plot(roots[:,3].real, roots[:,3].imag, 'k.')
    pylab.subplot(312)
    pylab.plot(gammas, roots[:,0].real, 'r+')
    pylab.plot(gammas, roots[:,1].real, 'bx')
    pylab.subplot(313)
    pylab.plot(gammas, roots[:,0].imag, 'r+')
    pylab.plot(gammas, roots[:,1].imag, 'bx')
    pylab.show()

