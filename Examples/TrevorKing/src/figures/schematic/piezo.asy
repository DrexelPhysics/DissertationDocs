// Cylindrical piezo operating principle graphic

//size(x=9cm,keepAspect=true);

import graph3;
import three;

pen piezo_pen = opacity(0.1) + grey;
pen x_electrode_pen = opacity(0.4) + red;
pen y_electrode_pen = opacity(0.4) + blue;
pen z_electrode_pen = opacity(0.4) + green;
pen outline_pen = linewidth(1pt) + black;

real R = 1.1cm;
real r = 0.9cm;
real h = 5cm;
real ethick = 1pt;
real espace = 1cm;
real theta1 = 0.4*pi;
real dtheta = 2*asin(espace/(R+r)/4);
real theta2 = theta1 + pi/2 - dtheta;
real tavg = (theta1 + theta2)/2;
real dr = 4pt;
real dR = 6pt;

currentprojection = FrontView;

triple cylinder(real r, real theta, real z) {
    return (r*cos(theta), r*sin(theta), z);
}

struct Cylinder {
    real r;
    real R;
    real z1;
    real z2;
    real theta1;
    real theta2;

    void operator init(real r=0, real R=1, real z1=0, real z2=1,
            real theta1=0, real theta2=2pi) {
        this.r = r;
        this.R = R;
        this.z1 = z1;
        this.z2 = z2;
        this.theta1 = theta1;
        this.theta2 = theta2;
    }

    triple _cap(pair t) {
        return cylinder(t.x, t.y, 0);
    }

    triple _inner_wall(pair t) {
        return cylinder(this.r, t.x, t.y);
    }

    triple _outer_wall(pair t) {
        return cylinder(this.R, t.x, t.y);
    }

    triple _box1(pair t) {
        return cylinder(t.x, this.theta1, t.y);
    }

    triple _box2(pair t) {
        return cylinder(t.x, this.theta2, t.y);
    }

    surface cap() {
        // surface() described in graph3 documentation.
        return surface(
            this._cap, (this.r, this.theta1), (this.R, this.theta2), 8, 8, Spline);
    }

    surface[] surfaces() {
        surface ret[];
        surface cap = this.cap();
        ret.push(shift(0, 0, this.z1)*cap);
        ret.push(shift(0, 0, this.z2)*cap);
        ret.push(surface(
            this._outer_wall, (this.theta1, this.z1), (this.theta2, this.z2),
            8, 8, Spline));
        ret.push(surface(
            this._inner_wall, (this.theta1, this.z1), (this.theta2, this.z2),
            8, 8, Spline));
        if (this.theta1 % 2pi != this.theta2 % 2pi) {
            ret.push(surface(this._box1, (this.r, this.z1), (this.R, this.z2)));
            ret.push(surface(this._box2, (this.r, this.z1), (this.R, this.z2)));
        }
        return ret;
    }

    path3[] cap_paths() {
        triple c = (0, 0, 0);
        real t1 = degrees(this.theta1);
        real t2 = degrees(this.theta2);
        return new path3[] {
            arc(c, this.r, 90, t1, 90, t2, (0, 0, 1)),
            arc(c, this.R, 90, t1, 90, t2, (0, 0, 1)),
            };
    }

    path3[] outline() {
        path3 ret[];
        path3 caps[] = this.cap_paths();
        ret.push(shift(0, 0, this.z1)*caps[0]);
        ret.push(shift(0, 0, this.z1)*caps[1]);
        ret.push(shift(0, 0, this.z2)*caps[0]);
        ret.push(shift(0, 0, this.z2)*caps[1]);
        if (this.theta1 % 2pi != this.theta2 % 2pi) {
            ret.push(
                cylinder(this.r, this.theta1, this.z1) --
                cylinder(this.r, this.theta1, this.z2) --
                cylinder(this.R, this.theta1, this.z2) --
                cylinder(this.R, this.theta1, this.z1) -- cycle);
            ret.push(
                cylinder(this.r, this.theta2, this.z1) --
                cylinder(this.r, this.theta2, this.z2) --
                cylinder(this.R, this.theta2, this.z2) --
                cylinder(this.R, this.theta2, this.z1) -- cycle);
        }
        return ret;
    }

    void draw(pen surface_pen, pen outline_pen, transform3 t=identity4) {
        surface surfaces[] = this.surfaces();
        path3 paths[] = this.outline();
        for (int i=0; i < surfaces.length; ++i) {
            draw(t*surfaces[i], surface_pen, nolight);
        }
        for (int i=0; i < paths.length; ++i) {
            draw(t*paths[i], outline_pen, nolight);
        }
    }

    void cap(pen surface_pen, pen outline_pen, transform3 t=identity4) {
        surface cap = this.cap();
        path3 paths[] = this.cap_paths();
        draw(t*cap, surface_pen, nolight);
        for (int i=0; i < paths.length; ++i) {
            draw(t*paths[i], outline_pen, nolight);
        }
    }
}

void wire(Label label="", triple a, triple b, transform3 t=identity4,
        align align=NoAlign) {
    draw(t*(a--b));
    dot(t*a);
    dot(label, t*b, align=align);
}

