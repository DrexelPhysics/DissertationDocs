import wtk_graph;

size(15cm,10cm,IgnoreAspect);

scale(Log, Linear);
real xscale=1;
real yscale=1;

/* f(x) = A + log10(x) + B */
real fn_logxliny(real x, real[] params) {
  return params[0] * log10(x) + params[1];
}

real xmin = 1.01457e-05;
real xmax = 0.10364;

graphFile("Best_2002_detailed_unfolding_pathway/fig3a.dat", xcol=1, ycol=0,
          xscale=xscale, yscale=yscale, p=psoft, mpath=m30,
          t="Best valley", dots=true);
graphFile("fit-valley.dat", xscale=xscale, yscale=yscale, p=phard, mpath=m30,
          t="King valley", dots=true);
fitFile("Best_2002_detailed_unfolding_pathway/fig3a.dat.fit.dat",f=fn_logxliny,
        xmin=xmin, xmax=xmax, xscale=xscale, yscale=yscale, p=psoft);
fitFile("fit-valley.dat.fit.dat", f=fn_logxliny,
        xmin=xmin, xmax=xmax, xscale=xscale, yscale=yscale, p=phard);

label(sLabel(""), point(N), N);
xaxis(sLabel("$k_{u0}$ ($1/$s)"), BottomTop, LeftTicks);
yaxis(sLabel("$x_u$ (m)"), LeftRight, RightTicks);

add(legend(), point(E), 20E, UnFill);
