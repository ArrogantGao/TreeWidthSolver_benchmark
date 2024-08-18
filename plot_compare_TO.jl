using CSV, DataFrames, CairoMakie
using Statistics
using LsqFit, LaTeXStrings

df = CSV.read("data/compare_to.csv", DataFrame)

n_line = unique!(df[df.type .== "line", :n])
n_tree = unique!(df[df.type .== "tree", :n])
n_d3 = unique!(df[df.type .== "d3", :n])
n_grid = unique!(df[df.type .== "grid", :n])

t_ome_line = [mean(df[(df.type .== "line") .& (df.n .== n), :t_ome]) for n in n_line]
t_to_line = [mean(df[(df.type .== "line") .& (df.n .== n), :t_to]) for n in n_line]

t_ome_tree = [mean(df[(df.type .== "tree") .& (df.n .== n), :t_ome]) for n in n_tree]
t_to_tree = [mean(df[(df.type .== "tree") .& (df.n .== n), :t_to]) for n in n_tree]

t_ome_d3 = [mean(df[(df.type .== "d3") .& (df.n .== n), :t_ome]) for n in n_d3]
t_to_d3 = [mean(df[(df.type .== "d3") .& (df.n .== n), :t_to]) for n in n_d3]

t_ome_grid = [mean(df[(df.type .== "grid") .& (df.n .== n), :t_ome]) for n in n_grid]
t_to_grid = [mean(df[(df.type .== "grid") .& (df.n .== n), :t_to]) for n in n_grid]

begin
    fig = Figure(size = (800, 600))
    ax1 = Axis(fig[1, 1], xlabel = "Number of Tensor", ylabel = "time (s)", yscale = log10, title = "Line Graph")
    ax2 = Axis(fig[1, 2], xlabel = "Number of Tensor", ylabel = "time (s)", yscale = log10, title = "Tree Graph")
    ax3 = Axis(fig[2, 1], xlabel = "Number of Tensor", ylabel = "time (s)", yscale = log10, title = "Random Regular 3 Graph")
    ax4 = Axis(fig[2, 2], xlabel = "Number of Tensor", ylabel = "time (s)", yscale = log10, title = "Grid Graph")
    
    scatter!(ax1, n_line, t_ome_line, color = :red, marker = :circle, label = "tree width")
    scatter!(ax1, n_line, t_to_line, color = :blue, marker = :circle, label = "exhaustive")

    scatter!(ax2, n_tree, t_ome_tree, color = :red, marker = :diamond, label = "tree (tree width)")
    scatter!(ax2, n_tree, t_to_tree, color = :blue, marker = :diamond, label = "tree (exhaustive)")

    scatter!(ax3, n_d3, t_ome_d3, color = :red, marker = :star4, label = "rr3 (tree width)")
    scatter!(ax3, n_d3, t_to_d3, color = :blue, marker = :star4, label = "rr3 (exhaustive)")

    scatter!(ax4, n_grid, t_ome_grid, color = :red, marker = :utriangle, label = "grid (tree width)")
    scatter!(ax4, n_grid, t_to_grid, color = :blue, marker = :utriangle, label = "grid (exhaustive)")

    axislegend(ax1, position = :lt)
end
fig
save("figs/compare_TO.png", fig)