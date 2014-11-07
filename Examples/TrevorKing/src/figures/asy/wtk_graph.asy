import graph;
import palette;
import stats;


Label sLabel(string s, align align=NoAlign, int extra_spaces=0) {
  string spaces = "";
  int i;
  for (i=0; i<extra_spaces; ++i) {
    spaces += " ";
  }
  return Label(s+spaces, s+spaces, align=align);
}

void graphData(picture pic=currentpicture, real[] x, real[] y,
               real xscale=1, real yscale=1, real dx=0, real dy=0, pen p=red,
               path mpath=scale(0.8mm)*unitcircle,
               markroutine markroutine=marknodes,
               string t="Title",
               bool dots=false) {
  pen pline=p;
  marker mk = nomarker;
  if (dots == true) {
    pline = invisible;
    mk = marker(mpath, markroutine, p);
  }
  if (t != "Title") {
    draw(pic=pic, graph(pic,xscale*(x+dx),yscale*(y+dy)), p=pline,
         legend=sLabel(t,extra_spaces=1), marker=mk);
  } else {
    draw(pic=pic, graph(pic,xscale*(x+dx),yscale*(y+dy)), p=pline, marker=mk);
  }
}

void graphFile(picture pic=currentpicture, string file="datafile",
               int xcol=0, int ycol=1,
               real xscale=1, real yscale=1, real dx=0, real dy=0, pen p=red,
               path mpath=scale(0.8mm)*unitcircle,
               markroutine markroutine=marknodes,
               string t="Title",
               bool dots=false) {
  file fin = input(file).line();
  real[][] a = fin.dimension(0,0);
  a = transpose(a);
  real[] x;
  real[] y = a[ycol];
  if (xcol >= 0)
    x = a[xcol];
  else
    x = sequence(y.length);
  graphData(pic=pic, x=x, y=y, xscale=xscale, yscale=yscale, dx=dx, dy=dy, p=p,
            mpath=mpath, markroutine=markroutine, t=t, dots=dots);
}

void fitFile(picture pic=currentpicture, string file="fitparamfile",
             int pcol=0, real f(real x, real[] params),
             real xmin=realMin, real xmax=realMax,
             real xscale=1, real yscale=1, pen p=red,
             string t="Title") {
  file fin=input(file).line();
  real[][] a=fin.dimension(0,0);
  a=transpose(a);
  real[] params=a[pcol];
  real fn(real x) {
    return f(x / xscale, params) * yscale;
  }
  /* should be able to extract xmin and xmax from the figure...
  if (xmin == realMin)
    xmin = point(pic, W).x / xscale;
  if (xmax == realMax)
    xmax = point(pic, E).x / xscale;
  */
  if (t != "Title") {
    draw(pic=pic, graph(pic, fn, a=xmin*xscale, b=xmax*xscale), p=p,
         legend=sLabel(t,extra_spaces=1));
  } else {
    draw(pic=pic, graph(pic, fn, a=xmin*xscale, b=xmax*xscale), p=p);
  }
}

void histFile(picture pic=currentpicture, string file="datafile",
              int bin_col=0, int count_col=1,
              real bin_scale=1, real count_scale=1, real low=-infinity,
              pen fillpen=red, pen drawpen=nullpen, bool bars=false,
              string t="Title") {
  file fin = input(file).line();
  real[][] a = fin.dimension(0,0);
  a = transpose(a);
  real[] bins = a[bin_col] * bin_scale;
  real[] count = a[count_col] * count_scale;
  /* Convert bin-center marks to bin-edge marks */
  real bin_width = bins[1]-bins[0];
  bins = bins - bin_width / 2;               /* shift centers to the left */
  bins.push(bins[bins.length-1]+bin_width);  /* add terminal edge on right */
  /* Normalize counts -> frequency */
  real total = sum(count);
  count = count / total;
  if (t != "Title") {
    histogram(pic=pic, bins=bins, count=count, low=low,
              fillpen=fillpen, drawpen=drawpen, bars=bars,
              legend=sLabel(t,extra_spaces=1));
  } else {
    histogram(pic=pic, bins=bins, count=count, low=low,
              fillpen=fillpen, drawpen=drawpen, bars=bars);
  }
}

real[] identity_zfn(real[] z) {
  return z;
}

/* Return a sorted list of unique entries in an array x */
real[] set(real[] x) {
  int i=1;
  x = sort(x);
  while (i < x.length){
    if (x[i] == x[i-1])
      x.delete(i);
    else
      i += 1;
  }
  return x;
}

