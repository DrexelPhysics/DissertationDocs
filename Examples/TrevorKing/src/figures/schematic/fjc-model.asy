import wiggle;  // for RandomWalk

RandomWalk w = RandomWalk(dx=1cm);
w.align(90);
guide g = w.straight_guide();
draw(g, red);
dot(g, linewidth(2pt) + blue);
dot(w.start);
dot(w.end);
