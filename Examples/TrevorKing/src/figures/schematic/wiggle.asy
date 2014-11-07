// Define Wiggle structure for drawing random wiggles.

struct Wiggle {
  // Generate a horizontal wiggly line, centered at CENTER (x,y)
  // with a width WIDTH x
  // and randomly distributed heights.
  // The random points are unformly distributed within an envelope
  // with the maximum possible deviation given by ROUGHNESS x

  pair start;
  pair end;
  real roughness;
  real tense;
  int num;
  int random_seed;
  pair points[];

  void generate(bool labels=false) {
    int n = this.num;
    pair step = (this.end-this.start) / (n-1);
    pair perp = scale(this.roughness)*rotate(90)*unit(step);
    real y, envelope;
    srand(this.random_seed);
    for (int i=0; i < n; i+=1) {
      if (i == (n-1)/2 || i == 0 || i == n-1) {
        y = 0.0;
      } else {
        real frac = i/n;
        envelope = (frac*(1.0-frac)*4)**3;
        y = (2*unitrand()-1.0) * envelope;
      }
      this.points.push(this.start + i*step + perp*y);
      if (labels==true)
        dot(format("%d", i), this.points[-1], S);
    }
  }

  guide guide() {
    guide g;
    for (int i=0; i < this.points.length; i+=1) {
      g = g .. tension this.tense .. this.points[i];
    }
    this.end = point(g, length(g));
    return g;
  }

  void operator init(pair start=(0,0), pair end=(1cm,0), real roughness=1cm,
                     real tense=1, int num=15, int random_seed=5) {
    this.start = start;
    this.end = end;
    this.roughness = roughness;
    this.tense = tense;
    this.num = num;
    this.random_seed = random_seed;
    this.generate();
  }
}

struct RandomWalk {
  // Generate a random walk starting from START (x,y)
  // with NUM steps, each of step-size DX,
  // and randomly distributed step directions.

  pair start;
  pair end;
  real dx;
  int num;
  real tense;
  int random_seed;
  pair points[];

  void generate(bool labels=false) {
    int n = this.num;
    srand(this.random_seed);
    pair p = this.start;
    this.points.push(p);
    if (labels==true)
      dot("0", this.points[0], S);
    for (int i=1; i <= this.num; i+=1) {
      real theta = 360*unitrand();
      p += rotate(theta)*(this.dx, 0);
      this.points.push(p);
      if (labels==true)
        dot(format("%d", i), this.points[i], S);
    }
    this.end = p;
  }

  void align(real dir) {
    real dtheta = dir - degrees(this.end - this.start);
    for (int i=1; i < this.points.length; i+=1) {
      this.points[i] = rotate(dtheta, this.start)*this.points[i];
    }
    this.end = this.points[this.num];
  }

  guide curved_guide() {
    guide g;
    for (int i=0; i < this.points.length; i+=1) {
      g = g .. tension this.tense .. this.points[i];
    }
    return g;
  }

  guide straight_guide(interpolate join=operator ..) {
    guide g;
    for (int i=0; i < this.points.length; i+=1) {
      g = g -- this.points[i];
    }
    return g;
  }

  void operator init(pair start=(0,0), real dx=3mm,
                     real tense=1, int num=15, int random_seed=25) {
    this.start = start;
    this.dx = dx;
    this.tense = tense;
    this.num = num;
    this.random_seed = random_seed;
    this.generate();
  }
}
