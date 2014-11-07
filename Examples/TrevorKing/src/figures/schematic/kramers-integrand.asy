import palette;
import wtk_graph;

real a = 0.2;
real b = 0.7;
real x_min = 0;
real x_max = 1;
real f_min = 0;  // zoom in on region of interest
real f_max = 1;
real n = 20;     // number of integration traces

real f_raw(real x) {return -(x-a)*(x-b)**2;}
real f_raw_min = f_raw(x_max);
real f_raw_max = f_raw(x_min);
real f(real x) {return (f_raw(x)-f_raw_min)/(f_raw_max-f_raw_min);}

real ep(real x) {return (exp(f(x)));}
real em(real x) {return (exp(-f(x)));}
real integrand(real x, real y) {return (ep(y) * em(x));}

picture pic1;
scale(pic1, Linear, Linear);
image(pic1, integrand, (x_min, x_min), (x_max, x_max), BWRainbow());
real x;
for (int i = 1; i <= n; ++i) {
  x = x_min + i*(x_max-x_min)/(n + 1);
  draw(pic1, (0, x) -- (x, x));
}
size(pic1, 5cm, 5cm, point(pic1, SW), point(pic1, NE));
label(pic1, sLabel("Kramers integrand"), point(pic1, N), align=N);
frame f1 = shift((2cm, 0)) * pic1.fit();
add(f1);

picture pic2;
scale(pic2, Linear, Linear);
draw(pic2, graph(em, x_min, x_max, operator ..), red);
size(pic2, 5cm, 1cm, point(pic2, SW), point(pic2, NE));
xaxis(pic2, sLabel("$x'$"), Bottom);
frame f2 = pic2.fit();
f2 = shift((min(f1).x - min(f2).x, min(f1).y - max(f2).y)) * f2;
add(f2);
label(Label("$e^{-U(x')}$"), (max(f2)+min(f2))/2 + (-18pt, 0));

picture pic3;
scale(pic3, Linear, Linear);
draw(pic3, rotate(90)*graph(ep, x_min, x_max, operator ..), red);
size(pic3, 1cm, 5cm, point(pic3, SW), point(pic3, NE));
yaxis(pic3, sLabel("$x$"), Left);
frame f3 = pic3.fit();
f3 = shift((min(f1).x - max(f3).x, min(f1).y - min(f3).y)) * f3;
add(f3);
label(rotate(90)*Label("$e^{U(x)}$"), (max(f3)+min(f3))/2 + (0, -18pt));
