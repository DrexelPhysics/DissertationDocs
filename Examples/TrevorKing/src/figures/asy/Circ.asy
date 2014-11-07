/* Useful functions for drawing circuit diagrams.
 * Version 0.2
 *
 * Copyright (C) 2003 GS Bustamante Argañaraz
 *               2008-2012 W. Trevor King <wking@drexel.edu>
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
 *
 *
 * Based on MetaPost's MakeCirc by Gustavo Sebastian Bustamante Argañaraz.
 *   http://www.ctan.org/tex-archive/help/Catalogue/entries/makecirc.html
 */

// Command definitions for easier labeling

texpreamble("\def\ohm{\ensuremath{\,\Omega}}");
texpreamble("\def\kohm{\,k\ensuremath{\Omega}}");
texpreamble("\def\modarg#1#2{\setbox0=\hbox{$\mkern-1mu/#2^\circ$}\dp0=.21ex $#1\underline{\box0}$}");

int rotatelabel = 0;
int norotatelabel = 1;
int labeling = rotatelabel;

// Macros for the pens, I define them as such so when they expand,
// look for the last value assigned to linewd and use it
// (thanks to JLD). The linewd value assigns it as newinternal to
// be able to change it «from out».

real linewd = 0.25mm;

pen line = linewidth(linewd);
pen misc = linewidth(0.8*linewd);
pen kirchhoff_pen = linewidth(10*linewd)+gray(0.7);

// Arrowhead definitions

real ahlength = 4bp; // Arrowhead length
real ahangle = 30;   // Arrowhead angle

path miscahead (path p)
{
  real t = reltime(p, 1.0);
  pair A = point(p,t);
  pair u = -dir(p,t);
  path a = shift(A)*((0,0)--(scale(ahlength)*rotate(15)*u));
  path b = shift(A)*((0,0)--(scale(ahlength)*rotate(-15)*u));
  return (a & reverse(a) & b & reverse(b))--cycle;
}

path fullhead (path p, real length=ahlength, real angle=ahangle)
{
  real t = reltime(p, 1.0);
  pair A = point(p,t);
  pair u = -dir(p,t);
  path a = shift(A)*((0,0)--(scale(length)*rotate(angle/2)*u));
  path b = shift(A)*((0,0)--(scale(length)*rotate(-angle/2)*u));
  return (A -- a -- reverse(b) --cycle);
}

path bjtahead (path p)
{
  pair A = point(p,reltime(p,0.7));
  pair u = -dir(p,reltime(p,0.5));
  path a = shift(A)*((0,0)--(scale(ahlength)*rotate(20)*u));
  path b = shift(A)*((0,0)--(scale(ahlength)*rotate(-20)*u));
  return (a & reverse(a) & b & reverse(b))--cycle;
}

// function to wire the symbols together

int nsq=0, udsq=2, rlsq=3;

void wire(pair pin_beg, pair pin_end, int type=nsq, real dist=0)
{
  if (dist == 0) {
    if (type==nsq) {
      draw(pin_beg--pin_end, line);
    } else if (type==udsq) {
      draw(pin_beg--(pin_beg.x,pin_end.y)--pin_end, line);
    } else if (type==rlsq) {
      draw(pin_beg--(pin_end.x,pin_beg.y)--pin_end, line);
    } else {
      write("Error, unrecognized wire type ",type);
    }
  } else {
    if (type==udsq) {
      draw(pin_beg--(pin_beg+(0,dist))--(pin_end.x,pin_beg.y + dist)
           --pin_end, line);
    } else if (type==rlsq) {
      draw(pin_beg--(pin_beg+(dist,0))--(pin_beg.x + dist,pin_end.y)
           --pin_end, line);
    } else {
      write("Error, unrecognized wire type ",type);
    }
  }
}

// ----- Here the symbols begin --------

transform _shift_transform(pair z) = shift;

struct MultiTerminal {
  pair center;
  real dir;
  pair terminal[];
  pair terminal_offset[];
  Label label;
  Label value;
  real label_offset;
  real value_offset;
  path pLine[]; // cyclic paths are filled in
  path pMisc[];
  pen line;
  pen misc;

  void set_terminals() {
    for (int i=0; i < this.terminal_offset.length; i+=1) {
      this.terminal[i] = this.center +
          rotate(this.dir)*this.terminal_offset[i];
    }
  }

  void operator init(pair center=(0,0), real dir=0,
                     pair terminal[]={}, pair terminal_offset[]={},
                     Label label="", Label value="",
                     real label_offset=0, real value_offset=0,
                     path pLine[]={}, path pMisc[]={},
                     pen line=line, pen misc=misc) {
    this.center = center;
    this.dir = dir % 360;
    this.terminal = terminal;
    this.terminal_offset = terminal_offset;
    this.set_terminals();
    this.label = label;
    this.value = value;
    this.label_offset = label_offset;
    this.value_offset = value_offset;
    this.pLine = pLine;
    this.pMisc = pMisc;
    this.line = line;
    this.misc = misc;
  }

  /* Shift position by a */
  void shift(pair a) {
    this.center += a;
    this.set_terminals();
  }

  void draw_label(picture pic=currentpicture, Label L=null, real offset=0,
                  pair default_direction=(0,0)) {
    align a;
    if (L == null) {
      L = this.label;
    }
    a = L.align;
    if ((L.align == NoAlign || L.align.dir == (0,0)) &&
        default_direction != (0,0)) {
      L.align = rotate(this.dir)*default_direction;
    }
    if (L.align != NoAlign && L.align != Align) {
      real m = labelmargin(L.p);
      real scale = (m + offset)/m;
      if (L.align.is3D) {
        L.align.dir3 *= scale;
      } else {
        L.align.dir *= scale;
      }
    }
    label(pic=pic, L=L, position=this.center);
    L.align = a;
  }

