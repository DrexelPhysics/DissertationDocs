#!/usr/bin/python

import sys

for line in sys.stdin.readlines():
    if line.startswith('#'):
        if line.startswith('# Xp -> '):
            line = '# Xp -> exp_10[ ' + line[len('# Xp -> '):-1] + ' ]'
        if line.startswith('# Yp -> '):
            line = '# Yp -> exp_10[ ' + line[len('# Yp -> '):-1] + ' ]'
        print line
        continue
    x,y = [float(z) for z in line.split()]
    print '%g\t%g' % (10**x, 10**y)
