/* Useful functions for drawing Physics 102 figures.
 *
 * Copyright (C) 2008-2009 W. Trevor King <wking@drexel.edu>
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
import Mechanics;


// ---------------------- Charges -------------------------

pen pChargePen = red;
pen nChargePen = blue;
pen neutralChargePen = grey;

// charged particle
struct Charge {
  LabeledCircle lc;
  real q;
  
  void operator init(pair center=(0,0), real q=1, real radius=2mm,
                     pen outline=currentpen, pen fill=pChargePen, Label L="") {
    this.lc.operator init(center=center, radius=radius, outline=outline,
                          fill=fill, L=L);
    this.q = q;
  }

  pair center() { return this.lc.center; }
  void set_center(pair center) { this.lc.center = center; }
  void draw(picture pic=currentpicture) = this.lc.draw;
}

// positive charge
Charge pCharge(pair center=(0,0), real q=1, real radius=2mm,
               pen outline=currentpen, Label L="")
{
  return Charge(center=center, q=q, radius=radius, outline=outline,
                fill=pChargePen, L=L);
}

// negative charge
Charge nCharge(pair center=(0,0), real q=-1, real radius=2mm,
               pen outline=currentpen, Label L="")
{
  return Charge(center=center, q=q, radius=radius, outline=outline,
                fill=nChargePen, L=L);
}

// neutral charge
Charge neutralCharge(pair center=(0,0), real radius=2mm,
                     pen outline=currentpen, Label L="")
{
  return Charge(center=center, q=0, radius=radius, outline=outline,
                fill=neutralChargePen, L=L);
}

// auto-signed charge
Charge aCharge(pair center=(0,0), real q=1, real radius=2mm,
               pen outline=currentpen, Label L="")
{
  Charge c;
  if (q > 0) {
    c = pCharge(center, q, radius, outline, L);
  } else if (q < 0) {
    c = nCharge(center, q, radius, outline, L);
  } else {
    c = neutralCharge(center, radius, outline, L);
  }
  return c;
}

// ---------------------- Vectors -------------------------

pen EFieldPen = rgb(1,0.5,0.2);    // orange
pen BFieldPen = rgb(0.1,1,0.2);    // green
pen CurrentPen = rgb(0.8,0.1,0.8); // purple

// electric field
Vector EField(pair center=(0,0), real mag=5mm, real dir=0, real phi=0, Label L="")
{
  Vector v = Vector(center=center, mag=mag, dir=dir, phi=phi, L=L, outline=EFieldPen);
  return v;
}

// magnetic field
Vector BField(pair center=(0,0), real mag=5mm, real dir=0, real phi=0, Label L="")
{
  Vector v = Vector(center=center, mag=mag, dir=dir, phi=phi, L=L, outline=BFieldPen);
  return v;
}

Vector Current(pair center=(0,0), real mag=5mm, real dir=0, real phi=0, Label L="")
{
  Vector v = Vector(center=center, mag=mag, dir=dir, phi=phi, L=L, outline=CurrentPen);
  return v;
}

// ------------------ Electric fields --------------------

// Electric field at a due to b
Vector CoulombEField(pair a, Charge b, Label L="", real scale=1mm,
                     real unit=1mm)
{
  pair r = a - b.center();
  real mag, dir;
  mag = (abs(b.q)*(scale/length(r))^2)*unit;
  dir = degrees(r);
  if (b.q < 0) {
    dir += 180;
  }
  Vector v = EField(center=a, mag=mag, dir=dir, L=L);
  return v;
}

void CoulombEFields(pair a, Charge c[], string subscripts[]={}, real scale=1mm,
                    real unit=1mm)
{
  Vector E;
  string s, sub;
  for (int i=0; i<c.length; i+=1) {
    if (i < subscripts.length) {
      sub = subscripts[i];
    } else {
      sub = format("%d", i+1);
    }
    s = "$E_{" + sub + "}$";
    E = CoulombEField(
        a, c[i], L=Label(s, position=EndPoint, align=LeftSide),
        scale=scale, unit=unit);
    E.draw();
  }
}

// ---------------------- Forces -------------------------

// Force of a on b
Vector CoulombForce(Charge a, Charge b, Label L="", real scale=1mm, real unit=1mm)
{
  pair r = b.center() - a.center();
  real mag, dir;
  mag = ((a.q*b.q)*(scale/length(r))^2)*unit;
  dir = degrees(r);
  Vector v = Force(center=b.center(), mag=mag, dir=dir, L=L);
  return v;
}

void CoulombForces(Charge c[], string subscripts[]={}, real scale=1mm,
                   real unit=1mm)
{
  Vector F;
  string s, subi, subj;
  for (int i=0; i<c.length; i+=1) {
    if (i < subscripts.length) {
      subi = subscripts[i];
    } else {
      subi = format("%d", i+1);
    }
    for(int j=0; j<c.length; j+=1) {
      if (i==j) continue;
      if (j < subscripts.length) {
        subj = subscripts[j];
      } else {
        subj = format("%d", j+1);
      }
      s = "$F_{" + subi + "," + subj + "}$";
      F = CoulombForce(
          c[i], c[j], L=Label(s, position=EndPoint, align=LeftSide),
          scale=scale, unit=unit);
      F.draw();
    }
  }
}


