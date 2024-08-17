using Graphs, TreeWidthSolver
using Random
Random.seed!(1234)

for n in 10:2:30
    g = graph_from_tuples(n, [(i, i + 1) for i in 1:n-1])
    filename = "linegraphs/n$n.gr"
    save_graph(g, filename)
end