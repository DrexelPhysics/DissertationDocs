set terminal pdf enhanced font 'Times,7' size 15cm, 10cm
set output 'means.pdf'
set view map
set contour base
unset surface
set logscale x
set cntrparam levels auto 10
set xrange [0.002:0.26383]
set yrange [0.12e-9:0.198077e-9]
splot 'means' using 1:2:3 with lines, 'means' using 1:2:4 with lines

#'fit_valley.data' with points
