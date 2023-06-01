

include("shaped_pulses.jl")

oc_path = "/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_Grape/OC_fields/oc_field.mat"

RF_Hz, tf_sp, t_sp, Mmax, Mmin = read_data(oc_path)

# convert to Tesla
RF_T = RF_Hz/γ;

# 1st block -> RF block
exc = RF(RF_T', tf_sp);

# 2nd block -> ADC block
nADC = 1 ;
durADC = 1e-3 ;


seq =  create_sequence(RF_T, tf_sp, nADC, durADC)

obj = Phantom{Float64}(name = "spin1", x = [0.], T1 = [274e-3], T2 = [237e-3], Δw = [2π*7450]);
sys = Scanner()

Mx, My, Mz = simulate_signal(obj, seq, sys)

Mykoma, Mzkoma, tkoma = simulate_magnetization_dynamics(RF_T, t_sp, sys, obj, nADC, durADC)





Fx, Fy, Fz = calculate_fidelity(Mx, My, Mz, Mmax)