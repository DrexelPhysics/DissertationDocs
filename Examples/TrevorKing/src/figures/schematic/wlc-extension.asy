import wtk_graph;

size(6cm, 4cm, IgnoreAspect);

scale(Linear, Linear);

real x_min = 0;
real x_max = 0.8;

real wlc(real x) {return 0.25*(1/(1-x)^2 - 1) + x;}

draw(graph(wlc, x_min, x_max, operator ..), red);

label(sLabel("Wormlike chain extension"), point(N), N);
xaxis(sLabel("End-to-end distance $x/L$"), BottomTop, LeftTicks);
yaxis(sLabel("Tension $\frac{Fp}{k_B T}$"), LeftRight, RightTicks);
