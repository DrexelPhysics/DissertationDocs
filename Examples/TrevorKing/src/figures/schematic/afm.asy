// AFM operating principle graphic

//size(x=9cm,keepAspect=true);

import base_afm; // for Cantilever, Substrate, ...

defaultpen(fontsize(size=10pt, lineskip=10pt));

Cantilever c = Cantilever();
// position base so tip touches substrate when bent
c.set_tip_for_dx(8pt);
c.align_tip((0,0));
// unbend the tip and draw it in grey
c.set_tip_for_dx(0);
pair unbent_tip = c.tip;
filldraw(c.tip_guide(), fillpen=grey, grey);
draw(c.arm_guide(), grey);
// rebend the tip and draw it in black
c.set_tip_for_dx(8pt);
filldraw(c.tip_guide(), fillpen=black);
draw(c.arm_guide(), black);
label("Cantilever", c.base-(0,14pt), SW);

Substrate s = Substrate();
s.draw();

Photodiode p = Photodiode(center=(-40pt, 40pt));
p.draw();
label("Photodiode", p.center+(0,p.radius), N);

Laser s = Laser(start=(-5pt,40pt), dir=S, cantilever=c, photodiode=p);
s.draw();
label("Laser", s.start, N);
