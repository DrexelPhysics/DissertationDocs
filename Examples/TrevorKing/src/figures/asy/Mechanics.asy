/* Useful functions for drawing Physics 101 figures.
 *
 * Copyright (C) 2008-2011 W. Trevor King <wking@drexel.edu>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

import geometry;
import three;

// ----------------- Labeled circle --------------------

void label_path(picture pic=currentpicture, Label L, path g, real margin=0,
                pair rdir=0) {
  align a = L.align;
  embed e = L.embed;
  real m = labelmargin(L.p);
  real scale = (m + margin)/m;
  if (L.align.is3D) {
    L.align.dir3 *= scale;
  } else {
    L.align.dir *= scale;
  }
  if (L.embed == Rotate) {
    L.embed = Rotate(rdir);
  }
  label(pic=pic, L=L, g=g);
  L.align = a;
  L.embed = e;
}

void label_path(picture pic=currentpicture, Label L, path3 g, real margin=0,
                pair rdir=0) {
  align a = L.align;
  embed e = L.embed;
  real m = labelmargin(L.p);
  real scale = (m + margin)/m;
  if (L.align.is3D) {
    L.align.dir3 *= scale;
  } else {
    L.align.dir *= scale;
  }
  if (L.embed == Rotate) {
    L.embed = Rotate(rdir);
  }
  label(pic=pic, L=L, g=g);
  L.align = a;
  L.embed = e;
}

struct LabeledCircle {
  pair center;
  real radius;
  pen outline;
  pen fill;
  Label label;

  void operator init(pair center=(0,0), real radius=2mm,
                     pen outline=currentpen, pen fill=grey, Label L="") {
    this.center = center;
    this.radius = radius;
    this.outline = outline;
    this.fill = fill;
    this.label = L;
  }

  void draw_label(picture pic=currentpicture, Label L=null) {
    align a;
    if (L == null) {
      L = this.label;
    }
    a = L.align;
    if (L.align != NoAlign && L.align != Align) {
      real m = labelmargin(L.p);
      real scale = (m + this.radius)/m;
      if (L.align.is3D) {
        L.align.dir3 *= scale;
      } else {
        L.align.dir *= scale;
      }
    }
    label(pic=pic, L=L, position=this.center);
    L.align = a;
  }

  void draw(picture pic=currentpicture) {
    path p = shift(this.center)*scale(this.radius)*unitcircle;
    filldraw(pic, p, this.fill, this.outline);
    this.draw_label(pic=pic);
  }
}

// ---------------------- Mass -------------------------

struct Mass {
  LabeledCircle lc;
  real m;

  void operator init(pair center=(0,0), real m=1, real radius=2mm,
                     pen outline=currentpen, pen fill=grey, Label L="") {
    this.lc.operator init(center=center, radius=radius, outline=outline,
                          fill=fill, L=L);
    this.m = m;
  }

  pair center() { return this.lc.center; }
  void set_center(pair center) { this.lc.center = center; }
  void draw(picture pic=currentpicture) = this.lc.draw;
}

struct Block {
  pair center;
  real m;
  real width;
  real height;
  real direction;
  pen outline;
  pen fill;
  Label L;

  void operator init(pair center=(0,0), real m=1, real width=5mm, real height=-1, real direction=0, pen outline=currentpen, pen fill=grey, Label L="") {
    this.center = center;
    this.m = m;
    this.width = width;
    if (height == -1)
      this.height = width;
    else
      this.height = height;
    this.direction = direction;
    this.outline = outline;
    this.fill = fill;
    this.L = L;
  }

  void draw(picture pic=currentpicture) {
    picture picF;
    path c = rotate(direction)*scale(width,height)*shift(-.5,-.5)*unitsquare;
    filldraw(picF, c, fill, outline);
    label(pic=picF, L=L, position=(0,0));
    add(pic, picF, center);
  }
}

// ---------------------- Vectors -------------------------

struct Vector {
  pair center;
  real mag;
  real dir; // angle in the plane of the drawing.
  real phi; // angle with the plane of the drawing, 90 is out of the page.
  pen outline;
  Label label;
  real out_of_plane_radius;
  real out_of_plane_tolerance;

  void operator init(pair center=(0,0), real mag=5mm, real dir=0, real phi=0, pen outline=currentpen, Label L="") {
    this.center = center;
    this.mag = mag;
    this.dir = dir;
    this.phi = phi;
    this.outline = outline;
    this.label = L;
    this.out_of_plane_radius = 1mm;
    this.out_of_plane_tolerance = 0.01;
  }

  Vector copy() {
    Vector v = Vector(center=this.center, mag=this.mag, dir=this.dir,
                      phi=this.phi, outline=this.outline, L=this.label);
    v.out_of_plane_radius = this.out_of_plane_radius;
    v.out_of_plane_tolerance = this.out_of_plane_tolerance;
    return v;
  }

  pair dTip() {  // offset from center to tip
    pair p = (0,0);
    real phi_e = this.phi % 360; // effective phi
    if (Tan(phi_e) == 0 || abs(1.0/Tan(phi_e)) > this.out_of_plane_tolerance) {
      return this.mag*Cos(this.phi)*dir(this.dir);
    }
    return (0, 0);
  }

  pair pTip() {
    return this.dTip() + this.center;
  }

  void draw(picture pic=currentpicture) {
    pair p = this.dTip();
    path P;
    real phi_e = this.phi % 360; // effective phi
    if (this.mag < 0) (phi_e + 180) % 360;
    if (Tan(phi_e) == 0 || abs(1.0/Tan(phi_e)) > this.out_of_plane_tolerance) {
      // draw arrow in the plane of the drawing
      // TODO: thickening for phi?
      P = shift(this.center)*((0,0)--p);
      draw(pic, P, this.outline, Arrow);
    } else if (phi_e > 0 && phi_e < 180) {
      // draw a circled dot for out-of-the-page
      P = shift(this.center)*scale(this.out_of_plane_radius)*unitcircle;
      draw(pic, P, outline);
      dot(pic, this.center, this.outline);
    } else {
      // draw a circled cross for into-the-page
      real a = 0.8*sqrt(2.0)/2.0;
      P = shift(this.center)*scale(this.out_of_plane_radius)*unitcircle;
      draw(pic, P, this.outline);
      draw(pic, shift(this.center)*scale(this.out_of_plane_radius
                                         )*((-a,-a)--(a,a)), this.outline);
      draw(pic, shift(this.center)*scale(this.out_of_plane_radius
                                         )*((-a,a)--(a,-a)), this.outline);
    }
    label_path(pic=pic, L=this.label, g=P);
  }
}

Vector operator +(Vector a, Vector b) {
  Vector c = a.copy();
  pair p = a.mag*dir(a.dir) + b.mag*dir(b.dir);
  c.mag = length(p);
  c.dir = degrees(p);
  return c;
}

Vector operator -(Vector a, Vector b) {
  Vector c = a.copy();
  pair p = a.mag*dir(a.dir) - b.mag*dir(b.dir);
  c.mag = length(p);
  c.dir = degrees(p);
  return c;
}

void vector_field(pair center=(0,0), real width=2cm, real height=2cm,
                  real dv=0.5cm, real buf=2pt, Vector v=null,
                  pen outline=invisible) {
  /* There will be a buffer of at least buf on each side */
  if (v == null) {
    v = Vector();  // unlikely to be what they want, but it will draw something
  }

  pair ovcenter = v.center;
  real ovmag = v.mag;
  path bufsq = shift(center)*xscale(width-2*buf)*yscale(height-2*buf)
    *shift((-.5,-.5))*unitsquare;  // buffered bounding box
  pair uv = dir(v.dir);  // unit vector in the direction of v
  pair d = dv * dir(v.dir+90);
  real dx = d.x;
  real dy = d.y;
  int nx = 1;  // x steps
  int ny = 1;  // y steps
  bool diag = false;

  if (abs(fmod(v.phi, 180)) == 90) {  // pure in/out, make a 2D grid
    dx = dy = dv;  // v.dir was meaninless, reset dx and dy
    nx = abs((int)((width-2*buf) / dx)) + 1;
    ny = abs((int)((height-2*buf) / dy)) + 1;
  } else if (abs(fmod(v.dir, 180)) == 0) {  // pure left/right, vert. border
    ny = abs((int)((height-2*buf) / dy)) + 1;
    dx = 0;
  } else if (abs(fmod(v.dir, 180)) == 90) {  // pure up/down, horiz. border
    nx = abs((int)((width-2*buf) / dx)) + 1;
    dy = 0;
  } else {  // diagonal, draw along a vertical an horizontal border
    diag = true;
    // this requires enough special handling that we break it out below
  }

  if (!diag) {  // square grid
    real xx=buf, xy=buf;  // buffer distace per side
    if (dx != 0)
      xx = (width-(nx-1)*fabs(dx))/2.0;  // "extra" left over after division
    if (dy != 0)
      xy = (height-(ny-1)*fabs(dy))/2.0;

    real xstart = center.x - width/2 + xx;
    real ystart = center.y - height/2 + xy;
    if (dx < 0 || (dx == 0 && dot(uv, dir(0)) < 0))
      xstart += width - 2*xx;
    if (dy < 0 || (dy == 0 && dot(uv, dir(90)) < 0))
      ystart += height - 2*xy;

    for (int i=0; i<nx; i+=1) {
      for (int j=0; j<ny; j+=1)  {
        v.center = (xstart+i*dx, ystart+j*dy);
        if (abs(fmod(v.phi, 180)) != 90) {  // pure left/right/up/down
          // set length so that v just touches far bufsq face
          path vlong = (v.center+uv*min(width, height)/2)
            --(v.center+uv*max(width, height));
          //dot(v.center); draw(vlong); continue;  // intersection debugging
          pair xs[] = intersectionpoints(vlong, bufsq);
          assert(xs.length == 1, format("%d", xs.length));
          v.mag = length(xs[0] - v.center);
        }
        v.draw();
      }
    }
  } else {  // v is diagonal
    pair cc = (sgn(d.x)*width, sgn(d.y)*height);   // catty-corner vector
    real ccbuf = buf*max(fabs(1/cos(angle(cc))),   // buf away in y
                         fabs(1/sin(angle(cc))));  // buf away in x
    int n = abs((int)((dot(cc, unit(d))-2*ccbuf)/length(d))) + 1;  // lines
    pair pstart = center - (n-1)*d/2.0;

    for (int i=0; i<n; i+=1) {
      // project along +/- v until you hit the edge of bufsq
      pair p = (pstart + i*d);
      path vlong = (p-uv*length(cc))--(p+uv*length(cc));  // extends out of box
      //dot(p); draw(vlong); continue;  // intersection debugging
      pair xs[] = intersectionpoints(vlong, bufsq);
      assert(xs.length == 2, format("%d", xs.length));
      pair start = xs[0];
      if (dot((start - xs[1]), uv) > 0)
        start = xs[1];
      v.center = start;
      v.mag = length(xs[1]-xs[0]);
      v.draw();
    }
  }

  v.center = ovcenter;  // restore original center
  v.mag = ovmag;  // restore original magnitude

  // draw bounding box
  draw(shift(center)*xscale(width)*yscale(height)*shift((-.5,-.5))*
       unitsquare, outline);
}

