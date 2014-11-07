#set terminal png
#set output 'v_dep.png'
set logscale x
set xlabel 'Pulling speed (um/s)'
set ylabel 'Unfolding force (pN)'
plot  'v_dep' using ($1*1e6):($2*1e12) with points
