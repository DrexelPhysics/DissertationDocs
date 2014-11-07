/* Test suite for ElectroMag.asy.
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

import ElectroMag;

real u = 1cm;

Charge a = pCharge(center=(0.5u,2u));
Charge b = aCharge(center=(0,-0.5u), q=1);
Charge c = nCharge(center=(-3u,-0.5u), q=-3);
Charge cs[] = {a,b,c};
string subscripts[] = {"a"};
Distance dab = Distance(b.center(), a.center(), scale=u, L="$r_1$");
Distance dbc = Distance(c.center(), b.center(), scale=u, L="$r_2$");
Distance ds[] = {dab};
Angle abc = Angle(
    a.center(), b.center(), c.center(), radius=.5u, L="$\theta_T$");
Angle bac = Angle(
    b.center(), a.center(), c.center(), radius=-0.4u, L="$\phi_x$");
Angle as[] = {abc, bac};

//write(a.center.x);
//write(a.center.y);
for (int i=0; i<cs.length; i+=1)
  cs[i].draw();
for (int i=0; i<ds.length; i+=1)
  ds[i].draw();
for (int i=0; i<as.length; i+=1)
  as[i].draw();

CoulombEFields((-0.5u, 1.2u), c=cs, subscripts=subscripts, scale=2u, unit=u/2);
//Vector Fba = CoulombForce(b,a, scale=2u, unit=u);
//Fba.draw();
CoulombForces(c=cs, subscripts=subscripts, scale=2u, unit=u);

Charge a = aCharge(center=(-2u, 2u), q=0);
a.draw();
Vector v = EField(a.center(), mag=u/2, dir=0,L="E"); v.draw();
Vector v = BField(a.center(), mag=u/2, dir=90,L="B"); v.draw();
Vector v = Velocity(a.center(), mag=u/2, dir=180,L="$v$"); v.draw();

Vector Ic = Current(center=(-0.7u, 2.2u), phi=90, L="$I$"); Ic.draw();
draw(shift(Ic.center)*scale(16pt)*unitcircle, BFieldPen, ArcArrow);

a = aCharge(center=(-3u, 2u), q=-1);
a.draw();
