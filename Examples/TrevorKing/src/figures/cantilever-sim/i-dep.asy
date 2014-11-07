import wtk_graph;

size(15cm,10cm,IgnoreAspect);
scale(Linear, Linear);
real xscale=1;
real yscale=1e12;

graphFile("i-dep.d/i_dep_127_8_1e-6", xscale, yscale, phard, m8,
          t=math(units("127","pN/nm"))+", 8 domains");
graphFile("i-dep.d/i_dep_27_8_1e-6", xscale, yscale, pmed, m8,
          t=math(units("27","pN/nm"))+", 8 domains");
graphFile("i-dep.d/i_dep_127_30_1e-6", xscale, yscale, phard, m30,
          t=math(units("127","pN/nm"))+", 30 domains");
graphFile("i-dep.d/i_dep_27_30_1e-6", xscale, yscale, pmed, m30,
          t=math(units("27","pN/nm"))+", 30 domains");
graphFile("i-dep.d/i_dep_0.1_1_1e-6", xscale, yscale, psoft, m1,
          t=math(units("0.1","pN/nm"))+", 1 domain");
graphFile("i-dep.d/i_dep_0.1_30_1e-6", xscale, yscale, psoft, m30,
          t=math(units("0.1","pN/nm"))+", 30 domains");

ylimits(140, 320);

label(sLabel("Peak index dependence ($"+units("1.0","$\mu$m/s")+"$)"),
      point(N), N);
xaxis(sLabel("Peak index"), BottomTop, LeftTicks);
yaxis(sLabel("Unfolding force (pN)"), LeftRight, RightTicks);

add(legend(), point(E), 20E, UnFill);
