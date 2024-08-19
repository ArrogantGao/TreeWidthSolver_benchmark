using TreeWidthSolver, Graphs
using CSV, DataFrames

df = CSV.read("data/triangulator.csv", DataFrame)
CSV.write("data/compare_tw.csv", DataFrame(file=String[], type=String[], tw_treewidthsolver=Int[], tw_triangulator=Int[]))

# get df one by one
for i in 1:size(df, 1)
    row = df[i, :]
    graph_type = row[:type]
    filename = row[:file]
    if graph_type == "grid"
        g = graph_from_gr("graphs/gridgraphs/$filename")
    elseif graph_type == "d3"
        g = graph_from_gr("graphs/d3graphs/$filename")
    end
    if is_connected(g)
        tw = Int(exact_treewidth(g))
        println("filename = $filename, $tw, $(row[:tw])")
        @assert tw ≈ row[:tw]
        dft = DataFrame(file=filename, type=graph_type, tw_treewidthsolver=tw, tw_triangulator=row[:tw])
        CSV.write("data/compare_tw.csv", dft, append=true)
    end
end