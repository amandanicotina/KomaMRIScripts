using KomaMRI

mutable struct Position
    p0::Float64
    pf::Float64
    N::Int
end

mutable struct Relaxation
    T1::Float64
    T2::Float64
end

struct MyPhantom2D
    name::String
    x::Position
    y::Position
    relax::Relaxation
    Δw::Float64
end

s1_2d = MyPhantom2D("My phantom 2d", 
        Position(0.0, 2.0, 2), 
        Position(0.0, 2.0, 2), 
        Relaxation(1000*1e-3, 100*1e-3), 0.0)

square_phantom(p::MyPhantom2D) = begin
    Δx = 1/p.x.N
    line = collect(Float64, p.x.p0:Δx:p.x.pf)
    box = trues(length(line), length(line))
    T1temp = ones(length(line))*p.relax.T1
    T2temp = ones(length(line))*p.relax.T2
    phantom = Phantom(name=p.name, x = line, y = line, T1 = T1temp, T2 = T2temp)
    return phantom
end

obj2d = square_phantom(s1_2d)

p2 = plot_phantom_map(obj2d, :T1; height = 400, darkmode=true)