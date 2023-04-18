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