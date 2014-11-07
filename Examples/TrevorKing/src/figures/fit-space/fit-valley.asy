import wtk_graph;

size(8cm,6cm,IgnoreAspect);

scale(Log, Linear, Log);
real xscale=1;
real yscale=1e9;

graphMatrixFile("data", xscale=xscale, yscale=yscale,
                x_label="$k_{uo}$ (s$^{-1}$)", y_label="$\Delta x_u$ (nm)",
                palette_label="$D_\text{JS}$");

label(sLabel("Fit quality"), point(N),N);
