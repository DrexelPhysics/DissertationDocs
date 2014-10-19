import pydot 

filename = "example_simple_graph2.pdf"
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
E = [[0,2],[1,2],[2,3],[3,4]]
for edge in E:
    edge = pydot.Edge(str(edge[0]),str(edge[1]))
    edge.set_weight('.5')
    G.add_edge(edge)

names = map(str,range(0,5))

for x in names: 
    node = pydot.Node(x,shape='circle')
    node.set_style('filled')
    node.set_fillcolor('white')
    
    if x in ['0', '1']: node.set_fillcolor('plum')
    if x in ['3']: node.set_fillcolor('tan')
    if x in ['4']: node.set_fillcolor('lightskyblue')
    if x in ['2']: node.set_fillcolor('darkorange')
    
    node.set_label(x)
    G.add_node(node)



G.set_overlap('scale')
G.set_splines('true')
    
G.set_fontsize('1')
G.write_pdf(filename, prog=render_engine)

