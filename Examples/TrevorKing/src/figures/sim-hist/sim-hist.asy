import wtk_graph;


size(6cm, 4cm, IgnoreAspect);

scale(Linear, Log);
real fscale=1e12;

pen p = psoft;

histFile("hist.hist", bin_scale=fscale, fillpen=(p+opacity(0.3)), drawpen=p);

//set xrange [100:400]
//#set yrange [0.0001:1]
//xlimits(pic, xmin, xmax);
//ylimits(pic, ymin, ymax);
xaxis(sLabel("Force (pN)"), BottomTop, LeftTicks, above=true);
yaxis(sLabel("Frequency"), LeftRight, RightTicks, above=true);
