import wtk_graph;

size(15cm,10cm,IgnoreAspect);

scale(Log, Linear);
real vscale = 1e9;
real fscale = 1e12;

real vmin = 0.2e-6;
real vmax = 5e-6;

/* f(x) = A + log10(x) + B */
real fn_logxliny(real x, real[] params) {
  return params[0] * log10(x) + params[1];
}

graphFile("v-dep.d/v_dep_127_8", vscale, fscale, p=phard, mpath=m8,
          t=math(units("127","pN/nm"))+", 8 domains", dots=true);
graphFile("v-dep.d/v_dep_27_8", vscale, fscale, p=pmed, mpath=m8,
          t=math(units("27","pN/nm"))+", 8 domains", dots=true);
graphFile("v-dep.d/v_dep_127_30", vscale, fscale, p=phard, mpath=m30,
          t=math(units("127","pN/nm"))+", 30 domains", dots=true);
graphFile("v-dep.d/v_dep_27_30", vscale, fscale, p=pmed, mpath=m30,
          t=math(units("27","pN/nm"))+", 30 domains", dots=true);
graphFile("v-dep.d/v_dep_0.1_1", vscale, fscale, p=psoft, mpath=m1,
          t=math(units("0.1","pN/nm"))+", 1 domain", dots=true);
graphFile("v-dep.d/v_dep_0.1_30", vscale, fscale, p=psoft, mpath=m30,
          t=math(units("0.1","pN/nm"))+", 30 domains", dots=true);
fitFile("v-dep.d/v_dep_127_8.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=vscale, yscale=fscale, p=phard);
fitFile("v-dep.d/v_dep_27_8.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=vscale, yscale=fscale, p=pmed);
fitFile("v-dep.d/v_dep_127_30.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=vscale, yscale=fscale, p=phard);
fitFile("v-dep.d/v_dep_27_30.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=vscale, yscale=fscale, p=pmed);
fitFile("v-dep.d/v_dep_0.1_1.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=vscale, yscale=fscale, p=psoft);
fitFile("v-dep.d/v_dep_0.1_30.fit.dat", f=fn_logxliny,
        xmin=1e-9, xmax=1e-5, xscale=vscale, yscale=fscale, p=psoft);

ylimits(150, 340, crop=true);

label(sLabel("Pulling speed dependence"), point(N), N);
xaxis(sLabel("Pulling speed (nm/s)"), BottomTop, LeftTicks);
yaxis(sLabel("Unfolding force (pN)"), LeftRight, RightTicks);

add(legend(), point(E), 20E, UnFill);
