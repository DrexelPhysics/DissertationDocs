#!/usr/bin/python

import sys

current_k = None
best_x = None
best_residual = None

data_filename = sys.argv[1]

data = {}
header = None
for line in open(data_filename, 'r'):
    if len(line.strip()) == 0:
        continue
    if line.startswith('#'):
        if header == None:
            header = line.strip()
            continue
    k,x,residual = [float(z) for z in line.split()]
    data[(k,x)] = residual

ks = sorted(set([k for k,x in data.keys()]))
max_k = max(ks)
min_k = min(ks)
xs = sorted(set([x for k,x in data.keys()]))
max_x = max(xs)
min_x = min(xs)
border_xs = xs[:3] + xs[-3:]

print(header)
for k in ks:
    best_x = xs[0]
    best_residual = data[(k,x)]
    for x in xs[1:]:
        residual = data[(k,x)]
        if residual < best_residual:
            best_x = x
            best_residual = residual
    if best_x in border_xs:
        continue # don't print minimums up against the data boundaries
    print('\t'.join([str(z) for z in [k,best_x,best_residual]]))
