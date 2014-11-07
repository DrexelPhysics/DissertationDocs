// Protein unfolding graphic

//size(x=9cm,keepAspect=true);

import base_afm; // for Cantilever, Substrate, ...
import wiggle;   // for Wiggle

struct ProteinChain {
  // Generate and draw a mixed protein (2nd protein unfolded)
  // starting at START (x,y)
  // of folded length LEN, with NUM segments
  // with the unfolded protein's dimensions given by UNFOLD_LEN and UNFOLD_WID
  // (so the final length with be LEN - LEN/NUM + UNFOLD_LEN
  pair start;
  pair end;
  real angle;
  real len_u = 2cm;
  real len_f = 0.5cm;
  real rough_u = 0.4cm;
  real rough_f = 0.6cm;
  Wiggle prot_u;
  Wiggle prot_f;
  bool folded[];

  void gen_prots() {
    this.prot_u = Wiggle(end=(0,this.len_u), roughness=this.rough_u);
    this.prot_f = Wiggle(end=(0,this.len_f), roughness=this.rough_f);
  }

  pair prot_start(int n) {
    assert(n < this.folded.length);
    pair start = this.start;
    pair u = dir(this.angle);
    for (int i; i < n; i+=1) {
      if (this.folded[i] == true)
        start += u*this.len_f;
      else
        start += u*this.len_u;
    }
    return start;
  }

  Wiggle prot(int n) {
    assert(n < this.folded.length);
    if (this.folded[n] == true)
      return this.prot_f;
    else
      return this.prot_u;
  }

  guide guide() {
    guide g;
    guide p;
    for (int i=0; i < this.folded.length; i+=1) {
      p = shift(this.prot_start(i))*this.prot(i).guide();
      g = g .. p;
    }
    return g;
  }

  void operator init(pair start=(0,0), real angle=90,
                     bool folded[]={true,true,false,true}) {
    this.start = start;
    this.angle = angle;
    this.folded = folded;
    this.gen_prots();
    guide g = this.guide();
    this.end = point(g, length(g));
  }
}

defaultpen(fontsize(size=10pt, lineskip=10pt));

bool folded[] = {true,true,false,true};
ProteinChain p = ProteinChain(folded=folded);
draw(p.guide(), red);
label("\vbox{\hbox{Folded}\hbox{protein}}", p.prot_start(1)+(1.4*p.rough_f, 0)/2, E);
label("\vbox{\hbox{Unfolded}\hbox{protein}}", p.prot_start(2)+(1.3*p.rough_u, p.len_u)/2, E);


Cantilever c = Cantilever();
// position base so tip touches protein when bent
c.set_tip_for_dx(12pt);
c.align_tip(p.end);
// unbend the tip and draw it in grey
c.set_tip_for_dx(0);
pair unbent_tip = c.tip;
filldraw(c.tip_guide(), fillpen=grey, grey);
draw(c.arm_guide(), grey);
// rebend the tip and draw it in black
c.set_tip_for_dx(12pt);
filldraw(c.tip_guide(), fillpen=black);
draw(c.arm_guide(), black);
label("Cantilever", c.base-(0,16pt), SW);

Substrate s = Substrate();
s.draw(dir=S);

real xt_x = -0.45*s.substrate_width;
real xi_x = -0.27*s.substrate_width;
real bar_extra = 6pt;
distance("$x_t$", (xt_x, 0), (xt_x, unbent_tip.y));
distance("$x_c$", (xi_x, c.tip.y), (xi_x, unbent_tip.y));
distance("$x_{f1}$", (xi_x, p.prot_start(3).y), (xi_x, c.tip.y));
distance("$x_u$", (xi_x, p.prot_start(2).y), (xi_x, p.prot_start(3).y));
distance("$x_{f2}$", (xi_x, 0), (xi_x, p.prot_start(2).y));
real y;
y = unbent_tip.y;      draw((xt_x-bar_extra,y)--(xi_x+bar_extra,y));
y = p.prot_start(2).y; draw((xi_x-bar_extra,y)--(xi_x+bar_extra,y));
y = p.prot_start(3).y; draw((xi_x-bar_extra,y)--(xi_x+bar_extra,y));
y = c.tip.y;           draw((xi_x-bar_extra,y)--(xi_x+bar_extra,y));
