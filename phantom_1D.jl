using KomaMRI
""" 
panthom = phantom_1D(...)

a line

# Arguments(x,y,z,t1,...)

# Returns 

"""

""" 
panthom = phantom_1D(...)

a line

# Arguments(x,y,z,t1,...)

# Returns 

"""
struct MyPhantom
    name::String
    x0::Float64
    xf::Float64
    N::Int
    T1::Float64
    T2::Float64
    Δw::Float64
end

s1 = MyPhantom("Phantom 1", 0.0, 1.0, 1, 1000*1e-3, 100*1e-3, 10000.0)
s2 = MyPhantom("Phantom 2", -1.0, 1.0, 2, 500*1e-3, 50*1e-3, 0.0) 

single_line_phantom(p::MyPhantom) = begin
    Δx = 1/p.N
    line = collect(Float64, p.x0:Δx:p.xf)    
    T1s = trues(length(line))*p.T1
    T2s = trues(length(line))*p.T2
    dw = p.Δw/p.N
    Δws = 2π*collect(Float64,0:Δx:p.Δw)
    phantom = Phantom(name=p.name, x = line, T1 = T1s, T2 = T2s, Δw = Δws) 
    return phantom
end

two_line_phantom(p1::MyPhantom, p2::MyPhantom)  = begin
    Δx = 1/p1.N
    line1 = collect(Float64, 0.0:0.5:10.0) 
    line2 = collect(Float64, 0.5:0.5:10.5) 
    #line1 = collect(Float64, [0.0, 1.0, 2.0]) 
    #line2 = collect(Float64, [0.5, 1.5, 2.5]) 
    half = Int(round(length(line1)*0.5))
    arr1 = trues(length(line1))   
    arr2 = trues(length(line2)) 
    T1s1 = arr1*p1.T1
    T1s2 = arr1*p2.T2
    T2s1 = arr2*p1.T2
    T2s2 = arr2*p2.T2

    phantom = Phantom(name=p1.name*"+"*p2.name, 
                x  = [line1; line2], 
                T1 = [T1s1; T1s2], 
                T2 = [T2s1; T2s2])
    return phantom
end

obj = single_line_phantom(s1)
p2 = plot_phantom_map(obj, :Δw; height = 400, darkmode=false)
#p3 = plot_phantom_map(obj, :Δw; height = 400, darkmode=false)











intercalate_phantom(p1::MyPhantom, p2::MyPhantom)  = begin
    Δx = 1/p1.N
    line = collect(Float64, p1.x0:Δx:p1.xf) 
    arr1 = trues(length(line))
    arr1[1:2:end].=false
    arr2 = trues(length(line))
    arr2[2:2:end].=false
    T1s1 = arr1*p1.T1
    T1s2 = arr1*p2.T2
    T2s1 = arr2*p1.T2
    T2s2 = arr2*p2.T2

    phantom = Phantom(name=p1.name*"+"*p2.name, 
                x  = [line; line], 
                T1 = [T1s1; T1s2], 
                T2 = [T2s1; T2s2])
    return phantom
end





