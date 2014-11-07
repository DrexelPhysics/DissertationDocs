load 1TIT.pdb
                                               # transparent background
set ray_opaque_background, off
util.performance(0)                            # max performance (slower)
cmd.space('cmyk')                              # printable CMYK colors
hide everything, all                           # don't show anything except...
show cartoon, all                              # ... the cartoon
cmd.spectrum("count",selection="1TIT",byres=1) # rainbow by residue count
                                               # zoom so molecule fills window
set_view (\
     1.000000000,    0.000000000,    0.000000000,\
     0.000000000,    1.000000000,    0.000000000,\
     0.000000000,    0.000000000,    1.000000000,\
     0.000000000,    0.000000000,  -80.905616760,\
     0.043053962,   -1.233590841,    4.578000069,\
    52.642337799,  109.168846130,   22.500000000 )
# view matrix (from pymol.viewing.get_view)
#   3x3 matrix rotating model space to camera space
#   1x3 origin of rotation relative to camera in camera space
#   1x3 origin of rotation relative to camera in model space
#   1x1 front plane distance from the camera
#   1x1 rear plane distance from the camera
#   1x1 orthoscopic flag (+/-) and field of view (if abs(value) > 1)
# The camera always looks down -Z with its +X left and its +Y down.
# Therefore, in the default view, model +X is to the observer\'s
# right, +Y is upward, and +Z points toward the observer.
#
# To zoom, tweak the field-of-view setting, decreasing to zoom in.
                                               # render with 640 pixel width
png 1TIT.png, width=640
quit
