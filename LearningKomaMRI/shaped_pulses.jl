using KomaMRI, MAT, Plots

# SCANNER
sys = Scanner()

# SEQUENCE
# Function for creating a shaped pulse
# Import shaped pulse
RF_Hz = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_fields/oc_field.mat")["b1"];
t_sp = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_fields/oc_field.mat")["t_s"];
RF_T = RF_Hz/γ

# 1st block -> RF block
exc = RF(RF_T', t_sp);

# 2nd block -> ADC block
nADC = 1 ;
durADC = 1e-3 ;
#delay = 1e-3 ;
aqc = ADC(nADC, durADC)

# concatenating the two blocks
seq  = Sequence()
seq += exc
seq += aqc

# plot
p1 = plot_seq(seq; slider = false, height = 300, max_rf_samples=Inf)
    
# PHANTOM #
obj = Phantom{Float64}(name = "spin1", x = [0.], T1 = [100e-3], T2 = [50e-3]);
#p2 = plot_phantom_map(obj, :T1;  darkmode=false)

# SIMULATE #
# Raw signal
raw = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"raw"));
p3 = plot_signal(raw; slider = false, height = 300)
#raw_ismrmrd = signal_to_raw_data(raw, seq);
signal = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"state"));
Mt = signal.xy
Mz = signal.z


# Signal
#signal = signal[:,:,1];
#fourier = fft(signal);
#fieldTesla = sys.B0;
#fieldHz = (2π*γ)*fieldTesla; #401.2MHz
#freq = LinRange(-fieldHz/2, fieldHz/2, 1000);
#plot(imag(fourier))
# Magnetization
#M = simulate_slice_profile(seq);


#Mx = real(M.xy)
#My = imag(M.xy)
#Mz = M.z
#p5 = plot_M0(seq)
#plot(Mz)
#plot(Mx)
#plot(My)