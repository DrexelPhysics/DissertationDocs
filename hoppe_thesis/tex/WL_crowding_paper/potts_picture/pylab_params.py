
from pylab import *

fig_width_pt = 4*246.0  # Get this from LaTeX using \showthe\columnwidth
inches_per_pt = 1.0/72.27               # Convert pt to inch
golden_mean = (sqrt(5)-1.0)/2.0         # Aesthetic ratio
fig_width = fig_width_pt*inches_per_pt  # width in inches
fig_height = fig_width*golden_mean      # height in inches
fig_size =  [fig_width,fig_height]

fs = 14
lfs = 12
params = {'backend': 'ps','axes.labelsize': fs,'text.fontsize': fs,'legend.fontsize': fs,'xtick.labelsize': lfs,'ytick.labelsize': lfs,'text.usetex': True,'figure.figsize': fig_size}
rcParams.update(params)
