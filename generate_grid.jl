using Graphs, TreeWidthSolver, GenericTensorNetworks
using Random
Random.seed!(1234)

for m in 3:6
    for n in m:6
        for i in 1:10
            g = GenericTensorNetworks.random_square_lattice_graph(m, n, 0.8)
            filename = "gridgraphs/m$m-n$n-i$i.gr"
            save_graph(g, filename)
        end
    end
end