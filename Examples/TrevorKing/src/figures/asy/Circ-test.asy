/* Test suite for Circ.asy.
 *
 * Copyright (C) 2008-2012 W. Trevor King <wking@drexel.edu>
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

import Circ;

real u = 2cm, v=0;

write("resistor");
MultiTerminal Rn = resistor(beg=(0,v), dir=0, type=normal,
    label=Label("$R_{normal}$", align=N), value=Label("$30\ohm$", align=S));
dot("beg", Rn.terminal[0], NW, red);
dot("end", Rn.terminal[1], NE, red);
dot("center", Rn.center, S, red);

MultiTerminal Rvb = resistor(beg=(2u,v), dir=0, type=variable,
    label=Label("$R_{variable}$", align=NW),
    value=Label("$30\kohm$", align=SE));
v -= u;

write("capacitor");
MultiTerminal Cn = capacitor((0,v), type=normal, "$C_{normal}$",
    "30 $\mu$F");
MultiTerminal Ce = capacitor((u,v), type=electrolytic, "$C_{electrolytic}$",
    "30 $\mu$F");
MultiTerminal Cvb = capacitor((2u,v), type=variable, "$C_{variable}$",
    "30 $\mu$F");
MultiTerminal Cvt = capacitor((3u,v), type=variant, "$C_{variant}$",
    "30 $\mu$F");
v -= u;

write("inductor");
MultiTerminal Lup = inductor((0,v), type=Up, "$L_{Up}$", "30 H");
MultiTerminal Ldown = inductor((u,v), type=Down, "$L_{Down}$", "30 H");
v -= u;

write("diode");
MultiTerminal Dn = diode((0,v), type=normal, "$D_{normal}$", "1.3 V");
MultiTerminal Dz = diode((u,v), type=zener, "$D_{zener}$", "1.3 V");
MultiTerminal Dled = diode((2u,v), type=LED, "$D_{LED}$", "1.7 V");
v -= u;

write("battery");
MultiTerminal B = battery((0,v), "Battery", "1.5 V");
v -= u;

write("switch");
MultiTerminal So = switchSPST((0,v), type=open, "$S$", "Open");
MultiTerminal Sc = switchSPST((u,v), type=closed, "$S$", "Closed");
MultiTerminal SPDT_o = switchSPDT((2u,v), type=open, "$S$", "Open");
MultiTerminal SPDT_a = switchSPDT((3u,v), type=closed_a, "$S$", "Closed-A");
MultiTerminal SPDT_b = switchSPDT((4u,v), type=closed_b, "$S$", "Closed-B");
v -= u;

write("current");
MultiTerminal Icurr = current((0,v), "I", "10 A");
v -= u;

write("source");
MultiTerminal Sdc = source((0,v), type=DC, "DC", "5 V");
MultiTerminal Sac = source((u,v), type=AC, "AC", "5 V$_{pp}$");
MultiTerminal Si = source((2u,v), type=I, "I", "5 A");
MultiTerminal Sv = source((3u,v), type=V, "V", "5 V");
v -= u;

write("lamp");
MultiTerminal Ln = lamp((0,v), 0, normal, "indicator", "5\ohm");
MultiTerminal Li = lamp((u,v), 0, illuminating, "illuminator", "5\ohm");
v -= 1.5u;

write("positioning");
MultiTerminal Spos = source((u,v), dir=90, type=DC, "DC", "5 V");
MultiTerminal Rpos = resistor(type=normal,
    label=rotate(90)*Label("+offset", align=W),
    value=rotate(90)*Label("5 \ohm", align=E), draw=false);
Rpos.centerto(Spos.terminal[0], Spos.terminal[1], offset=u);
Rpos.draw();
dot("Sa", Spos.terminal[0], S);
dot("Sb", Spos.terminal[1], N);
dot("Ra", Rpos.terminal[0], S);
dot("Rb", Rpos.terminal[1], N);
MultiTerminal Cpos = capacitor(type=normal, "-2offset", "4 F",draw=false);
Cpos.centerto(Spos.terminal[0], Spos.terminal[1], offset=-2u);
Cpos.draw();
v -= u;

write("wires");
dot("nsq", (0,v), N);
dot("b", (u/2,v-u/2), S);
wire((0,v), (u/2,v-u/2), nsq);
dot("udsq", (u,v), N);
dot("b", (3u/2,v-u/2), S);
wire((u,v), (3u/2,v-u/2), udsq);
dot("rlsq", (2u,v), N);
dot("b", (5u/2,v-u/2), S);
wire((2u,v), (5u/2,v-u/2), rlsq);
dot("udsq w/d", (3u,v), N);
dot("b", (7u/2,v-u/2), S);
wire((3u,v), (7u/2,v-u/2), udsq, -u/4);
dot("rlsq w/d", (4u,v), N);
dot("b", (9u/2,v-u/2), S);
wire((4u,v), (9u/2,v-u/2), rlsq, u/4);
v -= u;

write("circuit");
v -= u/2;  // this circuit takes up more height than the previous lines.
MultiTerminal Ccirc = capacitor((0,v), dir=90);
MultiTerminal Rcirc = resistor(draw=false);
two_terminal_centerto(Ccirc, Rcirc);
Rcirc.shift((u,0));  // gratuitous use of shift, but whatever...
Rcirc.draw();
// In the following, we assume the resistor is longer than the
// capacitor.  If that is not true, you can find the corners of the
// circuit programatically and use those corners.
wire(Rcirc.terminal[1], Ccirc.terminal[1], rlsq);
wire(Rcirc.terminal[0], Ccirc.terminal[0], rlsq);
pair Pcirc[] = {
  (Ccirc.terminal[0].x,Rcirc.terminal[0].y),
  (Ccirc.terminal[1].x,Rcirc.terminal[1].y),
  Rcirc.terminal[1], Rcirc.terminal[0]};
kirchhoff_loop(Pcirc);
v -= u;
