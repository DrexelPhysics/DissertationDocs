import wiggle;  // for RandomWalk

RandomWalk w = RandomWalk(dx=1cm);
w.align(90);
draw(w.curved_guide(), red);
dot(w.start);
dot(w.end);
