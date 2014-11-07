# setup default parameters for the figures

T=300       # K,             temperature
v=1e-6      # m/s,           pulling speed
x=0.05e-9   # m,             pulling step size (set to 0 for continuous pulling)
k=0.050     # N/m,           cantilever spring constant
N=8         # #              number of protein domains in the chain
#p_f=10e-9   # m,             folded persistence length 
L_f=3.7e-9  # m,             folded contour length
p_u=0.40e-9 # m,             unfolded persistence length
L_u=28.1e-9 # m,             unfolded contour length
dx=0.225e-9 # m,             Bell distance to transition state
K0=5e-5     # transitions/s, Bell unforced unfolding rate

# histogram figure parameters
NRUN=400    # #,             For histograms, take this many runs.
df=20e-12   # N,             histogram bin width
STEM_LEAF_OPTS="-l -b$df -m$df -H10 -v-1"
