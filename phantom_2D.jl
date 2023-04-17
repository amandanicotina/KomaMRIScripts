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





# x - y values.
vec_x = collect(Float64, 0.0:1.0:10.0); 
vec_y = collect(Float64, 0.0:1.0:10.0); 
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


# Create boolean matrix for T1 and T2 values
grid_relax = falses(11,11);
for i in eachindex(grid_relax)
    if grid_relax[i] < 1 && > length(vec_x)
        grid_relax[i] = true

    end
end

relax_vals = trues(2:length(vec_x)-1, 2:length(vec_x)-1) 

# Transform it in abstract arrays
#m = SArray{Tuple{5,5}, Float64}([0.0 0.0 0.0 0.0 0.0;0.0 1.0 0.0 1.0 0.0;0.0 0.0 0.0 0.0 0.0;0.0 1.0 0.0 1.0 0.0;0.0 0.0 0.0 0.0 0.0;]);
Mrelax = SArray{Tuple{length(vec_x), length(vec_x)}, Float64}(grid_relax)
T1 = vec(Mrelax*10);
T2 = vec(Mrelax*5);

# Create a 2D phantom
obj = Phantom(name="ahh", x=x, y=y, T1=T1, T2=T2)
p2 = plot_phantom_map(obj, :T1;  darkmode=false)