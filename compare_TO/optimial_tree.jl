using TreeWidthSolver, Graphs, TensorOperations, OMEinsumContractionOrders
using BenchmarkTools
using CSV, DataFrames

using TensorOperations: optimaltree, TreeOptimizer, Poly

CSV.write("data/compare_to.csv", DataFrame(n=Int[], t_ome=Float64[], t_to=Float64[], type=String[]))

function graph2network(g::SimpleGraph)
    network = [Int[] for _=1:nv(g)]
    for (i, e) in enumerate(edges(g))
        u, v = src(e), dst(e)
        push!(network[u], i)
        push!(network[v], i)
    end
    return network
end


function benchmark_opt(g)
    network = graph2network(g)
    d = 2.0
    optdata = Dict([i => d for i in 1:ne(g)])
    optimizer = ExactTreewidthOptimizer()

    cost = TensorOperations.Power{:χ}(1, 1)
    optdata_ncon = Dict([i => cost for i in 1:ne(g)])
    t_to = @belapsed optimaltree($network, $optdata_ncon, $(TreeOptimizer{:ExhaustiveSearch}()), false)
    t_ome = @belapsed optimaltree($network, $optdata, $(TreeOptimizer{:ExactTreewidth}()), false)

    return t_ome, t_to
end

for n in 10:2:30
    filename = "graphs/linegraphs/n$n.gr"
    g = graph_from_gr(filename)
    t_ome, t_to = benchmark_opt(g)
    println("n = $n, t_ome = $t_ome, t_to = $t_to")
    df = DataFrame(n=n, t_ome=t_ome, t_to=t_to, type="line")
    CSV.write("data/compare_to.csv", df, append=true)
end

for n in 10:2:30
    for i in 1:10
        filename = "graphs/treegraphs/n$n-$i.gr"
        g = graph_from_gr(filename)
        t_ome, t_to = benchmark_opt(g)
        println("n = $n, i = $i, t_ome = $t_ome, t_to = $t_to")
        df = DataFrame(n=n, t_ome=t_ome, t_to=t_to, type="tree")
        CSV.write("data/compare_to.csv", df, append=true)
    end
end

for n in 10:2:20
    for i in 1:10
        filename = "graphs/d3graphs/n$n-$i.gr"
        g = graph_from_gr(filename)
        t_ome, t_to = benchmark_opt(g)
        println("n = $n, i = $i, t_ome = $t_ome, t_to = $t_to")
        df = DataFrame(n=n, t_ome=t_ome, t_to=t_to, type="d3")
        CSV.write("data/compare_to.csv", df, append=true)
    end
end

for m in 3:5, n in m:5
    for i in 1:10
        filename = "graphs/gridgraphs/m$m-n$n-i$i.gr"
        g = graph_from_gr(filename)
        # this solver does not support disconnected graphs
        !is_connected(g) && continue
        t_ome, t_to = benchmark_opt(g)
        println("m = $m, n = $n, i = $i, t_ome = $t_ome, t_to = $t_to")
        df = DataFrame(n=n, t_ome=t_ome, t_to=t_to, type="grid")
        CSV.write("data/compare_to.csv", df, append=true)
    end
end
