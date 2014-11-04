from __future__ import division
from pylab_params import *
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
from enthought.mayavi import mlab

def set_camera():
    F = mlab.gcf()
    F.scene.camera.position = [-4.5084283567916916, 5.0826441241530347, 2.5157264953414766]
    F.scene.camera.focal_point = [0.0, 0.0, 0.50000002980232239]
    F.scene.camera.view_angle = 30.0
    F.scene.camera.view_up = [0.20751975331326181, -0.19601355433774734, 0.9583914849896602]
    F.scene.camera.clipping_range = [3.2568212087935651, 11.823288751122519]
    F.scene.camera.compute_view_plane_normal()
    F.scene.render()

hydro = [1,3,5,8]
turns = map(array, [[1,0,0], [0,1,0], [-1,0,0], [0,-1,0],[0,0,1], [0,0,-1]])
#tseq = [1,0,3,4,1,2,3,3,5,5,1,0]
tseq = [0, 1, 2, 4, 0, 3, 2, 2, 5, 3, 0]

R = [array([0,0,0])]
for t in tseq:
    R.append( R[-1] + turns[t] )

X, Y, Z, C,labels = [], [], [], [], []
for n,r in enumerate(R):
    X.append(r[0])
    Y.append(r[1])
    Z.append(r[2])
    labels.append(str(n+1))
    if n in hydro: C.append('r')
    else: C.append('g')


fig = mlab.figure(1, bgcolor=(1, 1, 1), size=(500, 500))

fig_res = 100

S = [1 for n in xrange(len(X))]

mlab.points3d(X, Y, Z, resolution=fig_res)


for x,y,z,l in zip(X,Y,Z,labels):
    if int(l)<8:
        d = .17
        mlab.text3d(x-d,y+d*1.25,z,l,line_width=3.5, scale=.15,color=(0,0,0), opacity=.9)

    elif int(l) in [9,8]:
        mlab.text3d(x-d/2,y+d*1.3,z,l,line_width=3.5, scale=.15,color=(0,0,0), opacity=.9)

    else:
        mlab.text3d(x-d/2,y+d*1.5,z,l,line_width=3.5, scale=.15,color=(0,0,0), opacity=.9)

def connection_plot(r1,r2):
    segments = 10
    dr = (r2 - r1)/segments

    '''
    for n in xrange(segments):
        if not n%3:
            x1,y1,z1 = [k[0] for k in zip(r1+n*dr)]
            x2,y2,z2 = [k[0] for k in zip(r1+(n+1)*dr)]

            mlab.plot3d( [x1,x2], [y1,y2], [z1,z2],color=(0,0,.5),tube_radius=.005 )
    '''
    
    X,Y,Z = zip(*[r1 + n*dr for n in xrange(segments)])
    C = xrange(len(X))
    mlab.plot3d( X,Y,Z, C, tube_radius=.02, tube_sides=fig_res, opacity=.6, colormap="Blues" )


#mlab.plot3d(X,Y,Z, S, tube_sides=fig_res, color=(.8,0,0), colormap='Reds', opacity=.8)

dim = 1.5
def f(x, y): return x*0
x, y = np.mgrid[-dim:dim:0.1, -dim:dim:0.1]
s = mlab.surf(x, y, f, opacity=.2)



connection_plot( R[1], R[6] )
connection_plot( R[0], R[3] )
connection_plot( R[0], R[7] )
connection_plot( R[0], R[9] )
connection_plot( R[0], R[11] )
connection_plot( R[7], R[4] )
connection_plot( R[2], R[5] )



'''
connection_plot( R[0], R[3] )
connection_plot( R[0], R[7] )
connection_plot( R[0], R[9] )
connection_plot( R[0], R[11] )
connection_plot( R[1], R[6] )
connection_plot( R[2], R[5] )
connection_plot( R[3], R[12] )
'''

set_camera()
#F = mlab.gcf()
#scene.scene.anti_aliasing_frames = 20
#scene.jpeg_quality = 100


mlab.show()


exit()


ax.set_xlim3d(-3,3)
ax.set_ylim3d(-3,3)
ax.set_zlim3d(-3,3)

#print help(ax.get_xaxis())
#exit()
#ax.get_xaxis().set_visible(False)


#print ax.get_ygridlines()
#print ax.get_xgridlines()
#print [x for x in dir(ax) if "get" in x and "x" in x]
#exit()




show()

'''
hydro = [1,3,5,8]
turns = map(array, [[1,0], [0,1], [-1,0], [0,-1]])
tseq = [1,1,0,0,3,3,2,1]

R = [array([0,0])]
for t in tseq:
    R.append( R[-1] + turns[t] )

print R

X, Y, C = [], [], []
for n,r in enumerate(R):
    X.append(r[0])
    Y.append(r[1])
    if n in hydro: C.append('r')
    else: C.append('g')
    
scatter(X,Y,color=C,s=200,zorder=10)
plot(X,Y,'k')

def connection_plot(r1,r2):
    print [[r1[0],r2[0]], r1[1], r2[1]]
    plot( [r1[0],r2[0]], [r1[1], r2[1]], 'k--' )

connection_plot( R[1], R[8] )
connection_plot( R[3], R[8] )
connection_plot( R[5], R[8] )

axis('equal')

show()
'''
