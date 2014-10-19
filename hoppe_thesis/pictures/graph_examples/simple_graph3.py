import pydot 

filename = "example_simple_graph3.pdf"
render_engine= ['dot', 'circo','neato'][2]
G = pydot.graph_from_adjacency_matrix([])

'''
A = [[0,1,1],[1,1,1],[1,1,0]]
G = pydot.graph_from_adjacency_matrix([])
for i in range(len(A)):
    for j in range(len(A)):
        if i>=j and A[i][j]:
            edge = pydot.Edge(str(i),str(j))
            edge.set_weight('.5')
            G.add_edge(edge)
'''
E = [[0,24],[1,24]]
for edge in E:
    edge = pydot.Edge(str(edge[0]),str(edge[1]))
    G.add_edge(edge)

#help(pydot.Edge)
edge = pydot.Edge(str(24),str(3),label="x2",penwidth='2.0')
G.add_edge(edge)

names = map(str,range(0,5))
names = ['0','1','24','3']

for x in names: 
    node = pydot.Node(x,shape='circle')
    node.set_style('filled')
    node.set_fillcolor('white')
    
    if x in ['0', '1']: node.set_fillcolor('plum')
    if x in ['3']: node.set_fillcolor('tan')
    if x in ['24']: node.set_fillcolor('lightskyblue')
    
    node.set_label(x)
    G.add_node(node)



G.set_overlap('scale')
G.set_splines('true')
    
G.set_fontsize('1')
#G.write_svg(filename, prog=render_engine)
G.write_pdf(filename, prog=render_engine)
#G.write_png(filename, prog=render_engine)
