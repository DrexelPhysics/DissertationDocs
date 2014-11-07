import wtk_graph;

picture pic;
size(pic, 15cm,5cm,IgnoreAspect);

scale(pic, Linear, Linear);
real xscale=1;
real fscale=1e12;

real g = 0.5772156649;
real kB = 1.3806504e-23;
real T = 300;
real p = 3.7e-10;
real v = 1e-6;
real Kc = 0.05;
real Kwlc = 0.18;
real dx = 0.225e-9;
real ko = 5e-5;
real f = kB*T/dx;

real kappa(real i, real Kc=Kc, real Kwlc=Kwlc) {
  return 1.0/(1.0/Kc + i/Kwlc);
}

real theory(real i, int N, real Kc=Kc, real Kwlc=Kwlc, real ko=ko, real dx=dx,
            real v=v, real T=T, real kB=kB, real g=g) {
  real f = kB*T/dx;
  return f*(log((kappa(i, Kc, Kwlc)*v)/((N-i)*ko*f)) - g);
}

// todo: colorpen(N,i)
graphFile(pic, "data/order.avg-4", xcol=-1, ycol=0,
          xscale=xscale, yscale=fscale, p=psoft, dots=true);
graphFile(pic, "data/order.avg-8", xcol=-1, ycol=0,
          xscale=xscale, yscale=fscale, p=pmed, dots=true);
graphFile(pic, "data/order.avg-12", xcol=-1, ycol=0,
          xscale=xscale, yscale=fscale, p=phard, dots=true);
graphFile(pic, "data/order.avg-16", xcol=-1, ycol=0,
          xscale=xscale, yscale=fscale, p=black, dots=true);
real fn(real x, real[] params) {return theory(i=x, N=4, Kwlc=params[0]);}
fitFile(pic, "data/order.avg-4.fit.dat", f=fn, xmin=0, xmax=3,
        xscale=xscale, yscale=fscale, p=psoft);
real fn(real x, real[] params) {return theory(i=x, N=8, Kwlc=params[0]);}
fitFile(pic, "data/order.avg-8.fit.dat", f=fn, xmin=0, xmax=7,
        xscale=xscale, yscale=fscale, p=pmed);
real fn(real x, real[] params) {return theory(i=x, N=12, Kwlc=params[0]);}
fitFile(pic, "data/order.avg-12.fit.dat", f=fn, xmin=0, xmax=11,
        xscale=xscale, yscale=fscale, p=phard);
real fn(real x, real[] params) {return theory(i=x, N=16, Kwlc=params[0]);}
fitFile(pic, "data/order.avg-16.fit.dat", f=fn, xmin=0, xmax=15,
        xscale=xscale, yscale=fscale, p=black);

xaxis(pic, sLabel("Unfolding peak index $i=N_u$"), BottomTop, LeftTicks);
yaxis(pic, sLabel("Force (pN)"), LeftRight, RightTicks);

picture hist_picture(string datafile,
                     real xmin=-infinity, real xmax=infinity,
                     real ymin=-infinity, real ymax=infinity) {
  picture pic;
  size(pic, 4cm, 3cm, IgnoreAspect);
  scale(pic, Linear, Log);
  histFile(pic, datafile, bin_scale=fscale, low=ymin);
  /* ^-- yscale b/c bins are in Force */
  xlimits(pic, xmin, xmax);
  ylimits(pic, ymin, ymax);
  xaxis(pic, sLabel("Force (pN)"), BottomTop, LeftTicks(N=2), above=true);
  yaxis(pic, sLabel("Frequency"), LeftRight, RightTicks, above=true);
  return pic;
}

/* ensure consistent ranges across all histograms */
real xmin = 100;
real xmax = 380;
real ymin = 1e-4;
real ymax = 1;

add(pic.fit(), (0.0), S);
add(hist_picture("data/hist3i.hist", xmin, xmax, ymin, ymax).fit(),
    5cm*W, N);
add(hist_picture("data/hist3ii.hist", xmin, xmax, ymin, ymax).fit(),
    (0,0), N);
add(hist_picture("data/hist3iii.hist", xmin, xmax, ymin, ymax).fit(),
    5cm*E, N);
label(sLabel("Pulling speed dependence"), point(N)+(0,3cm), N);
