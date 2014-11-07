// AFM drawing utilities.

struct Cantilever {
  // draw an AFM cantilever with the tip at TIP (x,y) position on page
  // the cantilever arm is roughly parallel to DIR_TO_BASE (x,y) vector
  // POINT_SCALE x gives the height of the tip.
  pair tip;          // point of the tip
  pair tip_top;      // center of the back side of the tip
  pair tip_distal;   // distal back corner of the tip
  pair tip_proximal; // proximal back corner of the tip

  pair uty;          // unit vector pointing distally at the tip
  pair utx;          // unit vector pointing tip-side at the tip

  pair base;         // location of the cantilever base (chip attachment point)

  pair uy;           // unit vector pointing distally at the base
  pair ux;           // unit vector pointing tip-side at the base

  real arm_length;   // cantilever path length
  real tip_height;   // distance from tip_top to tip
  real rest_angle;   // in degrees.  uy = dir(rest_angle)
  real dx;           // (tip_top offset from unbent) <dot> (ux)
  real theta;        // in radians
  real r_curve;


  void align_tip(pair tip) {
    // shift the whole cantilever setup so the tip rests on TIP.
    pair offset = tip - this.tip;
    this.tip += offset;
    this.tip_top += offset;
    this.tip_distal += offset;
    this.tip_proximal += offset;
    this.base += offset;
  }

  real dx_error(real theta) {
    /* Call the radius of curvature, r_curve=R
     * arm_length=L lies along the perimiter, so
     *   R\theta = L
     * The perpendicular deflection dx is then
     *   R(1-\cos\theta) = L(1-\cos\theta)/\theta = dx
     * and the horizontal displacement L' from the base is
     *   R\sin\theta = L\sin\theta/\theta = L\sinc\theta= L'
     */
     return this.arm_length * (1.0 - cos(theta)) / theta  -  this.dx;
  }

  real dx_prime(real theta) {
    /* d(dx)/d(\theta) = L/\theta * [(\cos\theta-1)/\theta + \sin\theta]  */
    return this.arm_length/theta * ((cos(theta)-1)/theta + sin(theta));
  }

  void set_tip_for_dx(real dx) {
    /* invert dx(theta) using bracketed Newton-Raphson bisection.
     * First order theta from
     *   dx = L(1-\cos\theta)/\theta
     *      = L[1-(1-\theta^2/2!+...)]/\theta
     *      ~= L\theta/2
     *   \theta != 2dx/L
     */
    this.dx = dx;
    real Lp;
    if (dx == 0) {
      this.theta = 0;
      this.r_curve = -1;
      Lp = this.arm_length;
    } else {
      real first_order_theta = 2.0*dx/this.arm_length;
      this.theta = newton(this.dx_error, this.dx_prime,
                          0.1 * first_order_theta,
                          min(3.0 * first_order_theta, pi/2.0));
      /* because we ignored tip_height when we calculated theta, cheat a
       * bit and pretend the tip is directly under our caculated
       * tip_top.  Then adjust tip_top accordingly.  This throws off the
       * bend (and maybe the arm length) a bit, but ah well :p.
       */
      this.r_curve = this.arm_length / this.theta;
      Lp = this.r_curve * sin(this.theta);
    }
    this.uy = dir(this.rest_angle);
    this.ux = dir(this.rest_angle+90);
    this.uty = dir(this.rest_angle+degrees(this.theta));
    this.utx = dir(this.rest_angle+90+degrees(this.theta));
    this.tip = this.base + Lp*this.uy + (dx+this.tip_height)*this.utx;
    this.tip_top = this.tip - this.tip_height*this.utx;
    this.tip_distal = this.tip_top + this.tip_height/3.0*this.uty;
    this.tip_proximal = this.tip_top - this.tip_height/3.0*this.uty;
  }

  guide tip_guide() {
    path p;
    p = this.tip -- this.tip_distal -- this.tip_proximal -- cycle;
    return p;
  }

  guide arm_guide() {
    path p;
    if (this.dx == 0) {
      // all three points should be colinear
      p = this.tip_distal -- this.tip_proximal -- this.base;
    } else {
      p = this.tip_distal -- this.tip_proximal{-this.uty}
          .. tension 0.75 .. {-this.uy}this.base;
      /*      real angle_tip_proximal, angle_base;
      pair center = this.base + this.r_curve*dx;
      angle_tip_proximal = angle(tip_proximal - center);
      angle_base = angle(this.base - center);
      p = tip_distal -- arc(center, this.r_curve, angle_tip_proximal, angle_base);
      tip_proximal{-uty} .. tension 0.75 .. {uy}this.base;
      */
    }
    return p;
  }

  void operator init (pair base=(0,0), real arm_length=2.5cm, real tip_height=0.5cm, real rest_angle=195, real dx=0) {
    this.base = base;
    this.arm_length = arm_length;
    this.tip_height = tip_height;
    this.rest_angle = rest_angle;
    this.set_tip_for_dx(dx);
  }
}

