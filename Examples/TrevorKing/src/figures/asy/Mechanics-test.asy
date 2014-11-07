/* Test suite for Mechanics.asy.
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

import three;
import Mechanics;

currentprojection = TopView;

real u = 1cm;

LabeledCircle lc = LabeledCircle(center=(-2u, 1u));
lc.draw();
lc.label = "a";
lc.center = (-2u, 0.5u);
lc.draw();
lc.draw_label(Label("e", align=E));
lc.center = (-2u, 0);
lc.label.align = W;
lc.draw();
lc.draw_label("b");
lc.draw_label(Label("c", align=E));
lc.draw_label(rotate(90)*Label("e------I", align=S));
lc.draw_label(rotate(45)*Label("e------I", align=S));
lc.center = (-2u, -2u);
lc.radius = u/2;
lc.label.align = E;
lc.draw();
lc.center = (-2u, -3u);
lc.label.align = E;
lc.draw();

Mass a = Mass(center=(0,0));
Mass b = Mass(center=(2u,1u), Label("$m_b$", align=N));
Mass c = Mass(center=(1u,-2u), Label("$m_c$", align=E));
Mass ms[] = {a, b, c};
Distance dab = Distance(a.center(), b.center(), scale=u,
    L=Label("$r_{ab}$", align=N, embed=Shift));
Distance dac = Distance(a.center(), c.center(), scale=u,
    L=Label("$r_{ac}$", align=RightSide));
Distance ds[] = {dab, dac};
Angle bac1 = Angle(
    b.center(), a.center(), c.center(), radius=.7u, fill=red, L="$\theta_T'$");
Angle bac2 = Angle(
    b.center(), a.center(), c.center(), radius=-.5u, L="$\theta_T$");
Angle bac3 = Angle(
    b.center(), a.center(), c.center(), radius=1.5u,
    L=Label("$\theta_T''$", position=Relative(0.3)));
Angle as[] = {bac1, bac2, bac3};

Vector vs[];

draw_ijhat((-u, u));

vs.push(Vector(center=(-1u,-4u), phi=90, "Out"));
vs.push(Vector(center=(-1u,-5.5u), phi=-90, "In"));
vs.push(Vector(center=(0, -4u), mag=1.5u, dir=-90, phi=60,
               Label("60dg OOP", position=EndPoint)));

for (int i=0; i<as.length; i+=1)
  as[i].draw();
for (int i=0; i<ms.length; i+=1)
  ms[i].draw();
for (int i=0; i<ds.length; i+=1)
  ds[i].draw();
for (int i=0; i<vs.length; i+=1)
  vs[i].draw();

Pendulum p = makePendulum(
    pivot=(3.5u,-3u), mass=b, length=4u, angleDeg=-20,
    angleL="$\rho$", stringL=Label("r", embed=Shift));

real len = abs(p.pivot.x-b.center().x);
Spring s = Spring(
    pFrom=b.center()-(2u,0), b.center(), L=Label("$k_1$", align=N));
s.draw();
s = Spring(
    pFrom=b.center(), pTo=(p.pivot.x, b.center().y+0.5u),
    L=Label("$k_2$", align=LeftSide, position=Relative(0.7)));
s.draw();

p.draw(drawVertical=true);

Surface s = Surface(pFrom=(0,-7u), pTo=(3.5u, -7u),
    L=Label("Table", align=Center, embed=Shift));
s.draw();

Vector v1 = Vector((-2u, -7u), Label("$v_1$", align=E, position=EndPoint));
v1.draw();
Vector v2 = Vector(v1.center, mag=10mm, dir=90, Label("$v_2$", align=W));
v2.draw();
Vector v3 = v1 + v2;
v3.label = Label("$v_3 = v_1 + v_2$", align=E, position=EndPoint);
v3.draw();
Vector v4 = v1 - v2;
v4.label = Label("$v_4 = v_1 - v_2$", align=S, position=EndPoint);
v4.draw();

Ring rg = Ring(
    (0, -9u, 0), normal=(1, 1, 1), radius=5mm, axis_pre=5mm, axis_post=5mm,
    outline=red, fill=blue, axis=black, L="ring",
    axis_label=Label("$x$", position=EndPoint, align=RightSide));
rg.draw();

Vector v = Velocity();
pair vfc = (5u,0);  // vector field center
real vfwidth = 2u;
real vfheight = 2u;
real vfdv = u/3;
real vfbuf = 2pt;

draw(shift(vfc)*xscale(vfwidth-2*vfbuf)*yscale(vfheight-2*vfbuf)
     *shift((-.5,-.5))*unitsquare, grey);
vector_field(vfc, width=vfwidth, height=vfheight, dv=vfdv, buf=vfbuf, v=v,
             outline=green+dashed);

vfc -= (0, vfheight + u);
v.dir = 90;
draw(shift(vfc)*xscale(vfwidth-2*vfbuf)*yscale(vfheight-2*vfbuf)
     *shift((-.5,-.5))*unitsquare, grey);
vector_field(vfc, width=vfwidth, height=vfheight, dv=vfdv, buf=vfbuf, v=v,
             outline=green+dashed);

vfc -= (0, vfheight + u);
v.dir = -180;
draw(shift(vfc)*xscale(vfwidth-2*vfbuf)*yscale(vfheight-2*vfbuf)
     *shift((-.5,-.5))*unitsquare, grey);
vector_field(vfc, width=vfwidth, height=vfheight, dv=vfdv, buf=vfbuf, v=v,
             outline=green+dashed);

vfc += (vfwidth + u, 2*(vfheight + u));
v.dir = -90;
draw(shift(vfc)*xscale(vfwidth-2*vfbuf)*yscale(vfheight-2*vfbuf)
     *shift((-.5,-.5))*unitsquare, grey);
vector_field(vfc, width=vfwidth, height=vfheight, dv=vfdv, buf=vfbuf, v=v,
             outline=green+dashed);

vfc -= (0, vfheight + u);
v.dir = -10;
draw(shift(vfc)*xscale(vfwidth-2*vfbuf)*yscale(vfheight-2*vfbuf)
     *shift((-.5,-.5))*unitsquare, grey);
vector_field(vfc, width=vfwidth, height=vfheight, dv=vfdv, buf=vfbuf, v=v,
             outline=green+dashed);

vfc -= (0, vfheight + u);
v.phi = 90;
draw(shift(vfc)*xscale(vfwidth-2*vfbuf)*yscale(vfheight-2*vfbuf)
     *shift((-.5,-.5))*unitsquare, grey);
vector_field(vfc, width=vfwidth, height=vfheight, dv=vfdv, buf=vfbuf, v=v,
             outline=green+dashed);
