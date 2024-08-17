using CSV, DataFrames, CairoMakie
using Statistics

df_d3 = CSV.read("data/d3graph_tw.csv", DataFrame)
df_line = CSV.read("data/line_tw.csv", DataFrame)
df_tree = CSV.read("data/treegraph_tw.csv", DataFrame)

ns = unique(df_d3.n)
time_d3 = [mean(df_d3[df_d3.n .== n, :t]) for n in ns]
time_line = [mean(df_line[df_line.n .== n, :t]) for n in ns]
time_tree = [mean(df_tree[df_tree.n .== n, :t]) for n in ns]

fig = Figure(resolution = (800, 600), fontsize=20)
ax = Axis(fig[1, 1], xlabel = "n", ylabel = "time (s)", yscale = log10)
lines!(ax, ns, time, color = :blue)
scatter!(ax, ns, time, color = :blue, label = "3 regular graph")

lines!(ax, ns, time_line, color = :red)
scatter!(ax, ns, time_line, color = :red, label = "line graph")

lines!(ax, ns, time_tree, color = :green)
scatter!(ax, ns, time_tree, color = :green, label = "random tree graph")

axislegend(ax, position = :lt)
fig

save("figs/tw_time.png", fig)