Vector Velocity(pair center=(0,0), real mag=5mm, real dir=0, real phi=0, Label L="")
{
  Vector v = Vector(center=center, mag=mag, dir=dir, phi=phi, L=L, outline=rgb(1,0.1,0.2)); // red
  return v;
}

// ---------------------- Forces -------------------------

Vector Force(pair center=(0,0), real mag=5mm, real dir=0, real phi=0, Label L="")
{
  Vector v = Vector(center=center, mag=mag, dir=dir, phi=phi, L=L, outline=rgb(0.1,0.2,1)); // blue
  return v;
}

// ---------------------- Measures -------------------------

// Distance derived from CAD.MeasuredLine
struct Distance {
  pair pFrom;
  pair pTo;
  real offset;
  real scale;
  pen outline;
  Label label;

  void operator init(pair pFrom=(0,0), pair pTo=(5mm,0), real offset=0, real scale=5mm, pen outline=currentpen, Label L="") {
    this.pFrom = pFrom;
    this.pTo = pTo;
    this.offset = offset;
    this.scale = scale;
    this.outline = outline;
    this.label = L;
  }

  void draw(picture pic=currentpicture) {
    pair o = this.offset*unit(rotate(-90)*(this.pTo - this.pFrom));
    path p = (this.pFrom+o) -- (this.pTo+o);
    draw(pic, p, outline, Arrows);
    label_path(pic=pic, L=this.label, g=p, rdir=this.pTo - this.pFrom);
  }
}

