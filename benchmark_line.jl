using TreeWidthSolver, BenchmarkTools
using CSV, DataFrames

CSV.write("data/line_tw.csv", DataFrame(n=Int[], t=Float64[]))

for n in 10:2:30
    filename = "linegraphs/n$n.gr"
    g = graph_from_gr(filename)
    t = @belapsed exact_treewidth($g)
    println("n = $n, t = $t")
    df = DataFrame(n=n, t=t)
    CSV.write("data/line_tw.csv", df, append=true)
end