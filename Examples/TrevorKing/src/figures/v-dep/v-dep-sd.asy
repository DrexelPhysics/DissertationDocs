import wtk_graph;


//size(15cm, 10cm, IgnoreAspect);

picture pic;
size(pic, 13cm, 5cm, IgnoreAspect);

scale(pic, Log, Linear);
real xscale=1e9;
real yscale=1e12;

/* f(x) = A + log10(x) + B */
real fn_logxliny(real x, real[] params) {
  return params[0] * log10(x) + params[1];
}

string kx_title(string kval, string kexp, string xval) {
  return math("k_{u0}=" + units("5"+Exp("-5"),"s$^{-1}$"))
    +", " + math("\Delta x_u=" + units(xval,"nm"));
}

graphFile(pic, "v_dep-5e-5_0.1e-9/v_dep", ycol=2,
          xscale=xscale, yscale=yscale, p=psoft,
          t=kx_title(kval="5", kexp="-5", xval="0.100"), dots=true);
graphFile(pic, "v_dep-1e-5_0.225e-9/v_dep", ycol=2,
          xscale=xscale, yscale=yscale, p=pmed,
          t=kx_title(kval="1", kexp="-5", xval="0.225"), dots=true);
graphFile(pic, "v_dep-5e-5_0.225e-9/v_dep", ycol=2,
          xscale=xscale, yscale=yscale, p=phard,
          t=kx_title(kval="5", kexp="-5", xval="0.225"), dots=true);
fitFile(pic, "v_dep-5e-5_0.1e-9/v_dep-sd.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=xscale, yscale=yscale, p=psoft);
fitFile(pic, "v_dep-1e-5_0.225e-9/v_dep-sd.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=xscale, yscale=yscale, p=pmed);
fitFile(pic, "v_dep-5e-5_0.225e-9/v_dep-sd.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=xscale, yscale=yscale, p=phard);
xequals(pic, x=1e-6*xscale, p=dashed);

xaxis(pic, sLabel("Pulling speed (nm/s)"), BottomTop, LeftTicks);
yaxis(pic, sLabel("Unfolding force (pN)"), LeftRight, RightTicks);
add(pic, legend(pic), point(pic, E), 20E);

picture hist_picture(string datafile,
                     real xmin=-infinity, real xmax=infinity,
                     real ymin=-infinity, real ymax=infinity) {
  picture pic;
  size(pic, 4cm, 3cm, IgnoreAspect);
  scale(pic, Linear, Log);
  histFile(pic, datafile, bin_scale=yscale, low=ymin);
  /* ^-- yscale b/c bins are in Force */
  xlimits(pic, xmin, xmax);
  ylimits(pic, ymin, ymax);
  xaxis(pic, sLabel("Force (pN)"), BottomTop, LeftTicks(N=2), above=true);
  yaxis(pic, sLabel("Frequency"), LeftRight, RightTicks, above=true);
  return pic;
}

/* ensure consistent ranges across all histograms */
real xmin = 100;
real xmax = 900;
real ymin = 1e-4;
real ymax = 1;

add(pic.fit(), (0,0), S);
add(hist_picture("fig4i-5e-5_0.1e-9.hist", xmin, xmax, ymin, ymax).fit(),
    5cm*W, N);
add(hist_picture("fig4i-1e-5_0.225e-9.hist", xmin, xmax, ymin, ymax).fit(),
    (0,0), N);
add(hist_picture("fig4i-5e-5_0.225e-9.hist", xmin, xmax, ymin, ymax).fit(),
    5cm*E, N);
label(sLabel("Pulling speed width dependence"), point(N)+(0,3cm), N);