struct Substrate {
  pair prot_connect_point;
  real substrate_width = 3cm;
  real substrate_height = 10pt;
  real piezo_width = 1.5cm;
  real piezo_height = 0.75cm;
  pen substrate_fill = grey;

  path box(pair top_center, real width, real height) {
    real w = width/2;
    pair ul = top_center+(-w,0);
    pair ur = top_center+( w,0);
    pair ll = top_center+(-w,-height);
    pair lr = top_center+( w,-height);
    path p = ul -- ur -- lr -- ll -- cycle;
    return p;
  }

  void draw(pair dir=(0,0)) {
    pair piezo_top = this.prot_connect_point - (0,this.substrate_height);
    pair piezo_bot = this.prot_connect_point - (0,this.substrate_height+this.piezo_height);
    filldraw(this.box(this.prot_connect_point, this.substrate_width, this.substrate_height),
             fillpen=this.substrate_fill);
    label("Substrate", this.prot_connect_point - (0,this.substrate_height/2));
    draw(this.box(piezo_top, this.piezo_width, this.piezo_height));
    label("Piezo", piezo_top, S);
    if (dir != (0,0)) {
      real arrow_length = this.piezo_height/3;
      pair arrow_center = piezo_bot + (0, arrow_length/2 + 2pt);
      arrow(b=arrow_center + dir*arrow_length/2, dir=-dir,
            length=this.piezo_height/3, Arrow(size=8pt),
            margin=NoMargin, L="");
    }
  }

  void operator init(pair prot_connect_point=(0,0)) {
    this.prot_connect_point = prot_connect_point;
  }
}

struct Photodiode {
  pair center;
  real radius = 8pt;
  real x_scale = 0.5;

  void draw(pen fillpen=grey, pen drawpen=defaultpen) {
    pair c = this.center;
    pair y = (0, this.radius);
    pair x = (this.x_scale*this.radius, 0);
    filldraw(shift(this.center)*xscale(this.x_scale)*scale(this.radius)
             *unitcircle, fillpen, drawpen);
    draw((c-x)--(c+x)--c--(c-y)--(c+y), drawpen);
  }

  void operator init(pair center=(0,0)) {
    this.center = center;
  }
}

// extension() added sometime between asy v1.40 and v1.91
pair extension(pair P, pair Q, pair p, pair q)
{
  pair ac=P-Q;
  pair bd=q-p;
  real det=ac.x*bd.y-ac.y*bd.x;
  if(det == 0) return (infinity,infinity);
  return P+((p.x-P.x)*bd.y-(p.y-P.y)*bd.x)*ac/det;
}

struct Laser {
  pair start;
  real width = 2pt; // width at start (the laser source)
  real spot = 1pt;  // width at the cantilever reflection point (minimum)
  pair dir;
  Cantilever cantilever;
  Photodiode photodiode;

  void draw(pen fillpen=red) {
    pair w = scale(this.width/2)*rotate(90)*this.dir;
    pair rw = scale(this.spot/2)*this.cantilever.uty;
    if (dot(w, rw) < 0) rw = -rw; // ensure similar direction
    // find point of reflection off cantilever.
    pair ref = extension(this.start, this.start+this.dir,
                         this.cantilever.tip_distal,
                         this.cantilever.tip_proximal);
    // find direction of reflection post-cantilever
    pair post_dir = reflect((0,0), this.cantilever.uty)*dir;
    pair contact = extension(ref, ref+post_dir,
                             this.photodiode.center,
                             this.photodiode.center+N);
    real contact_width = this.width; ///length(ref-this.start)*length(ref-contact);
    pair cw = scale(contact_width)*rotate(90)*post_dir;
    if (dot(cw, rw) < 0) cw = -cw; // ensure similar direction
    // laser -> cant.
    fill((start+w)--(start-w)--(ref-rw)--(ref+rw)--cycle, fillpen);
    // cant. -> photo.
    fill((contact+cw)--(contact-cw)--(ref-rw)--(ref+rw)--cycle, fillpen);
  }

  void operator init(pair start, pair dir=S, Cantilever cantilever,
                     Photodiode photodiode) {
    this.start = start;
    this.dir = unit(dir);
    this.cantilever = cantilever;
    this.photodiode = photodiode;
  }
}

void distance(Label L, pair start, pair end) {
  pair center = (start+end)/2;
  pair u = unit(end-start);
  picture picL;
  label(picL, L);
  pair label_size = 1.2 * (max(picL)-min(picL));
  real arrow_length = length(end-start)/2 - label_size.y;
  if (arrow_length > 4pt) {
    arrow(b=start, dir=u, length=arrow_length, Arrow(size=4pt), L="");
    arrow(b=end, dir=-u, length=arrow_length, Arrow(size=4pt), L="");
  }
  label(L, center);
}
