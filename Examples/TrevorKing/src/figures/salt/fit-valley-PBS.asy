import wtk_graph;

usepackage("amsmath");

size(6cm,4.5cm,IgnoreAspect);

scale(Log, Linear, Log);
real xscale=1;
real yscale=1e9;

graphMatrixFile("fit-valley-PBS.dat", xscale=xscale, yscale=yscale,
                x_label="$k_{u0}$ (s$^{-1}$)", y_label="$\Delta x_u$ (nm)",
                palette_label="$D_\text{JS}$");

label(sLabel("PBS"), point(N),N);
