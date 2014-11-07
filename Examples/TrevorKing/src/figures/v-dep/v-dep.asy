import wtk_graph;

size(15cm,6cm,IgnoreAspect);

scale(Log, Linear);
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


graphFile("v_dep-5e-5_0.1e-9/v_dep", xscale=xscale, yscale=yscale, p=psoft,
          t=kx_title(kval="5", kexp="-5", xval="0.100"), dots=true);
graphFile("v_dep-1e-5_0.225e-9/v_dep", xscale=xscale, yscale=yscale, p=pmed,
          t=kx_title(kval="1", kexp="-5", xval="0.225"), dots=true);
graphFile("v_dep-5e-5_0.225e-9/v_dep", xscale=xscale, yscale=yscale, p=phard,
          t=kx_title(kval="5", kexp="-5", xval="0.225"), dots=true);
fitFile("v_dep-5e-5_0.1e-9/v_dep.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=xscale, yscale=yscale, p=psoft);
fitFile("v_dep-1e-5_0.225e-9/v_dep.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=xscale, yscale=yscale, p=pmed);
fitFile("v_dep-5e-5_0.225e-9/v_dep.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=xscale, yscale=yscale, p=phard);
xequals(x=1e-6*xscale, p=dashed);

label(sLabel("Pulling speed dependence"), point(N), N);
xaxis(sLabel("Pulling speed (nm/s)"), BottomTop, LeftTicks);
yaxis(sLabel("Unfolding force (pN)"), LeftRight, RightTicks);

add(legend(), point(E), 20E);
