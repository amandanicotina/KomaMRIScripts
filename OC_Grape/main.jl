using KomaMRI, MAT, Plots

include("experiment.jl")
""" 
System in KomaMRI
B0 = 63.86MHz
"""
## Scanner
sys = Scanner();

## Matlab data
oc_path = "/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_Grape/OC_fields/oc_field.mat"
RF_Hz, tf_rf, t_rf, Mmax, T1_max, T2_max, Mmin, T1_min, T2_min, freq_vals, pos_vals = 
read_data(oc_path);

## Sequence 
# convert to Tesla
RF_T = RF_Hz'/γ;

# ADCs
nADC = 1 ;
durADC = 1e-3 ;

seq = create_sequence(RF_T, tf_sp, nADC, durADC);
p1 = plot_seq(seq; slider = false, height = 300, max_rf_samples=Inf)

## Phantom 
#B0_Hz = sys.B0 / γ
obj = Phantom{Float64}(name = "spin1", x = [0.], T1 = [100e-3], T2 = [50e-3])#, Δw = [2π*51.0912])
p = plot_phantom_map(obj, :Δw; height=400)

## Simulate signal
Mx, My, Mz = simulate_signal(obj, seq, sys);

# Simulate magnetization
Mkoma, tkoma = 
simulate_magnetization_dynamics(RF_T, t_sp, sys, obj, nADC, durADC);

# Calculate fidelity
Fx, Fy, Fz = calculate_fidelity(Mx, My, Mz, Mmin[:,:,1]);
println("$Fx, $Fy, $Fz")

# Plots
t_evol = LinRange(0.0, tf_sp, Int(length(RF_T)+1));

#plot_results_max(t_evol, Mmax, tkoma, Mkoma)
p1, p2 = plot_results_min(t_evol, Mmin[:,:,1], tkoma, Mkoma);
p1
p2


# check field intensity, is it also inhom

