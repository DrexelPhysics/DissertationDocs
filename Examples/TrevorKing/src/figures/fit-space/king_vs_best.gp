set terminal pdf enhanced font 'Times,7' size 9cm, 6cm
set output 'king_vs_best.pdf'
g(x) = 39.727*exp(-40.7215e9*x)                                                          
f(x) = 25.4465*exp(-44.6235e9*x) 
set logscale y
set xlabel 'x_u (m)'
set ylabel 'k_u0 (1/s)'
plot 'fit_valley.data' t 'King', f(x), 'Best_2002_detailed_unfolding_pathway/fig3a.data' t 'Best', g(x)             