struct Angle {
  pair B;
  pair A; // center of angle
  pair C;
  real radius; // radius < 0 for exterior angles.
  pen outline;
  pen fill;
  Label label;

  void operator init(pair B, pair A, pair C, real radius=5mm, pen outline=currentpen, pen fill=invisible, Label L="") {
    this.B = B;
    this.A = A;
    this.C = C;
    this.radius = radius;
    this.outline = outline;
    this.fill = fill;
    this.label = L;
  }

  void draw(picture pic=currentpicture) {
    bool direction;

    real ccw_angle = degrees(C-A)-degrees(B-A);
    bool direction = CCW;
    if (ccw_angle < 0) ccw_angle += 360.0;
    if (ccw_angle > 180)
      direction = CW;
    if (radius < 0)
      direction = !direction;
    path p = arc(this.A, fabs(radius), degrees(B-A), degrees(C-A), direction);
    if (this.fill != invisible) {
      path pcycle = this.A -- p -- cycle;
      fill(pic, pcycle, this.fill);
    }
    draw(pic, p, this.outline);
    if (direction == CW) {
      p = reverse(p);
    }
    label_path(pic=pic, L=this.label, g=p);
  }
}

Vector hatVect (string name,  pair center=(0,0), real dir=0, real phi=0) {
  string s = replace("$\mathbf{\hat{X}}$", "X", name);
  Label L = Label(s, position=EndPoint, align=RightSide);
  Vector v = Vector(
      center=center, mag=5mm, dir=dir, phi=phi, L=L, outline=rgb(0,0,0));
  return v;
}

