#!/usr/bin/python

import sys
from scipy.stats import linregress
from math import log10

fname = sys.argv[1]

WEIGHTHACK=True
LOGX=True

x = []
y = []
w = [] # weights

sys.stderr.write('Fitting data from {}\n'.format(fname))
for line in open(fname, 'r'):
    fields = [float(a) for a in line.strip().split()]
    if WEIGHTHACK==True:
        w = int(fields[3])
        x.extend([fields[0]]*w)
        y.extend([fields[1]]*w)
    else:
        x.append(fields[0])
        y.append(fields[1])
        w.append(fields[3])

if LOGX == True:
    slope,intercept,r,two_tailed_prob,stderr_of_the_estimate = linregress([log10(xi) for xi in x],y)
else:
    slope,intercept,r,two_tailed_prob,stderr_of_the_estimate = linregress(x,y)
#print(' '.join(str(x) for x in [
#            slope,intercept,r,two_tailed_prob,stderr_of_the_estimate]))

def f(x):
    if LOGX == True:
        x = log10(x)
    val = intercept+slope*x
    return val

x.sort()
xmin = x[0]
xmax = x[-1]
print('#fitted line')
print('{}\t{}'.format(xmin, f(xmin)))
print('{}\t{}'.format(xmax, f(xmax)))