  /* Rather than placing the element with a point and direction (mid,
   * dir), center an element between the pairs a and b.  The optional
   * offset shifts the element in the direction rotated(90)*(b-a)
   * (i.e. up for offset > 0 if b is directly right of a).
   */
  void centerto(pair a, pair b, real offset=0) {
    this.dir = degrees(b-a);
    this.center = (a+b)/2 + offset*dir(this.dir+90);
    this.set_terminals();
  }

  void draw(picture pic=currentpicture) {
    for (int i=0; i< pLine.length; i+=1) {
      path p = _shift_transform(this.center)*rotate(this.dir)*pLine[i];
      if (cyclic(p))
        filldraw(pic, p, this.line, this.line);
      else
        draw(pic, p, this.line);
    }
    for (int i=0; i< pMisc.length; i+=1) {
      path p = _shift_transform(this.center)*rotate(this.dir)*pMisc[i];
      if (cyclic(p))
        filldraw(pic, p, this.misc, this.misc);
      else
        draw(pic, p, this.misc);
    }
    this.draw_label(pic=pic, L=this.label, offset=this.label_offset,
        default_direction=N);
    this.draw_label(pic=pic, L=this.value, offset=this.value_offset,
        default_direction=S);
  }
}

pair _offset(pair beg=(0,0), real length=1, real dir=0) {
  return beg + rotate(dir)*(length, 0);
}

void two_terminal_centerto(MultiTerminal reference, MultiTerminal target,
                           real offset=0, bool reverse=false)
{
  if (reverse == false)
    target.centerto(reference.terminal[0], reference.terminal[1], offset);
  else
    target.centerto(reference.terminal[1], reference.terminal[0], offset);
}

// --- Resistor (Resistencia) ---

real rstlth=2mm;
int normal=0, variable=2;

MultiTerminal resistor(pair beg=(0,0), real dir=0, int type=normal,
                       Label label="", Label value="", bool draw=true)
{
  path pLine, pLines[]={}, pMisc[]={};
  real len = 7rstlth;
  MultiTerminal term;
  pair center = _offset(beg=beg, length=len/2, dir=dir);
  pair terminal_offset[] = {
      (-len/2, 0),
      (len/2, 0)};

  pLine = (-len/2,0)--(-1.5rstlth,0)--(-1.25rstlth,.75rstlth);
  for (real i=.5; i<=2.5; i+=0.5)
    pLine = pLine--((-1.25+i)*rstlth,((-1)**(2i))*.75rstlth);
  pLine = pLine -- (1.5rstlth,0)--(len/2,0);
  if (type==normal) {
    ; //pass
  } else if (type==variable) {
    ahlength=.8rstlth;
    pMisc.push((-1.5rstlth,-rstlth)--(1.5rstlth,rstlth));
    pMisc.push(miscahead((-1.5rstlth,-rstlth)--(1.5rstlth,rstlth)));
  } else {
    write("Error, unrecognized resistor type ",type);
  }
  pLines.push(pLine);
  term = MultiTerminal(center=center, dir=dir, terminal_offset=terminal_offset,
      label=label, value=value, label_offset=.8rstlth, value_offset=.8rstlth,
      pLine=pLines, pMisc=pMisc);
  if (draw == true)
    term.draw();
  return term;
}

// --- Inductor (bobina) ---

real coil=2mm;
int Up=0, Down=1;

MultiTerminal inductor(pair beg=(0,0), real dir=0, int type=Up,
                       Label label="", Label value="", bool draw=true)
{
  path pLine;
  real len = 6coil;
  MultiTerminal term;
  pair center = _offset(beg=beg, length=len/2, dir=dir);
  pair terminal_offset[] = {
      (-len/2, 0),
      (len/2, 0)};

  pLine = (-len/2,0) -- (-2coil,0);

  if (type==Up) {
    for (int i=-1; i<=2; i+=1)
      pLine = pLine{N}..{S}(i*coil,0);
  } else if (type==Down) {
    for (int i=-1; i<=2; i+=1)
      pLine = pLine{S}..{N}(i*coil,0);
  } else {
    write("Error, unrecognized inductor type ",type);
  }
  pLine = pLine -- (len/2,0);

  term = MultiTerminal(center=center, dir=dir, terminal_offset=terminal_offset,
      label=label, value=value, label_offset=.8rstlth, value_offset=.8rstlth,
      pLine=pLine);
  if (draw == true)
    term.draw();
  return term;
}

// --- Capacitor (condensador) ---

real platsep=1mm;
int normal=0, electrolytic=1, variable=2, variant=3;

MultiTerminal capacitor(pair beg=(0,0), real dir=0, int type=normal,
                        Label label="", Label value="", bool draw=true)
{
  path pLine[]={}, pMisc[]={};
  real len = 7platsep;
  MultiTerminal term;
  pair center = _offset(beg=beg, length=len/2, dir=dir);
  pair terminal_offset[] = {
      (-len/2, 0),
      (len/2, 0)};

  pLine.push((-len/2,0)--(-platsep/2,0));
  pLine.push((platsep/2,0)--(len/2,0));

  if (type==normal) {
    pLine.push((-platsep/2,-2.5platsep)--(-platsep/2,2.5platsep));
    pLine.push((platsep/2,-2.5platsep)--(platsep/2,2.5platsep));
  } else if (type==electrolytic) {
    pLine.push((-platsep/2,-1.8platsep)--(-platsep/2,1.8platsep));
    pLine.push((-1.5platsep,-2.5platsep)--(platsep/2,-2.5platsep)
               --(platsep/2,+2.5platsep)--(-1.5platsep,2.5platsep));
  } else if (type==variable) {
    pLine.push((-platsep/2,-2.5platsep)--(-platsep/2,2.5platsep));
    pLine.push((platsep/2,-2.5platsep)--(platsep/2,2.5platsep));
    pMisc.push((-2.5platsep,-2.5platsep)--(2.5platsep,2.5platsep));
    ahlength=1.7platsep;
    pMisc.push(miscahead((-2.5platsep,-2.5platsep)--(2.5platsep,2.5platsep)));
  } else if (type==variant) {
    pLine.push((-platsep/2,-2.5platsep)--(-platsep/2,2.5platsep));
    pLine.push((platsep,-2.5platsep)..(platsep/2,0)..(platsep,2.5platsep));
  } else {
    write("Error, unrecognized capacitor type ",type);
  }
  term = MultiTerminal(center=center, dir=dir, terminal_offset=terminal_offset,
      label=label, value=value, label_offset=2.5platsep,
      value_offset=2.5platsep, pLine=pLine, pMisc=pMisc);
  if (draw == true)
    term.draw();
  return term;
}

