// Upper half plane contour integral

import graph;
size(5cm, 5cm);

real r=2cm;

pen p_axes = linewidth(0.5*linewidth())+grey;
draw((-1.2r,0)--(1.2r,0), p_axes, Arrow);
label("Re", (1.2r, 0), S);
draw((0,0)--(0,1.2r), p_axes, Arrow);
label("Im", (0, 1.2r), W);

pen p_contour = linewidth()+blue;
draw((-r,0)--(r,0), p_contour);
draw((0,0)--(r/2,0), p_contour, Arrow);
draw(arc((0,0), r, 0, 180, CCW), p_contour);