/* Convert x,y,z arrays to a z matrix */
real[][] extract_matrix(real[] xs, real[] ys, real[] zs) {
  int i, j, k;
  real[] x_set = set(xs);
  real[] y_set = set(ys);
  real[] z_col = array(y_set.length, 0);
  real[][] z_matrix = array(n=x_set.length, z_col);
  //assert zs.length == x_set.length*y_set.length;
  for (i=0; i<x_set.length; ++i) {
    for (j=0; j<y_set.length; ++j) {
      for (k=0; k<x_set.length*y_set.length; ++k) {
        if (xs[k] == x_set[i] && ys[k] == y_set[j]) {
          z_matrix[i][j] = zs[k];
          break;
        }
      }
    }
  }
  return z_matrix;
}

pair ScaleInv(picture pic=currentpicture, pair z)
{
  return (pic.scale.x.Tinv(z.x),pic.scale.y.Tinv(z.y));
}

void graphMatrixFile(picture pic=currentpicture, string file="datafile",
                     int xcol=0, int ycol=1, int zcol=2,
                     real xscale=1, real yscale=1,
                     real[] zfn(real[] z)=identity_zfn,
                     pen[] p=BWRainbow(8192), Label x_label=null,
                     Label y_label=null, Label palette_label=null,
                     real palette_offset=6pt, real palette_width=12pt) {
  file fin = input(file).line();
  real[][] a = fin.dimension(0,0);
  /* drop blank lines used to separate Gnuplot blocks. */
  for (int i=a.length-1; i >= 0; --i)
    if (a[i].length < 3)
      a.delete(i);
  a = transpose(a);
  real[] xs = a[xcol];
  real[] ys = a[ycol];
  real[] zs = zfn(a[zcol]);
  real[][] z = extract_matrix(xs, ys, zs);
  pair initial = (xscale*min(xs), yscale*min(ys));
  pair final = (xscale*max(xs), yscale*max(ys));
  //bounds range = image(pic=pic, x=xscale*x, y=yscale*y, f=z, palette=p);
  bounds range = image(pic=pic, z, initial, final, range=Automatic, palette=p);
  // Add axes before palette or palette will end up in same box as the image
  if (x_label != null)
    xaxis(pic, x_label, BottomTop,LeftTicks,above=true);
  if (y_label != null)
    yaxis(pic, y_label, LeftRight,RightTicks,above=true);
  transform pic_to_frame = pic.calculateTransform();
  transform frame_to_pic = inverse(pic_to_frame);
  pair lower_right_graph = (final.x, initial.y);
  pair lower_right_pic = Scale(lower_right_graph);
  pair lower_right_frame = pic_to_frame * lower_right_pic;
  pair p_initial_frame = lower_right_frame + palette_offset * E;
  pair p_initial_pic = frame_to_pic * p_initial_frame;
  pair p_initial_graph = ScaleInv(p_initial_pic);
  pair upper_right_graph = final;
  pair upper_right_pic = Scale(upper_right_graph);
  pair upper_right_frame = pic_to_frame * upper_right_pic;
  pair p_final_frame = upper_right_frame + (palette_offset+palette_width) * E;
  pair p_final_pic = frame_to_pic * p_final_frame;
  pair p_final_graph = ScaleInv(p_final_pic);
  if (palette_label == null)
    palette(pic, bounds=range, initial=p_initial_graph, final=p_final_graph,
            axis=Right, palette=p);
  else
    palette(pic, L=palette_label, bounds=range, initial=p_initial_graph,
            final=p_final_graph, axis=Right, palette=p);
}

string math(string contents) {
  return "$" + contents + "$";
}

string Exp(string value) {
  return "\cdot 10^{" + value + "}";
}

string units(string value, string units) {
  return value+"\mbox{ "+units+"}";
}

pen phard=blue;
pen pmed=green;
pen psoft=red;

path m1=(0,0)--(1,0)--(.5,1)--cycle;
m1 = scale(3mm)*shift(-.5,-.33)*m1;
path m8=scale(2mm)*shift(-.5,-.5)*unitsquare;
path m30=scale(1.5mm)*unitcircle;
path mdot=scale(0.2pt)*unitcircle;
path mcross = (0.5,0)--(0.5,1)--(.5,.5)--(0,0.5)--(1,0.5);
mcross = scale(2mm)*shift(-0.5, -0.5)*mcross;

markroutine marksize(string file="datafile", pen p=red, path mpath=scale(0.8mm)*unitcircle, real size=1) {
  return new void(picture pic=currentpicture, frame f, path g) {
    /* frame f is the marker we setup in graphFile().  We can't scale
       that directly though, since the drawn line thickness would change.
       Instead, we give marksize() the same p and mpath that graphFile()
       got, so it can scale the path and stroke it with the unscaled pen.
     */
    file fin=input(file).line();
    real[][] a=fin.dimension(0,0);
    a=transpose(a);
    real[] s=a[3];
    for (int i=0; i <= length(g); ++i) {
      pair z = point(g, i);
      frame f;
      draw(f, scale(sqrt(s[i]/size))*mpath, p);
      add(pic, f, z);
    }
  };
}