Cylinder piezo = Cylinder(r, R, -h/2, h/2);
Cylinder z_in = Cylinder(r-ethick, r, espace/2, h/2-espace/2, 0, 2pi);
Cylinder z_out = Cylinder(R, R+ethick, espace/2, h/2-espace/2, 0, 2pi);
Cylinder xa_in = Cylinder(
    r-ethick, r, -h/2+espace/2, -espace/2, theta1, theta2);
Cylinder xa_out = Cylinder(
    R, R+ethick, -h/2+espace/2, -espace/2, theta1, theta2);
Cylinder ya_in = Cylinder(
    r-ethick, r, -h/2+espace/2, -espace/2, theta1+pi/2, theta2+pi/2);
Cylinder ya_out = Cylinder(
    R, R+ethick, -h/2+espace/2, -espace/2, theta1+pi/2, theta2+pi/2);
Cylinder xb_in = Cylinder(
    r-ethick, r, -h/2+espace/2, -espace/2, theta1+pi, theta2+pi);
Cylinder xb_out = Cylinder(
    R, R+ethick, -h/2+espace/2, -espace/2, theta1+pi, theta2+pi);
Cylinder yb_in = Cylinder(
    r-ethick, r, -h/2+espace/2, -espace/2, theta1-pi/2, theta2-pi/2);
Cylinder yb_out = Cylinder(
    R, R+ethick, -h/2+espace/2, -espace/2, theta1-pi/2, theta2-pi/2);

transform3 piezo_transform = shift(-1.5*R, 0, 0)*rotate(12, (1, 0, 0));

piezo.draw(piezo_pen, outline_pen, piezo_transform);
z_in.draw(z_electrode_pen, outline_pen, piezo_transform);
z_out.draw(z_electrode_pen, outline_pen, piezo_transform);
xa_in.draw(x_electrode_pen, outline_pen, piezo_transform);
xa_out.draw(x_electrode_pen, outline_pen, piezo_transform);
ya_in.draw(y_electrode_pen, outline_pen, piezo_transform);
ya_out.draw(y_electrode_pen, outline_pen, piezo_transform);
xb_in.draw(x_electrode_pen, outline_pen, piezo_transform);
xb_out.draw(x_electrode_pen, outline_pen, piezo_transform);
yb_in.draw(y_electrode_pen, outline_pen, piezo_transform);
yb_out.draw(y_electrode_pen, outline_pen, piezo_transform);


transform3 z_transform = shift((1.5*R, 0, 1.3*R))*rotate(90, (1, 0, 0));
transform3 label_transform = shift((0, 1cm, 0));

piezo.draw(piezo_pen, invisible, z_transform);
z_in.draw(z_electrode_pen, invisible, z_transform);
z_out.draw(z_electrode_pen, invisible, z_transform);
wire("$z_-$", (-R-ethick, 0, 0), (-R-ethick, 3R/4, 0),
    label_transform*z_transform, align=W);
wire("$z_+$", (-r+ethick, 0, 0), (-r/3, 0, 0),
    label_transform*z_transform, align=E);

transform3 xy_transform = shift((1.5*R, 0, -1.3*R))*rotate(90, (1, 0, 0));

piezo.draw(piezo_pen, invisible, xy_transform);
xa_in.draw(x_electrode_pen, invisible, xy_transform);
xa_out.draw(x_electrode_pen, invisible, xy_transform);
ya_in.draw(y_electrode_pen, invisible, xy_transform);
ya_out.draw(y_electrode_pen, invisible, xy_transform);
xb_in.draw(x_electrode_pen, invisible, xy_transform);
xb_out.draw(x_electrode_pen, invisible, xy_transform);
yb_in.draw(y_electrode_pen, invisible, xy_transform);
yb_out.draw(y_electrode_pen, invisible, xy_transform);
wire("$x_-$", cylinder(r-ethick, tavg, 0), cylinder(r-ethick-dr, tavg, 0),
    label_transform*xy_transform, align=-expi(tavg));
wire("$x_+$", cylinder(R+ethick, tavg, 0), cylinder(R+ethick+dR, tavg, 0),
    label_transform*xy_transform, align=expi(tavg));
wire("$y_-$", cylinder(r-ethick, tavg + pi/2, 0),
    cylinder(r-ethick-dr, tavg + pi/2, 0),
    label_transform*xy_transform, align=-expi(tavg + pi/2));
wire("$y_+$", cylinder(R+ethick, tavg + pi/2, 0),
    cylinder(R+ethick+dR, tavg + pi/2, 0),
    label_transform*xy_transform, align=expi(tavg + pi/2));
wire("$x_+$", cylinder(r-ethick, tavg + pi, 0),
    cylinder(r-ethick-dr, tavg + pi, 0),
    label_transform*xy_transform, align=-expi(tavg + pi));
wire("$x_-$", cylinder(R+ethick, tavg + pi, 0),
    cylinder(R+ethick+dR, tavg + pi, 0),
    label_transform*xy_transform, align=expi(tavg + pi));
wire("$y_+$", cylinder(r-ethick, tavg - pi/2, 0),
    cylinder(r-ethick-dr, tavg - pi/2, 0),
    label_transform*xy_transform, align=-expi(tavg - pi/2));
wire("$y_-$", cylinder(R+ethick, tavg - pi/2, 0),
    cylinder(R+ethick+dR, tavg - pi/2, 0),
    label_transform*xy_transform, align=expi(tavg - pi/2));
