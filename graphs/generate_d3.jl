using Graphs, TreeWidthSolver
using Random
Random.seed!(1234)

for n in 10:2:30
    for i in 1:10
        g = random_regular_graph(n, 3)
        filename = "graphs/d3graphs/n$n-$i.gr"
        save_graph(g, filename)
    end
end