// --- Diode (diodo) ---

real diode_height = 3.5mm;
int zener=1, LED=2;
// I droped the pin parameters, since other device (e.g. electrolytic
// capacitors) are also polarized.  The positioning method centerto(),
// provides enough flexibility.

MultiTerminal diode(pair beg=(0,0), real dir=0, int type=normal,
                    Label label="", Label value="", bool draw=true)
{
  path pLine[]={}, pMisc[]={};
  real len = 3*diode_height;
  real r = diode_height/2;
  real label_offset, value_offset;
  MultiTerminal term;
  pair center = _offset(beg=beg, length=len/2, dir=dir);
  pair terminal_offset[] = {
      (-len/2, 0),
      (len/2, 0)};

  label_offset = value_offset = r;
  pLine.push((-len/2,0)--(-r,0)--(-r,r)--(r,0)--(-r,-r)--(-r,0));
  pLine.push((r,0)--(len/2,0));

  if (type==normal) {
    pLine.push((r,-r)--(r,r));
  } else if (type==zener) {
    pLine.push((2r,-r)--(r,-r)--(r,r)--(0,r));
  } else if (type==LED) {
    path a = (-r,r)--(r,0);
    pair u = unit((0.5, 1)); // perpendicular to a
    path b = (0,0)--diode_height*u;
    pLine.push((r,-r)--(r,r));
    label_offset = 1.5*diode_height;
    pMisc.push(shift(point(a,reltime(a,0.25))+point(b,0.33))*((0,0)--diode_height*u));
    pMisc.push(shift(point(a,reltime(a,0.60))+point(b,0.33))*((0,0)--diode_height*u));
    pMisc.push(fullhead(pMisc[0], 0.4*diode_height, 30));
    pMisc.push(fullhead(pMisc[1], 0.4*diode_height, 30));
  } else {
    write("Error, unrecognized diode type ",type);
  }
  term = MultiTerminal(center=center, dir=dir, terminal_offset=terminal_offset,
      label=label, value=value, label_offset=label_offset,
      value_offset=value_offset, pLine=pLine, pMisc=pMisc);
  if (draw == true)
    term.draw();
  return term;
}

//--- Battery (bater'ia) ---

real battery_size = 6mm;

MultiTerminal battery(pair beg=(0,0), real dir=0,
                      Label label="", Label value="", bool draw=true)
{
  path pLine[]={}, pMisc[]={};
  real len = 1.8*battery_size;
  real r = battery_size/2;
  real x = 0.4*battery_size;
  real Y = 0.6*battery_size;
  real y = 0.2*battery_size;
  real label_offset, value_offset;
  MultiTerminal term;
  pair center = _offset(beg=beg, length=len/2, dir=dir);
  pair terminal_offset[] = {
      (-len/2, 0),
      (len/2, 0)};

  label_offset = value_offset = Y;
  pLine.push((-len/2,0)--(-r,0));
  pLine.push((r,0)--(len/2,0));
  for (int i=0; i<3; i+=1) {
    pLine.push((-r+x*i, -y)--(-r+x*i, y));
    pLine.push((-r+x*(i+0.5), -Y)--(-r+x*(i+0.5), Y));
  }
  term = MultiTerminal(center=center, dir=dir, terminal_offset=terminal_offset,
      label=label, value=value, label_offset=label_offset,
      value_offset=value_offset, pLine=pLine, pMisc=pMisc);
  if (draw == true)
    term.draw();
  return term;
}

//--- Switches (Llaves) ---

int open=0, closed=1;
real switch_size = 3mm;

/* Helper function for constructing switch paths. */
path[] _switch_lines(pair terminal_offset[], real theta)
{
  path pLine[] = {};
  real r = switch_size/2;
  real dy = switch_size/6;  // little nub where the switch closes
  pLine.push((-r,0)--((-r,0)+switch_size*dir(theta)));
  for (int i=0; i < terminal_offset.length; i+=1) {
    pLine.push(shift(terminal_offset[i])*scale(dy)*unitcircle);
  }
  return pLine;
}

/* `switch' is a Asymptote keyword (or it should be), so append SPST
 * for Single Pole Single Throw.
 */
MultiTerminal switchSPST(pair beg=(0,0), real dir=0, int type=open,
                         Label label="", Label value="", bool draw=true)
{
  path pLine[] = {};
  real theta, label_offset, value_offset;
  MultiTerminal term;
  pair center = _offset(beg=beg, length=switch_size/2, dir=dir);
  pair terminal_offset[] = {
      (-switch_size/2, 0),
      (switch_size/2, 0)};

  value_offset = 0;
  if (type==open) {
    theta = 35;
  } else if (type==closed) {
    theta = 10;
  } else {
    write("Error, unrecognized switchSPST type ",type);
  }
  pLine = _switch_lines(terminal_offset=terminal_offset, theta=theta);
  label_offset = switch_size*Sin(theta);
  term = MultiTerminal(center=center, dir=dir, terminal_offset=terminal_offset,
      label=label, value=value, label_offset=label_offset,
      value_offset=value_offset, pLine=pLine);
  if (draw == true)
    term.draw();
  return term;
}

int closed_a=1, closed_b=2;

