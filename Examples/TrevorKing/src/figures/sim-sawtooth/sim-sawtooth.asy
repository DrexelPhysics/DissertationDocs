import wtk_graph;

size(6cm,4cm,IgnoreAspect);

scale(Linear, Linear);
real k = 0.05; /* spring constant in N/m */
real xscale=1e9;
real fscale=1e12;

void graphSawtooth(string file="datafile", real k,
                   int xcol=0, int fcol=1,
                   real xscale=1, real fscale=1, real dx=0, real df=0,
                   pen p=red) {
  file fin=input(file).line();
  real[][] a=fin.dimension(0,0);
  a=transpose(a);
  real[] x=a[xcol];
  real[] f=a[fcol];
  x = x - f/k; /* Remove cantilever extension */
  graphData(x=x, y=f, xscale=xscale, yscale=fscale,
            dx=dx, dy=df, p=p, dots=false);
}

graphSawtooth("fig1.dat", k=k, xscale=xscale, fscale=fscale, p=psoft);
graphSawtooth("fig2.dat", k=k, xscale=xscale, fscale=fscale,
              df=200e-12, p=pmed);
graphSawtooth("fig3.dat", k=k, xscale=xscale, fscale=fscale,
              df=400e-12, p=phard);

xaxis(sLabel("Distance (nm) ($x_t-x_c$)"), BottomTop, LeftTicks);
yaxis(sLabel("Force (pN)"), LeftRight, RightTicks);
label(sLabel("Simulated force curves"), point(N), N);
