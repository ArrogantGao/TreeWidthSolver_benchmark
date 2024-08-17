using Graphs, TreeWidthSolver
using Random
Random.seed!(1234)

function random_tree(n::Int)
    g = SimpleGraph(n)
    for i in 2:n
        add_edge!(g, i, rand(1:i-1))
    end
    return g
end

for n in 10:2:30
    for i in 1:10
        # generate a random binary tree
        g = random_tree(n)
        filename = "treegraphs/n$n-$i.gr"
        save_graph(g, filename)
    end
end