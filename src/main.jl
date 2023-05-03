using KomaMRI
using StaticArrays

# PHANTOM #
include("phantom_2D.jl")
p1 = plot_phantom_map(obj, :Δw; height = 400, darkmode=false)

# SEQUENCE #



# SIMULATE #
sys = Scanner()
raw = simulate(obj, seq, sys)
p4 = plot_signal(raw; range=[98.4 103.4] , height=300)

# RECONSTRUCT #