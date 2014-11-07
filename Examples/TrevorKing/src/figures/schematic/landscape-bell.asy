import wtk_graph;

size(6cm, 4cm, IgnoreAspect);

scale(Linear, Linear);

real x_min = 0;
real x_max = 1;
real f_min = 0;  // zoom in on region of interest
real f_max = 1;
pair folded = (0.2, 0.2);
pair transition = (0.8, 0.8);
pair forced_transition = (0.8, 0.5);
real dx = 0.1;  // width of energy level lines

void draw_level(pair center, Label label, pen p=currentpen) {
  draw(Scale(center-(dx/2,0)) -- Scale(center+(dx/2,0)), p);
  dot(label, Scale(center));
}

void draw_rate(pair a, pair b, Label label, pen p=currentpen) {
  path arrow_path = Scale(a){dir(70)} .. {dir(-60)}Scale(b);
  draw(arrow_path, p, Arrows, Margin(1, 1));
  label(label, point(arrow_path, length(arrow_path)/2));
}

draw_level(folded, Label("folded", align=S));
draw_level(transition, Label("transition", align=S));
draw_level(forced_transition, Label(
  minipage("\center{forced transition}", 60), align=S), dashed);

draw_rate(folded, transition, Label("$k_{u0}$", align=NW));
draw_rate(folded, forced_transition, Label("$k_{uF}$", align=SE), dashed);

xlimits(x_min, x_max, Crop);
ylimits(f_min, f_max, Crop);

label(sLabel("Bell model unfolding"), point(N), N);
xaxis(sLabel("End-to-end distance $x$"), BottomTop);
yaxis(sLabel("Free energy $U_F$"), LeftRight);
