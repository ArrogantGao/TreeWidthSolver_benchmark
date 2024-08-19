# analyze the log files

using CSV, DataFrames


function main()

    CSV.write("data/triangulator.csv", DataFrame(type = String[], file = String[], tw = Int[]))
    
    file = open("triangulator/triangulator.log", "r")

    graph_type = ""
    graph_name = ""

    for line in eachline(file)
        # name line is in format of "gridgraphs m3-n3-i10.gr"
        if occursin("gridgraphs", line)
            graph_type = "grid"
            graph_name = split(line, " ")[2]
        elseif occursin("d3graphs", line)
            graph_type = "d3"
            graph_name = split(line, " ")[2]
        end

        if occursin("Treewidth:", line)
            # tree width line is in format of "Treewidth: 5"
            tw = parse(Int, split(line, " ")[2])
            df = DataFrame(type = graph_type, file = graph_name, tw = tw)
            CSV.write("data/triangulator.csv", df, append=true)
        end
    end
end

main()