Vector ihat (pair center=(0,0), real dir=0, real phi=0) {
  Vector v = hatVect(name="i", center=center, dir=dir, phi=phi);
  return v;
}

Vector jhat (pair center=(0,0), real dir=90, real phi=0) {
  Vector v = hatVect(name="j", center=center, dir=dir, phi=phi);
  return v;
}

void draw_ijhat(pair center=(0,0), real idir=0) {
  Vector ihat = ihat(center, idir);
  Vector jhat = jhat(center, idir+90);
  ihat.draw();
  jhat.draw();
}

// ---------------------- Shapes -------------------------

struct Wire {
  pair pFrom;
  pair pTo;
  pen outline;
  Label label;

  void operator init(pair pFrom=(0,0), pair pTo=(5mm,0), pen outline=currentpen, Label L="") {
    this.pFrom = pFrom;
    this.pTo = pTo;
    this.outline = outline;
    this.label = L;
  }

  void draw(picture pic=currentpicture) {
    path p = this.pFrom--this.pTo;
    draw(pic, p, outline);
    label_path(pic=pic, L=this.label, g=p, rdir=this.pTo - this.pFrom);
  }
}

struct Surface {
  pair pFrom;
  pair pTo;
  real thickness;
  pen outline;
  pen filla;
  pen fillb;
  Label label;

  void operator init(pair pFrom=(0,0), pair pTo=(5mm,0), real thickness=5mm, pen outline=currentpen, pen filla=rgb(.5,.5,.5), pen fillb=rgb(.7,.7,.7), Label L="") {
    this.pFrom = pFrom;
    this.pTo = pTo;
    this.thickness = thickness;
    this.outline = outline;
    this.filla = filla;
    this.fillb = fillb;
    this.label = L;
  }

  void draw(picture pic=currentpicture) {
    pair pDiff = pTo - pFrom;
    pair pDepth = rotate(-90)*unit(pDiff)*thickness;
    path p = (0, 0) -- pDiff -- (pDiff + pDepth) -- pDepth -- cycle;
    p = shift(this.pFrom) * p;
    axialshade(
        pic=pic, g=p, pena=filla, a=this.pFrom,
        penb=fillb, b=this.pFrom+pDepth);
    draw(pic, p, outline);
    label_path(pic=pic, L=this.label,
        g=shift(pDepth/2)*(this.pFrom -- this.pTo), rdir=this.pTo - this.pFrom);
  }
}

struct Spring {
  pair pFrom;
  pair pTo;
  real k;
  real width;
  real dLength; // length of a single loop (when unstretched)
  real deadLength; // length before loops start on each end
  real unstretchedLength;
  int nLoops;
  pen outline;
  Label label;

