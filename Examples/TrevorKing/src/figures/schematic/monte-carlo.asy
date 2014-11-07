// A die roll decides which of two doors to enter.

//import unicode;
//from three access rotate;

/* Copy three.asy's relevant rotate function, since including three
 * adds an uneccessary movie15 LaTeX dependency.
 */
transform3 rotate(real angle, triple v)
{
  v=unit(v);
  real x=v.x, y=v.y, z=v.z;
  real s=Sin(angle), c=Cos(angle), t=1-c;
  return new real[][] {
    {t*x^2+c,   t*x*y-s*z, t*x*z+s*y, 0},
      {t*x*y+s*z, t*y^2+c,   t*y*z-s*x, 0},
        {t*x*z-s*y, t*y*z+s*x, t*z^2+c,   0},
          {0,         0,         0,         1}};
}

struct Door {
  pair center;
  real angle;
  Label L;
  real width = 3cm;
  real aspect_ratio = (1+sqrt(5))/2; // Golden ratio
  real knob_ratio = 0.10;
  triple inward = (0, 0.4, -1); // x component must be zero for current implementation.

  void draw() {
    picture p; // the door panel
    guide g = yscale(this.aspect_ratio)*scale(this.width)*shift((-0.5,-0.5))*
      unitsquare;
    fill(p, g, white);
    label(p, Label(this.L, (0,0), embed=Scale), (0,0));
    p = shift((-this.width/2.0,0))*xscale(Cos(this.angle))*rotate(-90)*
      slant(-unit(this.inward).y*Sin(this.angle))*
      rotate(90)*shift((this.width/2.0,0))*
      p; // open the door if angle > 0
    clip(p, g);
    fill(shift(this.center)*g); // fill the hole
    add(p, this.center);        // add the door panel
    draw(shift(this.center)*g); // outline the hole again
  }

  void operator init (pair center=(0,0), Label L="", real angle=0) {
    this.center = center;
    this.L = L;
    this.angle = angle;
  }
}

struct Die {
  pair center;
  int top;
  int left;
  bool righthanded = true;
  real side = 1cm;
  real dot_ratio = 0.2;
  triple up = (0, 1, 0.4); // up, but tilted out of the page
  real theta = -20;
  pair[][] pips;

  int right() {
    /* It is traditional to combine pairs of numbers that total seven
     * to opposite faces; this implies that at one vertex the faces 1,
     * 2 and 3 intersect. It leaves one other abstract design choice:
     * the faces representing 1, 2 and 3 respectively can be placed in
     * either clockwise or counterclockwise order about this
     * vertex. If the 1, 2 and 3 faces run counterclockwise around
     * their common vertex, the die is called "right handed"; if they
     * run clockwise it is called "left handed". Standard modern
     * Western dice are right-handed, whereas Chinese dice are often
     * left-handed.
     *  - http://en.wikipedia.org/wiki/Dice
     */
    int little_top = min(this.top, 7-this.top);
    int little_left = min(this.left, 7-this.left);
    int little_right = 6 - little_top - little_left;
    bool righthanded;
    int little_ccw[] = {little_top, little_left, little_right};
    int i = 0;
    little_ccw.cyclic = true;
    while (little_ccw[i] != 1 && i < 3)  i += 1;
    if (i == 3)  return -1;
    if (little_ccw[i+1] == 2)      righthanded = true;
    else                           righthanded = false;
    if (this.top != little_top)    righthanded = !righthanded;
    if (this.left != little_left)  righthanded = !righthanded;
    if (righthanded == this.righthanded)  return little_right;
    return 7-little_right;
  }

  void setup_pips() {
    real d = 1.0/3.5;
    this.pips = new pair[7][];
    this.pips[0] = null;
    this.pips[1].push((0,0));
    this.pips[2].push((-d,d));
    this.pips[2].push((d,-d));
    this.pips[3] = copy(this.pips[2]);
    this.pips[3].push((0,0));
    this.pips[4] = copy(this.pips[2]);
    this.pips[4].push((d,d));
    this.pips[4].push((-d,-d));
    this.pips[5] = copy(this.pips[4]);
    this.pips[5].push((0,0));
    this.pips[6] = copy(this.pips[4]);
    this.pips[6].push((-d,0));
    this.pips[6].push((d,0));
  }

  // z coordinate in face unitvectors will end up facing this.up
  pair transform(pair face_coords, triple face_x, triple face_y) {
    triple face_z = cross(unit(face_x), unit(face_y));
    triple f_c = face_coords.x*face_x + face_coords.y*face_y +0.5*face_z;
    triple u = cross(unit(this.up), (0,0,1));
    if (length(u) > sqrtEpsilon) {
      // rotate z coordinate to point along this.up
      f_c = rotate(-aSin(length(u)), u) * f_c;
    }
    triple c = rotate(this.theta, this.up) * f_c;
    return shift(this.center)*scale(this.side)*(c.x, c.y);
  }

  guide transform(guide face_coords, triple face_x, triple face_y) {
    guide g;
    pair p;
    pair[] c; // for holding Bezier control points
    for (int i=0; i < length(face_coords); ++i) {
      p = this.transform(point(face_coords, i), face_x, face_y);
      if (i == 0) {
        g = g--p;
      } else {
        c = controlSpecifier(face_coords, i-1); // {outgoing, incoming)
        c[0] = this.transform(c[0], face_x, face_y);
        c[1] = this.transform(c[1], face_x, face_y);
        g = g..controls c[0] and c[1]..p;
      }
    }
    if (cyclic(face_coords)) {
      c = controlSpecifier(face_coords, -1);
      c[0] = this.transform(c[0], face_x, face_y);
      c[1] = this.transform(c[1], face_x, face_y);
      g = g..controls c[0] and c[1]..cycle;
    }
    return g;
  }

  void draw_pip(pair z, triple face_x, triple face_y) {
    fill(this.transform(shift(z)*scale(this.dot_ratio/2.0)*unitcircle,
                            face_x, face_y));
  }

  /* azimuth = 0, elevation=90  ->  facing up
   * azimuth = 0, elevation=0   ->  facing out of the page
   * azimuth = 90, elevation=0  ->  facing right
   */
  void draw_face(int number, triple face_x, triple face_y) {
    filldraw(this.transform(shift((-0.5,-0.5))*unitsquare, face_x, face_y),
             white);
    for (pair z : this.pips[number])
      this.draw_pip(z, face_x, face_y);
  }

  void draw() {
    this.draw_face(this.top, face_x=(1,0,0), face_y=(0,1,0));
    this.draw_face(this.left, face_x=(1,0,0), face_y=(0,0,1));
    this.draw_face(this.right(), face_x=(0,0,-1), face_y=(0,1,0));
  }

  void operator init (pair center=(0,0), int top=1, int left=2) {
    this.center = center;
    this.top = top;
    this.left = left;
    this.setup_pips();
  }
}

Door L = Door((-2cm,0),
              L=minipage("\centering{\Large Unfold}\\$P=1/3$\\(\epsdice{1}\epsdice{2})"));
Door R = Door((2cm,0),
              L=minipage("\centering{\Large Stay folded}\\$Q=1-P$\\(\epsdice{3}\epsdice{4}\epsdice{5}\epsdice{6})"),
              angle=30);
Die d = Die((-0.3cm, -2.5cm), top=3, left=5);

L.draw();
R.draw();
d.draw();
