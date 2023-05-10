using KomaMRI
using StaticArrays


# x - y  grid values #
vec_x = collect(Float64, 0.0:0.1:0.2); 
vec_y = collect(Float64, 0.0:0.1:0.2); 
grid_x, grid_y = vec_x .+ vec_y'*0, vec_x*0 .+ vec_y';

# x = [(x1); (x2); (x3); ...; (xn)]
# y = [ (y1);
    #   (y2); 
    #    ...
    #   (yn) ]


# Transform it in abstract arrays
Mx = SArray{Tuple{length(vec_x), length(vec_x)}, Float64}(grid_x);
My = SArray{Tuple{length(vec_y), length(vec_y)}, Float64}(grid_y);
x = vec(Mx);
y = vec(My);
#y = vec(transpose(Mx));


# Boolean matrix for T1 and T2 values #
# Transform it in abstract arrays
square = ones(length(vec_x), length(vec_x));
Mrelax = SArray{Tuple{length(vec_x), length(vec_x)}, Float64}(square);
T1 = vec(Mrelax*10);
T2 = vec(Mrelax*5);


# Create a 2D phantom #
obj = Phantom(name="2D Phantom", x=x, y=y, T1=T1, T2=T2)
p2 = plot_phantom_map(obj, :T1;  darkmode=false)


vec_x = collect(Float64, 0.0)
boo = vec(ones(length(vec_x)))

obj = Phantom(name="1D phantom", x=[0.0], T1=[1000e-3], T2=[100e-3])
p1 = plot_phantom_map(obj, :T1;  darkmode=false)




###### OLD STUFF ########
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





