using KomaMRI

# CREATE SPACE ARRAYS #
#arr1 = collect(-10.0:2.0:10.0)
#arr2 = collect(-9.0:2.0:11.0)

#intercalated_arr1 = reduce((x, y) -> [x..., 0, y], arr1)
#intercalated_arr2 = reduce((x, y) -> [x..., 0, y], arr2)

# CONSTRUCT INDIVIDUAL PHANTOMS #
s1 = Phantom(name="P1", x = collect(-4.0:2.0:4.0), T1 = ones(length(x))*1000e-3, T2 = ones(length(x))*100e-3)
s2 = Phantom(name="P2", x = collect(-4.0:2.0:4.0), T1 = ones(length(x))*500e-3, T2 = ones(length(x))*50e-3)

# MERGE PHANTOMS #
obj = Phantom{Float64}(name = s1.name*"+"*s2.name, 
        x  = [s1.x; s2.x], 
        T1 = [s1.T1; s2.T1],
        T2 = [s1.T2; s2.T2]
        )

# PLOTS #
p1 = plot_phantom_map(obj, :T1; height = 400, darkmode=true)



