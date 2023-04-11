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
    Δy = 1/p.y.N
    x_line = collect(Float64, p.x.p0:Δx:p.x.pf)
    y_line = collect(Float64, p.y.p0:Δy:p.y.pf)
    box = trues(length(x_line), length(y_line))
    T1temp = box*p.relax.T1
    T2temp = box*p.relax.T2
    uxtemp(x::p, y::p) = begin trues(length(x_line), length(y_line)) end
    phantom = Phantom(name=p.name, x=x_line, y=y_line, ux=uxtemp(p.x.pf, p.y.pf))
    return phantom
end

obj2d = square_phantom(s1_2d)

p2 = plot_phantom_map(obj2d, :T1;  darkmode=true)