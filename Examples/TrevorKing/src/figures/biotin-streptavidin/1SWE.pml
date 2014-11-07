load 1SWE.pdb
                                               # transparent background
set ray_opaque_background, off
util.performance(0)                            # max performance (slower)
cmd.space('cmyk')                              # printable CMYK colors
hide everything, all                           # don't show anything except...
show cartoon, all                              # ... the cartoon streptavidin
show sticks, hetatm                            # ... and stick biotins
color red, hetatm                              # make the biotin red
                                               # zoom so molecule fills window
set_view (\
     0.020578306,    0.172470704,    0.984799862,\
     0.637113333,    0.756843209,   -0.145860136,\
    -0.770495117,    0.630429447,   -0.094308868,\
     0.000000000,    0.000000000, -113.425636292,\
    13.857005119,  -12.095066071,    9.181341171,\
    89.425636292,  137.425643921,   20.000000000 )
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
png 1SWE.png, width=640
quit
