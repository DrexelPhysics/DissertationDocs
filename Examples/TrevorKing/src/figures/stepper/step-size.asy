import wtk_graph;

size(6cm, 4cm, IgnoreAspect);

scale(Linear, Linear);

struct piezo_approach_t {
  int start;
  int stop;
}

struct stepper_approach_t {
  piezo_approach_t[] piezo_approach;
}

piezo_approach_t piezoApproach(stepper_approach_t[] calibration,
                               int stepper_approach, int piezo_approach) {
  return calibration[stepper_approach].piezo_approach[piezo_approach];
}

file fin = input('step-size.data');
real[][] a = fin.dimension(0, 4);
a = transpose(a);

real[] total = a[0];
real[] deflection = a[1];
real[] stepper = a[2];
real[] piezo = a[3];

real pmax = max(piezo);  /* maximum piezo approach */

stepper_approach_t[] calibration;
calibration.cyclic = true;

/* split data into piezo approaches nested inside stepper approaches */
bool last_stepper_approach = false;
bool stepper_approach;
bool last_piezo_approach = false;
bool piezo_approach;
int i;
for (i = 0; i < deflection.length; ++i) {
  stepper_approach = (i == 0 || stepper[i] >= stepper[i-1]);
  if (stepper_approach) {
    if (! last_stepper_approach) {  /* new stepper approach */
      stepper_approach_t s;
      s.piezo_approach.cyclic = true;
      calibration.push(s);
    }
    piezo_approach = (i > 0 && piezo[i] > piezo[i-1]);
    if (piezo_approach) {
      if (! last_piezo_approach) {  /* new piezo approach */
        calibration[-1].piezo_approach.push(new piezo_approach_t);
        calibration[-1].piezo_approach[-1].start = i;
      }
    } else if (last_piezo_approach) {
      calibration[-1].piezo_approach[-1].stop = i;
    }
    last_piezo_approach = piezo_approach;
  }
  last_stepper_approach = stepper_approach;
}

/* draw a few bumps around the piezo railing */
int magic_i = 6;  /* pick one that looks pretty ;) */
real gain = 20;   /* piezo volt per DAC volt */
real sens = 7.57; /* piezo sensitivity nm per piezo volt */
Label[] labels = {
  Label("a", align=E),
  Label("b", align=E),
  Label("c", align=SE),
  Label("d", align=SE),
  Label("e", align=SE),
  Label("f", align=SE),
  };
int j, k, start = -1;
for (i = magic_i; i < calibration.length; ++i) {
  for (j = 0; j < calibration[i].piezo_approach.length; ++j) {
    if (piezo[calibration[i].piezo_approach[j].stop-1] < pmax) {
      start = j - 2;
      if (start < 0) {
        start = 0;
      }
      piezo_approach_t p0 = piezoApproach(calibration, i, start);
      for (k = start; k < start + labels.length; ++k) {
         if (k < calibration[i].piezo_approach.length) {
           piezo_approach_t p = piezoApproach(calibration, i, k);
           real[] x = piezo[p.start:p.stop] - piezo[p0.start];
           x = x * gain * sens;
           real[] y = deflection[p.start:p.stop] - deflection[p0.start];
           graphData(x=x, y=y, mpath=mcross, dots=true);
           label(labels[k - start], (x[x.length-1], y[y.length-1]));
        }
      }
      break;  /* done with this stepper approach */
    }
  }
  if (start >= 0) {  /* only plot one stepper approach */
    break;  /* done with all stepper approaches */
  }
}

xlimits(0, 600);
xaxis(sLabel("Piezo position (nm)"), BottomTop, LeftTicks);
yaxis(sLabel("Deflection (V)"), LeftRight, RightTicks);
label(sLabel("Stepper step-size"), point(N), N);