/* A Single Pole Double Throw switch. */
MultiTerminal switchSPDT(pair beg=(0,0), real dir=0, int type=open,
                         Label label="", Label value="", bool draw=true)
{
  path pLine[] = {};
  real theta, label_offset, value_offset;
  MultiTerminal term;
  pair center = _offset(beg=beg, length=switch_size/2, dir=dir);
  pair terminal_offset[] = {
      (-switch_size/2, 0),
      (switch_size*sqrt(3)/4, switch_size/2),
      (switch_size*sqrt(3)/4, -switch_size/2)};

  label_offset = value_offset = switch_size/2;
  if (type==open) {
    theta = 0;
  } else if (type==closed_a) {
    theta = 20;
  } else if (type==closed_b) {
    theta = -20;
  } else {
    write("Error, unrecognized switchSPST type ",type);
  }
  pLine = _switch_lines(terminal_offset=terminal_offset, theta=theta);
  term = MultiTerminal(center=center, dir=dir, terminal_offset=terminal_offset,
      label=label, value=value, label_offset=label_offset,
      value_offset=value_offset, pLine=pLine);
  if (draw == true)
    term.draw();
  return term;
}

//--- Current (Corriente) ---

real current_size = 2mm;

MultiTerminal current(pair beg=(0,0), real dir=0,
                      Label label="", Label value="", bool draw=true)
{
  path pLine[]={}, pMisc[]={};
  real label_offset, value_offset;
  real len = 2*current_size;
  MultiTerminal term;
  pair center = _offset(beg=beg, length=len/2, dir=dir);
  pair terminal_offset[] = {
      (-len/2, 0),
      (len/2, 0)};

  label_offset = value_offset = 0.4*current_size;
  pLine.push((-len/2, 0) -- (current_size/2, 0));
  pLine.push((current_size/2, 0) -- (len/2, 0));
  pMisc.push(fullhead(pLine[0], current_size, 45));
  term = MultiTerminal(center=center, dir=dir, terminal_offset=terminal_offset,
      label=label, value=value, label_offset=label_offset,
      value_offset=value_offset, pLine=pLine, pMisc=pMisc);
  if (draw == true)
    term.draw();
  return term;
}

//--- Circle-based symbols (for internal use) --

real circle_size = 6mm;

MultiTerminal _circle_symbol(pair beg=(0,0), real dir=0,
                             Label label="", Label value="")
{
  path pLine[]={};
  real label_offset, value_offset;
  real len = 2*circle_size;
  real r = circle_size/2;
  MultiTerminal term;
  pair center = _offset(beg=beg, length=r, dir=dir);
  pair terminal_offset[] = {
      (-len/2, 0),
      (len/2, 0)};

  label_offset = value_offset = r;
  pLine.push((-len/2, 0) -- (-r, 0));
  pLine.push((r, 0) -- (len/2, 0));
  pLine.push(scale(r)*(E..N..W..S..E));
  term = MultiTerminal(center=center, dir=dir, terminal_offset=terminal_offset,
      label=label, value=value, label_offset=label_offset,
      value_offset=value_offset, pLine=pLine);
  return term;
}

//--- Sources (fuentes de alimentaci'on) ---

int AC=0,DC=1,I=2,V=3;

MultiTerminal source(pair beg=(0,0), real dir=0, int type=AC,
                     Label label="", Label value="", bool draw=true)
{
  MultiTerminal term;

  if (type == AC || type == I || type == V) {
    real r = circle_size/2;
    term = _circle_symbol(beg=beg, dir=dir, label=label, value=value);
    if (type == AC) {
      term.pLine.push((-2r/3,0){NE}..{E}(-r/3,.4r)..{SE}(0,0)..{E}(r/3,-.4r)..{NE}(2r/3,0));
    } else if (type == I) {
      term.pLine.push((-2r/3,0)--(2r/3,0));
      term.pLine.push(fullhead(term.pLine[3], 8r/15, 30));
    } else if (type == V) {
      term.pLine.push((-0.9r,0)--(-0.1r,0));
      term.pLine.push((0.5r,-.4r)--(0.5r,.4r));
      term.pLine.push((0.1r,0)--(0.9r,0));
    }
  } else if (type == DC) {
    path pLine[]={};
    real label_offset, value_offset;
    real len = battery_size;
    real x = 0.2*battery_size;
    real Y = 0.6*battery_size;
    real y = 0.2*battery_size;
    pair center = _offset(beg=beg, length=len/2, dir=dir);
    pair terminal_offset[] = {
        (-len/2, 0),
        (len/2, 0)};

    label_offset = value_offset = Y;
    pLine.push((-len/2,0)--(-x/2,0));
    pLine.push((x/2,0)--(len/2,0));
    pLine.push((-x/2, -y)--(-x/2, y));
    pLine.push((x/2, -Y)--(x/2, Y));
    term = MultiTerminal(center=center, dir=dir,
        terminal_offset=terminal_offset,
        label=label, value=value, label_offset=label_offset,
        value_offset=value_offset, pLine=pLine);
  }
  if (draw == true)
    term.draw();
  return term;
}

