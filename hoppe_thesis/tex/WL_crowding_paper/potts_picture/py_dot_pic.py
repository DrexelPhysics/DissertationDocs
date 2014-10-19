import pydot
#filename = "Adjac_graph_undirected_"+str(N)+".jpg"

render_engine = 'dot'#'circo'#'dot'#'circo'#'dot'

E = [[1,12],[1,10],[1,4],[1,8],[8,5]]
E += [[6,3], [7,2]]

show_E = [0,11,9,7,3,4]

#E = [[7,0],[0,9],[0,11],[0,3],[3,12]]
#E += [[1,6],[2,5]]

E1, E2 = map(set,zip(*E))
EX = E1.union(E2)

E = [map(str,x) for x in E]
G = pydot.graph_from_edges(E)

for n in xrange(1,12+1):
    node = pydot.Node(str(n),shape='circle',fixedsize='True')
    #if n in show_E:
    G.add_node(node)

filename = "3d_example_graph.pdf"
G.write_pdf(filename, prog=render_engine) 

from os import system
system("pdfcrop %s"%filename)