  void operator init(pair pFrom=(0,0), pair pTo=(5mm,0), real k=1, real width=3mm, real dLength=1mm, real deadLength=3mm, real unstretchedLength=12mm, pen outline=currentpen, Label L="") {
    this.pFrom = pFrom;
    this.pTo = pTo;
    this.k = k;
    this.width = width;
    this.dLength = dLength;
    this.unstretchedLength = unstretchedLength;
    this.outline = outline;
    this.label = L;

    this.nLoops = floor((unstretchedLength-2*deadLength)/dLength);
    if (this.nLoops == 0)
      this.nLoops = 1;
    this.deadLength = (unstretchedLength-this.nLoops*dLength)/2;
  }

  void draw(picture pic=currentpicture) {
    pair pDiff = pTo - pFrom;

    real working_dLength = (length(pDiff) - 2*deadLength) / nLoops;
    path p = (0,0)--(deadLength,0);
    path loop = (0,0)
      --(working_dLength/4, width/2)
      --(working_dLength*3/4, -width/2)
      --(working_dLength, 0);
    pair loopStart;
    for (int i=0; i<nLoops; ++i) {
      loopStart = point(p, length(p));
      p = p--(shift(loopStart)*loop);
    }
    loopStart = point(p, length(p));
    p = p--(loopStart+(deadLength,0));
    p = shift(this.pFrom)*rotate(degrees(pDiff)) * p;
    draw(pic, p, outline);
    label_path(pic=pic, L=this.label, g=this.pFrom--this.pTo,
        margin=this.width/2, rdir=this.pTo - this.pFrom);
  }
}

struct Pendulum {
  pair pivot;
  Mass mass;
  Angle angle;
  Wire str;

  void operator init(pair pivot=(0,0), Mass mass=Mass()) {
    this.pivot = pivot;
    this.mass = mass;
    this.angle = Angle(mass.center(), pivot, pivot-(0,1));
    this.str = Wire(pivot, mass.center());
  }

  void draw(picture pic=currentpicture, bool drawVertical=false) {
    str.draw(pic=pic);
    if (drawVertical == true) {
      pair final = pivot + realmult((0,0.5),(mass.center()-pivot));
      draw(pic=pic, pivot--final, p=currentpen+dashed);
    }
    draw(pic=pic, pivot);
    mass.draw(pic=pic);
    angle.draw(pic=pic);
  }
}

// The angle argument is deflection from straight down (i.e. 0 degrees = plumb)
Pendulum makePendulum(pair pivot=(0,0), Mass mass=Mass(), real length=15mm, real angleDeg=0, Label angleL="", Label stringL="") {
  mass.set_center(pivot + length*dir(angleDeg-90));
  Pendulum p = Pendulum(pivot=pivot, mass=mass);
  p.angle.label = angleL;
  p.str.label = stringL;
  return p;
}

struct Ring {
  triple center;
  triple normal;
  real radius;
  real width;
  real axis_pre;
  real axis_post;
  pen outline;
  pen fill;
  pen axis;
  Label label;
  Label axis_label;

  void operator init(triple center=(0,0,0), triple normal=(0,0,1),
                     real radius=5mm, real width=1mm, real axis_pre=0,
                     real axis_post=0, pen outline=currentpen,
                     pen fill=invisible, pen axis=invisible, Label L="",
                     Label axis_label="") {
    this.center = center;
    this.normal = normal;
    this.radius = radius;
    this.width = width;
    this.axis_pre = axis_pre;
    this.axis_post = axis_post;
    this.outline = outline;
    this.fill = fill;
    this.axis = axis;
    this.label = L;
    this.axis_label = axis_label;
  }

  void draw(picture pic=currentpicture) {
    path3 a = shift(this.center)*(
        (-this.axis_pre*this.normal)--(this.axis_post*this.normal));
    draw(pic, a, this.axis, Arrow3);
    path3 c = circle(c=this.center, r=this.radius, normal=this.normal);
    //tube t = tube(c, width=this.width);  // slow and ugly!
    //draw(t.s, this.fill);
    draw(pic, c, this.outline);
    label_path(pic=pic, L=this.label, g=c);
    label_path(pic=pic, L=this.axis_label, g=a);
  }
}

// TODO: plate, cylinder, table
