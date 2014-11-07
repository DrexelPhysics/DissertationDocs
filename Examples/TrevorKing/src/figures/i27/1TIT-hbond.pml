load 1TIT.pdb

# opaque white background with lots of fog
set ray_opaque_background, on
set transparency, 0
bg_color white
set depth_cue, 1
set ray_trace_fog, 1
set fog_start, 0
set fog, -1000

# max performance (slower)
util.performance(0)
# printable CMYK colors
cmd.space('cmyk')

# ball and stick display style
#set_bond stick_color, white, (all), (all)
#set_bond stick_radius, 0.14, (all), (all)
#set sphere_scale, 0.25, (all)

# stick-only display style
set_bond stick_radius, 0.2, (all), (all)
# but still use sphere for backbone-bound hydrogens
set sphere_scale, 0.25, (all)

# add hydrogens to protein
h_add (all)

# Setup selection groups

select backbone, name C+O+N+CA
select backbone_h, (elem H and neighbor name N)

# N-terminus
select n_term, resi 1
# C-terminus
select c_term, resi 89

# sheet A
select sheet_a, resi 3-6
# sheet A'
select sheet_ap, resi 9-15
# sheet B (last few residues)
select sheet_b, resi 24-26
# sheet G (last few residues)
select sheet_g, resi 83-87
# tip and tail
select early, resi 1-29
select late, resi 80-89

# anything in the interesting chains
select front, (sheet_a or sheet_ap or sheet_b or sheet_g)
select interesting, (front or late or early)

# Ca-sensitive residues
select ca_res, resn asp+glu
select hot, (ca_res and front)

# don't show anything except the backbone
hide everything, all
#show sticks, backbone
#show spheres, backbone

# draw hydrogen bonds
#dist hbond, front, all, mode=2
#dist hbond, all, front, mode=2
#dist hbond, all, all, mode=2
#dist hbond, front, front, mode=2
# manually match lu00
distance hbond_a, (resi 3 and name O), (resi 26 and backbone_h), mode=0
distance hbond_b, (resi 6 and backbone_h), (resi 24 and name O), mode=0
distance hbond_c, (resi 6 and name O), (resi 24 and backbone_h), mode=0
distance hbond_d, (resi 9 and name O), (resi 83 and backbone_h), mode=0
distance hbond_e, (resi 11 and backbone_h), (resi 83 and name O), mode=0
distance hbond_f, (resi 13 and backbone_h), (resi 85 and name O), mode=0
distance hbond_g, (resi 13 and name O), (resi 87 and backbone_h), mode=0
distance hbond_h, (resi 15 and backbone_h), (resi 87 and name O), mode=0
# but don't label the distances
hide labels

# decorate selections
show sticks, backbone
set_bond stick_radius, 0.05, (all), (all)
set_bond stick_radius, 0.2, (interesting), (interesting)
#show spheres, (backbone and interesting)
show spheres, (front and backbone_h)
color white, all
color lightblue, early
color lightpink, late
color brown, n_term
color cyan, c_term
color br0, sheet_a
color br2, sheet_ap
color br4, sheet_b
color br6, sheet_g
color red, (hot and resn asp)
color green, (hot and resn glu)
color yellow, hbond_a
color yellow, hbond_b
color yellow, hbond_c
color yellow, hbond_d
color yellow, hbond_e
color yellow, hbond_f
color yellow, hbond_g
color yellow, hbond_h

# zoom so molecule fills window
set_view (\
     1.000000000,    0.000000000,    0.000000000,\
     0.000000000,    0.087155743,    0.996194698,\
     0.000000000,   -0.996194698,   -0.087155743,\
     0.000000000,   -5.000000000,  -40.000000000,\
     0.043053962,    0.000000000,    4.578000069,\
    20.000000000,   60.000000000,   45.000000000 )
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
png 1TIT-hbond.png, width=640
quit
