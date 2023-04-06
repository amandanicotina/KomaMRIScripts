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

s1 = MyPhantom("Phantom 1", -2.0, 2.0, 2, 1000*1e-3, 100*1e-3, 0.0)
s2 = MyPhantom("Phantom 2", -2.0, 2.0, 2, 1000*1e-3, 100*1e-3, 0.0) 

single_line_phantom(p::MyPhantom) = begin
    Δx = 1/p.N
    line = collect(Float64, p.x0:Δx:p.xf)    
    T1s = trues(length(line))*p.T1
    T2s = trues(length(line))*p.T2
    phantom = Phantom(name=p.name, x = line, T1 = T1s, T2 = T2s) 
    return phantom
end


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

obj = intercalate_phantom(s1, s2)
p1 = plot_phantom_map(obj, :T1; height = 400, darkmode=true)

# MERGE PHANTOMS #
#obj = Phantom{Float64}(name = s1.name*"+"*s2.name, 
 #       x  = [s1.x; s2.x], 
  #      T1 = [s1.T1; s2.T1],
   #     T2 = [s1.T2; s2.T2]
    #    )

# PLOTS #
#p1 = plot_phantom_map(obj, :T1; height = 400, darkmode=true)



