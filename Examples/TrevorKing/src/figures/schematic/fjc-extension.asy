import wtk_graph;

size(6cm, 4cm, IgnoreAspect);

scale(Linear, Linear);

real n = 100;
real x_min = 0;
real x_max = 0.8;

struct inverse_langevin {
  real y;

  void operator init(real y=0) {
    this.y = y;
  }

  real coth(real x) {  // hyperbolic cotangent
    real e = exp(2*x);
    return (e + 1)/(e - 1);
  }

  real langevin(real x) {
    if (x == 0)
      return 0;
    return coth(x) - 1/x;
  }

  real offset_langevin(real x) {
    return langevin(x) - this.y;
  }

  real langevin_prime(real x) {
    if (x == 0)
      return 1/3;
    return 1 - coth(x)^2 + 1/x^2;
  }

  real inv_langevin(real x) {
    this.y = x;
    return newton(this.offset_langevin, langevin_prime, x1=0, x2=10);
  }
}

inverse_langevin inv_langevin = inverse_langevin();

real fjc(real x) {return inv_langevin.inv_langevin(x);}
real wlc(real x) {return 0.25*(1/(1-x)^2 - 1) + x;}

draw(graph(fjc, x_min, x_max, operator ..), red);
draw(graph(wlc, x_min, x_max, operator ..), dashed + blue);

label(sLabel("Freely-jointed chain extension"), point(N), N);
xaxis(sLabel("End-to-end distance $x/Nl$"), BottomTop, LeftTicks);
yaxis(sLabel("Tension $\frac{Fl}{k_B T}$"), LeftRight, RightTicks);
