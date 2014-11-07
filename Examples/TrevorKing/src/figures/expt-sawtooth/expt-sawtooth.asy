import wtk_graph;

size(6cm,4cm,IgnoreAspect);

scale(Linear, Linear);
real k = infinity; /* spring constant in N/m, already accounted for (0.05) */
real xscale=1e9;
real fscale=1e12;

real xmin = -5e-9;
real xmax = 300e-9;
real fmin = -100e-12;
real fmax = 1000e-12;
real fnmax = 300e-12;

real kB = 1.3806504e-23;
real T = 300;
real p = 3.7e-10;
real WLC(real x, real L, real p=p, real T=T, real kB=kB,
         real xLmax=0.99, real fmax=fnmax) {
  real f = infinity;
  if (x < 0)
    return infinity;
  if (x/L <= xLmax)
    f = kB*T/p*(0.25*(1/(1-x/L)^2 - 1) + x/L);
  if (f > fnmax)
    return infinity;
  return f;
}

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

/* expt.dat already scaled to nm and pN */
graphSawtooth("expt.dat", k=k, p=psoft);

file fin = input('expt-Ls.dat').line();
real[][] a = fin.dimension(0,0);
a = transpose(a);
real[] Ls = a[0];
int i;
for (i=0; i<Ls.length; ++i) {
  real fn(real x) {
    real f = WLC(x / xscale, L=Ls[i]);
    if (f == infinity) {
      write(x, fnmax*fscale * 1.1);
      return fnmax*fscale * 1.1;
    }
    write(x, f*fscale);
    return f*fscale;
  }
  draw(graph(fn, a=0, b=0.9*Ls[i]*xscale), p=phard);
}

xlimits(xmin*xscale, xmax*xscale, crop=true);
ylimits(fmin*fscale, fmax*fscale, crop=true);

xaxis(sLabel("Distance (nm) ($x_t-x_c$)"), BottomTop, LeftTicks);
yaxis(sLabel("Force (pN)"), LeftRight, RightTicks);
label(sLabel("Poly-ubiquitin force curve"), point(N), N);
