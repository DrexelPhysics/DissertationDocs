import Circ;
import ElectroMag;
import Mechanics;

real u = 0.75cm;
real w = 1.75u;
real wo = 0.75u;

MultiTerminal bat = source(dir=180, type=DC);

Block hot = Block(
  center=bat.center + (0, 1.3u), width=4u, height=u, fill=red, L="heat sink");
Block h_in = Block(center=hot.center + (-u, 0.75u), width=w, height=u/2);
Block h_out = Block(center=hot.center + (u, 0.75u), width=w, height=u/2);
Block n = Block(center=h_in.center + (0, 1.25u), width=w, height=2u,
  fill=opacity(0.25)+blue, L=Label("n", align=E));
Block p = Block(center=h_out.center + (0, 1.25u), width=w, height=2u,
  fill=opacity(0.25)+red, L=Label("p", align=W));
Block bridge = Block(
  center=hot.center + (0, 3u), width=3.75u, height=u/2);
Block cold = Block(
  center=hot.center + (0, 3.75u), width=3.75u, height=u,
  fill=blue, L="cooled");

MultiTerminal cur = current(draw=false);
cur.centerto(bridge.center + (-1, 0), bridge.center + (1, 0));

Charge electron = nCharge(n.center + (-0.3u, 0), "-");
Vector v_e = Velocity(center=electron.center(), dir=-90);

Charge hole = pCharge(p.center + (0.3u, 0), "+");
Vector v_h = Velocity(center=hole.center(), dir=-90);

wire(bat.terminal[1], h_in.center + (-h_in.width/2, 0), type=rlsq, dist=-2u);
wire(bat.terminal[0], h_out.center + (h_out.width/2, 0), type=rlsq, dist=2u);
hot.draw();
h_in.draw();
h_out.draw();
n.draw();
p.draw();
bridge.draw();
cold.draw();
cur.draw();

v_e.draw();
electron.draw();
v_h.draw();
hole.draw();
