#!/bin/bash
python find_states.py
python find_adj.py
python calc_matrix.py .20 .5 glauber
#python calc_matrix.py .15 .5 metro
python grid_traj.py .95
python kinetics.py
python draw_clusters.py
