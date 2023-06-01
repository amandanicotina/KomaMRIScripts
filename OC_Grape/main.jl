
include("shaped_pulses.jl")

## Matlab data
oc_path = "/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_Grape/OC_fields/oc_field.mat"
RF_Hz, tf_sp, t_sp, Mmax, Mmin = read_data(oc_path);

## Sequence 
# convert to Tesla
RF_T = RF_Hz/γ;

# 1st block -> RF block
exc = RF(RF_T', tf_sp);

# 2nd block -> ADC block
nADC = 1 ;
durADC = 1e-3 ;

seq = create_sequence(RF_T, tf_sp, nADC, durADC);
p1 = plot_seq(seq; slider = false, height = 300, max_rf_samples=Inf)

## Phantom and Scanner
obj = Phantom{Float64}(name = "spin1", x = [0.], T1 = [100e-3], T2 = [50e-3]);
sys = Scanner();

## Simulate signal
Mx, My, Mz = simulate_signal(obj, seq, sys);

# Simulate magnetization
Mykoma, Mzkoma, tkoma = 
simulate_magnetization_dynamics(RF_T, t_sp, sys, obj, nADC, durADC);

# Calculate fidelity
Fx, Fy, Fz = calculate_fidelity(Mx, My, Mz, Mmin)

# Plots
t_evol = LinRange(0.0, tf_sp, Int(length(RF_T)+1));
plot_results(t_evol, Mmax, tkoma, Mzkoma)