/*

//%%<--- Transistor --->%%%
newinternal npn, pnp, cnpn, cpnp, bjtlth;
npn=1; pnp=-1; cnpn=0; cpnp=2; bjtlth=7mm;

vardef transistor@#(expr z,type,ang)=
	save BJT;
	pair T@#.B,T@#.E,T@#.C; % pines: Base, Emisor, Colector %
	T@#.B=z;
	T@#.E=(z+(bjtlth,-.75bjtlth)) rotatedaround(z,ang);
	T@#.C=(z+(bjtlth,.75bjtlth)) rotatedaround(z,ang);
	picture BJT;
	BJT=nullpicture;
	
	addto BJT doublepath z--(z+(.5bjtlth,0)) withpen line;
	addto BJT doublepath (z+(.5bjtlth,-.5bjtlth))--(z+(.5bjtlth,.5bjtlth)) withpen line;
	addto BJT doublepath (z+(.5bjtlth,.2bjtlth))--(z+(bjtlth,.5bjtlth))
	--(z+(bjtlth,.75bjtlth)) withpen line;
	
	if type=npn:
		addto BJT doublepath (z+(.5bjtlth,-.2bjtlth))--(z+(bjtlth,-.5bjtlth))
		--(z+(bjtlth,-.75bjtlth)) withpen line;
		addto BJT contour bjtahead (z+(.5bjtlth,-.2bjtlth))
		--(z+(bjtlth,-.5bjtlth)) withpen line;
	elseif type=cnpn:
		addto BJT doublepath (z+(.5bjtlth,-.2bjtlth))--(z+(bjtlth,-.5bjtlth))
		--(z+(bjtlth,-.75bjtlth)) withpen line;
		addto BJT contour bjtahead (z+(.5bjtlth,-.2bjtlth))
		--(z+(bjtlth,-.5bjtlth)) withpen line;
		addto BJT doublepath fullcircle scaled 1.3bjtlth shifted (z+(.65bjtlth,0))
		 withpen line;
	elseif type=pnp:
		addto BJT doublepath (z+(bjtlth,-.75bjtlth))--(z+(bjtlth,-.5bjtlth))
		--(z+(.5bjtlth,-.2bjtlth)) withpen line;
		addto BJT contour bjtahead (z+(bjtlth,-.5bjtlth))
		--(z+(.5bjtlth,-.2bjtlth)) withpen line;
	elseif type=cpnp:
		addto BJT doublepath (z+(bjtlth,-.75bjtlth))--(z+(bjtlth,-.5bjtlth))
		--(z+(.5bjtlth,-.2bjtlth)) withpen line;
		addto BJT contour bjtahead (z+(bjtlth,-.5bjtlth))
		--(z+(.5bjtlth,-.2bjtlth)) withpen line;
		addto BJT doublepath fullcircle scaled 1.3bjtlth shifted (z+(.65bjtlth,0)) withpen line;
	fi;
	
	draw BJT rotatedaround(z,ang);
enddef;

//%%<--- Measurement instruments (Intrumentos de medicion)--->%%%
newinternal volt, ampere, watt;
volt=0; ampere=1; watt=2;

vardef meains@#(expr z,type,ang,name)=
	save meter;
	pair mi@#.l, mi@#.r, mi@#.p; % pines %
	mi@#.l=z; mi@#.r=(z+(2ssize,0)) rotatedaround(z,ang);
	
	picture meter; meter=nullpicture;
	addto meter doublepath z--(z+(.5ssize,0));
	addto meter doublepath (z+(1.5ssize,0))--(z+(2ssize,0));
	if (type=volt) || (type=ampere):	
		addto meter doublepath fullcircle scaled ssize shifted (z+(ssize,0));
		if type=volt:
			addto meter also thelabel(latex("\textsf{V}") scaled (ssize/6mm) 
			rotated (-ang), (z+(ssize,0)));
		elseif type=ampere:
			addto meter also thelabel(latex("\textsf{A}") scaled (ssize/6mm) 
			rotated (-ang), (z+(ssize,0)));
		fi;
	elseif (type=watt):
		mi@#.p=(z+(ssize,-ssize)) rotatedaround(z,ang);
		addto meter doublepath (z+(.5ssize,-.5ssize))--(z+(.5ssize,.5ssize))
		--(z+(1.5ssize,.5ssize))--(z+(1.5ssize,-.5ssize))--cycle;
		addto meter doublepath (z+(ssize,-.5ssize))--(z+(ssize,-ssize));
		addto meter also thelabel(latex("\textsf{W}") scaled (ssize/6mm) 
		rotated (-ang), (z+(ssize,0)));
	fi;
	
	draw meter rotatedaround(z,ang) withpen line;
	
	if labeling=rotatelabel:
		if ((ang > (-90)) && (ang <= 90)) || ((ang > 270) && (ang <= 450)):
			label(latex(name) rotatedaround (.5[mi@#.l,mi@#.r],ang), 
			(.5ssize+lbsep)*dir (90+ang) shifted .5[mi@#.l,mi@#.r]);
		elseif ((ang > 90) && (ang <= 270)) || ((ang > (-270)) && (ang <= (-90))):
			label(latex(name) rotatedaround (.5[mi@#.l,mi@#.r],180+ang), 
			(.5ssize+lbsep)*dir (90+ang) shifted .5[mi@#.l,mi@#.r]);
		fi;
	elseif labeling=norotatelabel:
		if (ang = 0):
			label.top(latex(name), (.5ssize+.25lbsep)*dir (90+ang) 
			shifted .5[mi@#.l,mi@#.r]);
		elseif (ang > 0) && (ang < 90):
			label.ulft(latex(name), (.5ssize)*dir (90+ang) 
			shifted .5[mi@#.l,mi@#.r]);
		elseif (ang = 90):
			label.lft(latex(name),(.5ssize+.25lbsep)*dir (90+ang)
			shifted .5[mi@#.l,mi@#.r]);
		elseif (90 < ang) && (ang < 180):
			label.llft(latex(name),(.5ssize)*dir (90+ang)
			shifted .5[mi@#.l,mi@#.r]);
		elseif (ang = 180) || (ang = (-180)):
			label.bot(latex(name), (.5ssize+.25lbsep)*dir (90+ang) 
			shifted .5[mi@#.l,mi@#.r]);
		elseif ((ang > 180) && (ang < 270)) || ((ang > (-180)) && (ang < (-90))):
			label.lrt(latex(name),(.5ssize)*dir (90+ang)
			shifted .5[mi@#.l,mi@#.r]);
		elseif (ang = 270) || (ang = (-90)):
			label.rt(latex(name), (.5ssize+.25lbsep)*dir (90+ang) 
			shifted .5[mi@#.l,mi@#.r]);
		elseif ((270 < ang) && (ang < 360)) || ((ang < 0) && (ang > (-90))):
			label.urt(latex(name),(.5ssize)*dir (90+ang)
			shifted .5[mi@#.l,mi@#.r]);
		fi;
	fi;
enddef;

// --- Electrical machines (maquinas electricas) ---

TwoTerminal motor(pair beg, real ang, string name, string val)
{
  path pLine;
  TwoTerminal term;

  if (type==Up) {
    pLine = (0,0)--(coil,0);
    for (int i=2; i<=4; i+=1)
      pLine = pLine{N}..{S}(i*coil,0);
    pLine = pLine{N}..{S}(5coil,0)--(6coil,0);
  } else if (type==Down) {
    pLine = (0,0)--(coil,0);
    for (int i=2; i<=4; i+=1)
      pLine = pLine{S}..{N}(i*coil,0);
    pLine = pLine{S}..{N}(5coil,0)--(6coil,0);
    // original makecirc changed labelangle to ang-180
  }
  term = TwoTerminal(beg, 6coil, ang, coil, coil, name, val, pLine);
  // original makecirc used .5coil for lcharv
  term.draw();
  return term;
}
	M@#.D=z; M@#.B=(z+(2ssize,0)) rotatedaround(z,ang);
	picture mot; mot=nullpicture;
	
	addto mot doublepath z--(z+(.4ssize,0));
	addto mot doublepath (z+(1.6ssize,0))--(z+(2ssize,0));
	addto mot doublepath fullcircle scaled ssize shifted (z+(ssize,0));
	addto mot also thelabel(latex("\textsf{M}") scaled (ssize/6mm) 
	rotated (-ang), (z+(ssize,0)));
	
	path p,q,r,s,ca,cb,c,hc;
	p=(z+(.6ssize,.075ssize))--(z+(.4ssize,.075ssize));
	q=(z+(.4ssize,.075ssize))--(z+(.4ssize,-.075ssize));
	ca=(z+(.4ssize,-.075ssize))--(z+(.6ssize,-.075ssize));
	
	
	r=(z+(1.4ssize,.075ssize))--(z+(1.6ssize,.075ssize));
	s=(z+(1.6ssize,.075ssize))--(z+(1.6ssize,-.075ssize));
	cb=(z+(1.6ssize,-.075ssize))--(z+(1.4ssize,-.075ssize));
	
	c=fullcircle scaled ssize shifted (z+(ssize,0));
	hc=halfcircle scaled ssize rotated 270 shifted (z+(ssize,0));
	
	addto mot contour buildcycle(p,q,ca,c);
	addto mot doublepath buildcycle(p,q,ca,c);
	
	addto mot contour buildcycle(cb,s,r,hc);
	addto mot doublepath buildcycle(cb,s,r,hc);
	
	draw mot rotatedaround(z,ang) withpen line;
	
	putlabel(M@#.D,M@#.B,.5ssize,.5ssize,ang,name,val);
enddef;

vardef generator@#(expr z,ang,name,val)=
	save gen;
	pair G@#.D, G@#.B; % pines %
	G@#.D=z; G@#.B=(z+(2ssize,0)) rotatedaround(z,ang);
	picture gen; gen=nullpicture;
	
	addto gen doublepath z--(z+(.5ssize,0));
	addto gen doublepath (z+(1.5ssize,0))--(z+(2ssize,0));
	addto gen doublepath fullcircle scaled ssize shifted (z+(ssize,0));
	addto gen also thelabel(latex("\textsf{G}") scaled (ssize/6mm) 
	rotated (-ang), (z+(ssize,0)));
	
	draw gen rotatedaround(z,ang) withpen line;
	
	putlabel(G@#.D,G@#.B,.5ssize,.5ssize,ang,name,val);
enddef;

newinternal mid, Fe, auto;
mid=1; Fe=2; auto=3;

vardef transformer@#(expr z,type,ang)=
	save trafo;
	pair tf@#.pi, tf@#.ps, tf@#.si, tf@#.ss, tf@#.m;
	tf@#.pi=z; tf@#.ps=(z+(0,8coil)) rotatedaround(z,ang);
	tf@#.si=(z+(2.4coil,0)) rotatedaround(z,ang);
	tf@#.ss=(z+(2.4coil,8coil)) rotatedaround(z,ang);
	tf@#.m=(z+(3.4coil,4coil)) rotatedaround(z,ang);
	
	picture trafo; trafo=nullpicture;
	
	if type=normal:
	tf@#.pi=z; tf@#.ps=(z+(0,8coil)) rotatedaround(z,ang);
	tf@#.si=(z+(2.4coil,0)) rotatedaround(z,ang);
	tf@#.ss=(z+(2.4coil,8coil)) rotatedaround(z,ang);
		addto trafo doublepath z--(z+(0,coil)){right}..
		for i=2 upto 6:	{left}(z+(0,i*coil)){right}.. endfor
		{left}(z+(0,7coil))--(z+(0,8coil));
		addto trafo doublepath (z+(coil,coil))--(z+(coil,7coil));
		addto trafo doublepath (z+(1.4coil,coil))--(z+(1.4coil,7coil));
		addto trafo doublepath (z+(2.4coil,0))--(z+(2.4coil,coil)){left}..
		for i=2 upto 6:	{right}(z+(2.4coil,i*coil)){left}.. endfor
		{right}(z+(2.4coil,7coil))--(z+(2.4coil,8coil));
	elseif type=mid:
	tf@#.pi=z; tf@#.ps=(z+(0,8coil)) rotatedaround(z,ang);
	tf@#.si=(z+(2.4coil,0)) rotatedaround(z,ang);
	tf@#.ss=(z+(2.4coil,8coil)) rotatedaround(z,ang);
	tf@#.m=(z+(3.4coil,4coil)) rotatedaround(z,ang);
		addto trafo doublepath z--(z+(0,coil)){right}..
		for i=2 upto 6:	{left}(z+(0,i*coil)){right}.. endfor
		{left}(z+(0,7coil))--(z+(0,8coil));
		addto trafo doublepath (z+(coil,coil))--(z+(coil,7coil));
		addto trafo doublepath (z+(1.4coil,coil))--(z+(1.4coil,7coil));
		addto trafo doublepath (z+(2.4coil,0))--(z+(2.4coil,coil)){left}..
		for i=2 upto 6:	{right}(z+(2.4coil,i*coil)){left}.. endfor
		{right}(z+(2.4coil,7coil))--(z+(2.4coil,8coil));
		addto trafo doublepath (z+(2.4coil,4coil))--(z+(3.4coil,4coil));
	elseif type=Fe:
	tf@#.pi=z rotatedaround(z,ang); tf@#.ps=(z+(0,5.3coil)) rotatedaround(z,ang);
	tf@#.si=(z+(14coil,0)) rotatedaround(z,ang);
	tf@#.ss=(z+(14coil,5.228coil)) rotatedaround(z,ang);
		addto trafo doublepath z+(2coil,-2.5coil)--z+(12coil,-2.5coil)
		--z+(12coil,7.5coil)--z+(2coil,7.5coil)--cycle;
		addto trafo doublepath z+(4coil,-.5coil)--z+(10coil,-.5coil)
		--z+(10coil,5.5coil)--z+(4coil,5.5coil)--cycle;
		addto trafo doublepath z--z+(2coil,0)--z+(4coil,0.728coil)
		{right}..{left}z+(4coil,1.3*coil);
		for i=1 upto 4:
			addto trafo doublepath z+(2coil,(i+.5)*coil){left}..
			{right}z+(2coil,i*coil)--z+(4coil,(i+0.728)*coil)
			{right}..{left}z+(4coil,(i+1.3)*coil);
		endfor;
		addto trafo doublepath z+(2coil,5.3coil)--z+(0,5.3coil);
		for i=0 upto 3:
			addto trafo doublepath z+(10coil,i*coil){left}..
			{right}z+(10coil,(i+.5)*coil)--z+(12coil,(i+.5+0.728)*coil)
			{right}..{left}z+(12coil,(i+.656)*coil);
		endfor;
		addto trafo doublepath z+(10coil,4coil){left}..{right}
		z+(10coil,4.5coil)--z+(12coil,5.228coil)--z+(14coil,5.228coil);
		addto trafo doublepath z+(12coil,0)--z+(14coil,0);
	elseif type=auto:
	tf@#.pi=z rotatedaround(z,ang); tf@#.ps=(z+(0,4coil)) rotatedaround(z,ang);
	tf@#.si=(z+(4coil,-6coil)) rotatedaround(z,ang);
	tf@#.ss=(z+(4coil,4coil)) rotatedaround(z,ang);
		addto trafo doublepath z--z+(2coil,0);
		addto trafo doublepath z+(2coil,-6coil)--z+(2coil,-5coil){right}..
		for i=2 upto 10: {left}(z+(2coil,(i-6)*coil)){right}.. endfor
		{left}(z+(2coil,5coil))--z+(2coil,6coil)--z+(0,6coil);
		addto trafo doublepath z+(2coil,6coil)--z+(4coil,6coil);
		addto trafo doublepath z+(2coil,-6coil)--z+(4coil,-6coil);
	fi;
	
	draw trafo rotatedaround(z,ang) withpen line;
enddef;

//%%<--- Miscellaneous symbols --->%%%

newinternal gndlth, implth, simple, shield;
gndlth=5mm; implth=7mm; simple=1; shield=2;

vardef ground@#(expr z,type,ang)=
	save GND;
	pair gnd@#; % unico pin %
	gnd@#=z;
	picture GND; GND=nullpicture;
	addto GND doublepath z--(z+(0,-.5gndlth)) withpen line;
	if type=shield:
		addto GND doublepath (z+(-.5gndlth,-.5gndlth))--(z+(.5gndlth,-.5gndlth)) withpen line;
		addto GND doublepath (z+(-.35gndlth,-.6gndlth))--(z+(.35gndlth,-.6gndlth)) withpen line;
		addto GND doublepath (z+(-.2gndlth,-.7gndlth))--(z+(.2gndlth,-.7gndlth)) withpen line;
	elseif type=simple:
		addto GND doublepath (z+(-.5gndlth,-.5gndlth))--(z+(.5gndlth,-.5gndlth)) 
		withpen pencircle scaled 2linewd;
	fi;
	draw GND rotatedaround(z,ang);
enddef;

newinternal junctiondiam;
junctiondiam=1.25mm;

vardef junction@#(expr z,name)(suffix $)=
	pair J@#; J@#=z;
	draw z withpen pencircle scaled junctiondiam;
	label.$(latex(name),z);
enddef;

vardef impedance@#(expr z,ang,name,val)=
	save imp;
	pair Z@#.l, Z@#.r; % pines %
	Z@#.l=z;
	Z@#.r=(z+(1.5implth,0)) rotatedaround(z,ang);
	picture imp; imp=nullpicture;
	
	addto imp doublepath z--(z+(.25implth,0));
	addto imp doublepath (z+(.25implth,-.18implth))--(z+(.25implth,.18implth))
	--(z+(1.25implth,.18implth))--(z+(1.25implth,-.18implth))--cycle;
	addto imp doublepath (z+(1.25implth,0))--(z+(1.5implth,0));
		
	draw imp rotatedaround(z,ang) withpen line;
	
	putlabel(Z@#.l,Z@#.r,.2implth,.2implth,ang,name,val);
enddef;

*/

