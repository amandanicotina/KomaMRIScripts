using KomaMRI, MAT, Plots

sys = Scanner()

# Function for creating a shaped pulse
#function shaped_pulse(α, Δf)
    # Import shaped pulse
    RF_Hz = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_fields/oc_field.mat")["b1"];
    t_sp = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_fields/oc_field.mat")["t_s"];
    RF_T = RF_Hz/(2π*γ)
    
    # 1st block -> RF block
    exc = RF(RF_T, t_sp)

    # 2nd block -> ADC block
    nADC = 8192 ;
    durADC = 250e-3 ;
    delay = 1e-3 ;
    aqc = ADC(nADC, durADC, delay)

    # concatenating the two blocks
    seq  = Sequence()
    seq += exc
    seq += aqc

    # plot
    p1 = plot_seq(seq; slider = false, height = 300)
    
    #return seq
#end
# Pulse shape
t = range(-t_sp/2, t_sp/2, 1000);

simParams = Dict{String,Any}("Δt_rf"=>t[2]-t[1]);
z = range(-1, 1, 400);

plot_seq(seq; slider = false, height = 300)

# PHANTOM #
obj = Phantom{Float64}(name = "spin1", x = [0.], T1 = [274e-3], T2 = [237e-3])
#p3 = plot_phantom_map(obj, :T1;  darkmode=false)

# SIMULATE #

M = simulate_slice_profile(seq; simParams, z);
Mx = real(M.xy);
My = imag(M.xy);
Mz = M.z;

plot(Mz)
plot(Mx)
plot(My)

#raw = simulate(obj, seq, sys)
#p2 = plot_signal(raw; slider = false, height = 300)