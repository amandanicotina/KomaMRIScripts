using KomaMRI, MAT, Plots

# SCANNER
sys = Scanner()

# Importing MATLAB data
RF_Hz = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_Grape/OC_fields/oc_field.mat")["b1"];
t_sp = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_Grape/OC_fields/oc_field.mat")["t_s"];
Mmax = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_Grape/OC_fields/oc_field.mat")["Mmax"];
Mmin = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_Grape/OC_fields/oc_field.mat")["Mmin"];

# SEQUENCE
# convert to Tesla
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
obj = Phantom{Float64}(name = "spin1", x = [0.], T1 = [50e-3], T2 = [25e-3]);
#p2 = plot_phantom_map(obj, :T1;  darkmode=false)

# SIMULATE #
# Raw signal
raw = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"raw"));
p2 = plot_signal(raw; slider = false, height = 300);

signal = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"state"));
Mx = real(signal.xy)[];
My = real(signal.xy)[];
Mz = real(signal.z)[];
sig = "min"

# Fidelity
if sig == "max"
    Mxmax = Mmax[2, end]
    Mymax = Mmax[3, end]
    Mzmax = Mmax[4, end]
    fidelity_Mx = round(abs(Mx - Mxmax)*100, digits = 2)
    fidelity_My = round(abs(My - Mymax)*100, digits = 2)
    fidelity_Mz = round(abs(Mz - Mzmax)*100, digits = 2)
else 
    Mxmin = Mmin[2, end]
    Mymin = Mmin[3, end]
    Mzmin = Mmin[4, end]
    fidelity_Mx = round(abs(Mx - Mxmin)*100, digits = 2)
    fidelity_My = round(abs(My - Mymin)*100, digits = 2)
    fidelity_Mz = round(abs(Mz - Mzmin)*100, digits = 2)
end

println("Fidelity: Mx = $fidelity_Mx%, My = $fidelity_My%, Mz = $fidelity_Mz%")

