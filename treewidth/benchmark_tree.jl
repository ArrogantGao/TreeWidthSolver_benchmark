using TreeWidthSolver, BenchmarkTools
using CSV, DataFrames

CSV.write("data/treegraph_tw.csv", DataFrame(n=Int[], i=Int[], t=Float64[]))

for n in 10:2:30
    for i in 1:10
        filename = "graphs/treegraphs/n$n-$i.gr"
        g = graph_from_gr(filename)
        t = @belapsed exact_treewidth($g)
        println("n = $n, i = $i, t = $t")
        df = DataFrame(n=n, i=i, t=t)
        CSV.write("data/treegraph_tw.csv", df, append=true)
    end
end