import wtk_graph;

size(15cm,10cm,IgnoreAspect);

scale(Log, Linear);
real xscale=1;
real yscale=1;

graphFile("loading-rate.d/loading_rate_131.98.dat", xscale, yscale, phard, m8,
          t=math(units("131.98","pN/nm")), dots=true);
graphFile("loading-rate.d/loading_rate_24.33.dat", xscale, yscale, red, m8,
          t=math(units("24.33","pN/nm")), dots=true);

xlimits(1,3e3);
ylimits(90,620);

label(sLabel("Loading rate dependence"), point(N),N);
xaxis(sLabel("Loading rate (pN/s)"),BottomTop,LeftTicks);
yaxis(sLabel("Unfolding force (pN)"),LeftRight,RightTicks);

add(legend(),point(E),20E,UnFill);
