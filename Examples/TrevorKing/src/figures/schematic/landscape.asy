import wtk_graph;

size(6cm, 4cm, IgnoreAspect);

scale(Linear, Linear);

real a = 0.2;
real b = 0.6;
real x_min = 0;
real x_max = 1;
real f_min = 0.5;  // zoom in on region of interest
real f_max = 0.8;
real x_arrow = 0.2;  // range around x_barrier
real y_arrow = 0.08;  // offset above U_F(x)
real state_size = 7pt;  // size of current-state dot

real f_raw(real x) {return -(x-a)*(x-b)**2;}
real f_raw_min = f_raw(x_max);
real f_raw_max = f_raw(x_min);
real f(real x) {return (f_raw(x)-f_raw_min)/(f_raw_max-f_raw_min);}
real f_arrow(real x) {return (f(x) + y_arrow);}

// df/dx = -(x-b)**2 - 2(x-a)(x-b)
// at the extremes, df/dx = 0, so
//   (x-b)**2 = -2(x-a)(x-b)
//   so
//        x-b = 0
//          x = b
//   or
//    -2(x-a) = (x-b)
//          x = (2a + b)/3

real x_fold = (2*a+b)/3;
real x_barrier = b;
real x_unfold = (2*b + x_max)/3;
real x_state = (3*x_fold + x_barrier)/4;

path f_path = graph(f, x_min, x_max, operator ..);
draw(f_path, blue);

path arrow_path = graph(f_arrow, x_barrier-x_arrow/2, x_barrier+x_arrow/2,
  operator ..);
draw(arrow_path, Arrow);
label(sLabel("$k_u$", align=N), point(arrow_path, length(arrow_path)/2));

real[] state_ts = intersect(f_path, (x_state, f_min)--(x_state, f_max));
real state_t = state_ts[0];  // time along f_path
pair state_perp = scale(1/10cm)*rotate(90)*dir(f_path, state_t);
pair state_point = (x_state, f(x_state)) + state_perp*state_size/2;
pen state_pen = linewidth(state_size) + currentpen;

label(sLabel("folded", align=S), Scale((x_fold, f(x_fold))));
label(sLabel("barrier", align=N), Scale((x_barrier, f(x_barrier))));
label(sLabel("unfolded", align=NE), Scale((x_unfold, f(x_unfold))));
dot(Scale(state_point), state_pen);
label(sLabel("state", align=N), Scale(state_point) + (0, state_size/20cm));

xlimits(x_min, x_max, Crop);
ylimits(f_min, f_max, Crop);

label(sLabel("Unfolding energy landscape"), point(N), N);
xaxis(sLabel("End-to-end distance $x$"), BottomTop);
yaxis(sLabel("Free energy $U_F$"), LeftRight);
