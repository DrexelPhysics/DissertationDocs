// This graphic is very similar to landscape.asy

import wtk_graph;

size(6cm, 4cm, IgnoreAspect);

scale(Linear, Linear);

real a = 0.2;
real b = 0.7;
real F = 0.3;
real k = 0.5;
real x_min = 0;
real x_max = 1;
real f_min = 0;
real f_max = 1;

real f_raw(real x) {return -(x-a)*(x-b)**2;}
real f_raw_min = f_raw(x_max);
real f_raw_max = f_raw(x_min);
real f(real x) {return (f_raw(x)-f_raw_min)/(f_raw_max-f_raw_min);}

real x_fold = (2*a+b)/3;
real x_barrier = b;

real const_force(real x) {return f(x_fold)-F*(x-x_fold);}
real force(real x) {return const_force(x)+1/2*k*(x-x_fold)**2;}
real f_force(real x) {return f(x)+(force(x)-f(x_fold));}

draw(graph(f, x_min, x_max, operator ..), blue);
draw(graph(const_force, x_min, x_max, operator ..), dashed);
draw(graph(force, x_min, x_max, operator ..), black);
draw(graph(f_force, x_min, x_max, operator ..), red);

label(sLabel("folded", align=S), Scale((x_fold, f(x_fold))));
label(sLabel("barrier", align=N), Scale((x_barrier, f(x_barrier))));

xlimits(x_min, x_max, Crop);
ylimits(f_min, f_max, Crop);

label(sLabel("Cantilever-altered energy landscape"), point(N), N);
xaxis(sLabel("End-to-end distance $x$"), BottomTop);
yaxis(sLabel("Free energy $U_F$"), LeftRight);
