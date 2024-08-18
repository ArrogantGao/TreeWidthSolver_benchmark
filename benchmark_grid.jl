using TreeWidthSolver, BenchmarkTools
using Graphs
using CSV, DataFrames

CSV.write("data/gridgraph_tw.csv", DataFrame(n=Int[], t=Float64[]))

for m in 3:6, n in m:6
    for i in 1:10
        filename = "gridgraphs/m$m-n$n-i$i.gr"
        g = graph_from_gr(filename)
        # this solver does not support disconnected graphs
        !is_connected(g) && continue
        t = @belapsed exact_treewidth($g)
        @show m, n, i, nv(g), t
        df = DataFrame(n=nv(g), t=t)
        CSV.write("data/gridgraph_tw.csv", df, append=true)
    end
end