import wtk_graph;

size(15cm,10cm,IgnoreAspect);

scale(Log, Linear);
real xscale=1e12;
real yscale=1e12;

graphFile(file="loading-rate.d/loading_rate_dep_127_8",
          xscale=xscale, yscale=yscale, p=phard, mpath=mdot,
          t=math(units("127","pN/nm")), dots=true);
graphFile(file="loading-rate.d/loading_rate_dep_27_8",
          xscale=xscale, yscale=yscale, p=red, mpath=mdot,
          t=math(units("27","pN/nm")), dots=true);

xlimits(20,7e5);
ylimits(40,400);

label(sLabel("Loading rate dependence (8 domains)"), point(N),N);
xaxis(sLabel("Loading rate (pN/s)"),BottomTop,LeftTicks);
yaxis(sLabel("Unfolding force (pN)"),LeftRight,RightTicks);

add(legend(),point(E),20E,UnFill);
