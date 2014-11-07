import wtk_graph;

size(6cm, 4cm, IgnoreAspect);

scale(Linear, Linear);

file fin = input('backlash.data');
real[][] a = fin.dimension(0, 2);
a = transpose(a);
real[] x = a[0];
real[] d = a[1];
graphData(x=x - x[0], y=d - d[0], mpath=mcross, dots=true);

xaxis(sLabel("Stepper position (steps)"), BottomTop, LeftTicks);
yaxis(sLabel("Deflection (V)"), LeftRight, RightTicks);
label(sLabel("Backlash"), point(N), N);