int illuminating = 1;

MultiTerminal lamp(pair beg=(0,0), real dir=0, int type=normal,
                   Label label="", Label value="", bool draw=true)
{
  real r = 0.5*circle_size;
  MultiTerminal term;

  term = _circle_symbol(beg=beg, dir=dir, label=label, value=value);
  if (type==normal) {
    term.pLine.push(-r*dir(45) -- r*dir(45));
    term.pLine.push(-r*dir(-45) -- r*dir(-45));
  } else if (type==illuminating) {
    term.pLine.push((-r,0) -- (-r/2,0));
    term.pLine.push((r/2,0) -- (r,0));
    term.pLine.push(scale(r/2)*(E..N..W));
  }
  if (draw == true)
    term.draw();
  return term;
}

/*

//%%<--- Mesh current (corriente de malla) --->%%%

newinternal cw, ccw;
cw=0; ccw=1;

def imesh(expr c,wd,ht,dire,ang,name)=
	save im,r; picture im; numeric r;
	ahlength=3platsep; ahangle=20;
	if ht > wd: r=.2wd elseif ht < wd: r=.2ht fi;
	im=nullpicture;
	if dire=cw:
		addto im doublepath (xpart c - .5wd, ypart c - .5ht)
		--(xpart c - .5wd, ypart c + .5ht-r){up}
		..{right}(xpart c - .5wd + r, ypart c + .5ht)
		--(xpart c + .5wd - r, ypart c + .5ht){right}
		..{down}(xpart c + .5wd,ypart c + .5ht - r)
		--(xpart c + .5wd,ypart c - .5ht + r){down}
		..{left}(xpart c + .5wd - r,ypart c - .5ht)
		--(xpart c - .25wd, ypart c - .5ht);
		addto im contour arrowhead (xpart c - .5wd, ypart c - .5ht)
		--(xpart c - .5wd, ypart c + .5ht-r){up}
		..{right}(xpart c - .5wd + r, ypart c + .5ht)
		--(xpart c + .5wd - r, ypart c + .5ht){right}
		..{down}(xpart c + .5wd,ypart c + .5ht - r)
		--(xpart c + .5wd,ypart c - .5ht + r){down}
		..{left}(xpart c + .5wd - r,ypart c - .5ht)
		--(xpart c - .25wd, ypart c - .5ht);
	elseif dire=ccw:
		addto im doublepath (xpart c + .5wd, ypart c - .5ht)
		--(xpart c + .5wd, ypart c + .5ht-r){up}
		..{left}(xpart c + .5wd - r, ypart c + .5ht)
		--(xpart c - .5wd + r, ypart c + .5ht){left}
		..{down}(xpart c - .5wd,ypart c + .5ht - r)
		--(xpart c - .5wd,ypart c - .5ht + r){down}
		..{right}(xpart c - .5wd + r,ypart c - .5ht)
		--(xpart c + .25wd, ypart c - .5ht);
		addto im contour arrowhead (xpart c + .5wd, ypart c - .5ht)
		--(xpart c + .5wd, ypart c + .5ht-r){up}
		..{left}(xpart c + .5wd - r, ypart c + .5ht)
		--(xpart c - .5wd + r, ypart c + .5ht){left}
		..{down}(xpart c + .5wd,ypart c + .5ht - r)
		--(xpart c - .5wd,ypart c - .5ht + r){down}
		..{right}(xpart c - .5wd + r,ypart c - .5ht)
		--(xpart c + .25wd, ypart c - .5ht);
	fi;
	
	if labeling=rotatelabel:
		addto im also thelabel(latex("$" & name & "$"),c);
	elseif labeling=norotatelabel:
		addto im also thelabel(latex("$" & name & "$") rotatedaround(c,-ang),c);
	fi;
	
	draw im rotatedaround (c,ang) withpen line;
enddef;

//%%<--- Reostatos --->%%%

newinternal rheolth, Rrheo, Lrheo; 
rheolth=2mm; Rrheo=1; Lrheo=2;

vardef rheostat@#(expr z,type,ang)=
	save reo; picture reo; reo=nullpicture;
	pair rh@#.i, rh@#.s, rh@#.r;
	rh@#.i=z; rh@#.s=(z+(0,6rheolth)) rotatedaround(z,ang);
	rh@#.r=(z+(3rheolth,6rheolth)) rotatedaround(z,ang);
	
	ahangle=20; ahlength=rheolth;

	if type=Lrheo:
		addto reo doublepath (z+(6rheolth,-3rheolth))--(z+(4rheolth,-3rheolth))
		--(z+(4rheolth,-.7rheolth));
		addto reo contour arrowhead (z+(6rheolth,-3rheolth))--(z+(4rheolth,-3rheolth))
		--(z+(4rheolth,-.9rheolth));
	
		addto reo doublepath z--(z+(rheolth,0)){down}.. for i=2 upto 4:
		{up}(z+(i*rheolth,0)){down}.. endfor {up}(z+(5rheolth,0))--(z+(6rheolth,0));
	
		reo=reo rotatedaround(z,90);
	elseif type=Rrheo:
		addto reo doublepath (z+(6rheolth,-3rheolth))--(z+(4rheolth,-3rheolth))
		--(z+(4rheolth,-.7rheolth));
		addto reo contour arrowhead (z+(6rheolth,-3rheolth))--(z+(4rheolth,-3rheolth))
		--(z+(4rheolth,-.9rheolth));
	
		addto reo doublepath z--(z+(1.5rheolth,0))--(z+(1.75rheolth,.75rheolth))--
		for i=.5 step .5 until 2.5:	(z+((1.75+i)*rheolth,((-1)**(2i))*.75rheolth))--
		endfor (z+(4.5rheolth,0))--(z+(6rheolth,0)) withpen line;
	
		reo=reo rotatedaround(z,90);
	fi;
	draw reo rotatedaround(z,ang) withpen line;
enddef;

*/

// Loop symbols for Kirchhoff's rules.

void kirchhoff_loop(picture pic=currentpicture, pair points[],
                    pen outline=kirchhoff_pen, real aspace=-1) {
  // draw kirchhoff loop underneath currentpicture
  picture newpic;
  int i;
  guide g;
  pair a = points[0] - points[points.length-1];  // arrow distance
  if (aspace < 0)
    aspace = 3*linewidth(outline);  // one dot diameter
  real alength = max(0.5*length(a), length(a) - aspace - linewidth(outline)/2);
  a = alength*unit(a);
  pair astop = points[points.length-1] + a;
  dot(newpic, points[0], scale(3)*outline);
  for (int i=0; i < points.length; ++i)
    g = g--points[i];
  g = g -- astop;
  draw(newpic, g, outline, Arrow(size=3*linewidth(outline)));
  add(pic, newpic, above=false);
}
