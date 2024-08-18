using CSV, DataFrames, CairoMakie
using Statistics
using LsqFit, LaTeXStrings

df_d3 = CSV.read("data/d3graph_tw.csv", DataFrame)
df_line = CSV.read("data/line_tw.csv", DataFrame)
df_tree = CSV.read("data/treegraph_tw.csv", DataFrame)
df_grid = CSV.read("data/gridgraph_tw.csv", DataFrame)

ns = unique(df_d3.n)
time_d3 = [mean(df_d3[df_d3.n .== n, :t]) for n in ns]
time_line = [mean(df_line[df_line.n .== n, :t]) for n in ns]
time_tree = [mean(df_tree[df_tree.n .== n, :t]) for n in ns]

ns_grid = unique(df_grid.n)
time_grid = [mean(df_grid[df_grid.n .== n, :t]) for n in ns_grid]

@. model1(x, p) = p[1] + x * p[2]
p0 = [1.0, 1.0]
fit = curve_fit(model1, ns, log.(time_d3), p0)

@. model2(x, p) = p[1] + log(x) * p[2]
fit_line = curve_fit(model2, ns, log.(time_line), p0)

@. model3(x, p) = p[1] + log(x) * p[2]
fit_tree = curve_fit(model3, ns, log.(time_tree), p0)

begin
    fig = Figure(fontsize=20)
    ax = Axis(fig[1, 1], xlabel = "n", ylabel = "time (s)", yscale = log10)
    scatter!(ax, ns, time_d3, color = :blue, label = "3 regular graph")
    lines!(ax, ns, exp.(model1(ns, fit.param)), color = :blue, label = nothing, linestyle = :dash)
    text!(ax, (25, 1e-1), text = L"$T \sim O(%$(exp(fit.param[2]) ÷ 0.01 / 100)^n)$")

    scatter!(ax, ns, time_line, color = :red, label = "line graph")
    lines!(ax, ns, exp.(model2(ns, fit_line.param)), color = :red, label = nothing, linestyle = :dash)
    text!(ax, (20, 10^(-3.5)), text = L"$T \sim O(n^{%$(fit_line.param[2] ÷ 0.01 / 100)})$")

    scatter!(ax, ns, time_tree, color = :green, label = "random tree graph")
    lines!(ax, ns, exp.(model3(ns, fit_tree.param)), color = :green, label = nothing, linestyle = :dash)

    scatter!(ax, ns_grid, time_grid, color = :purple, label = "grid graph")

    axislegend(ax, position = :lt)
end
fig

save("figs/tw_time.png", fig)