using KomaMRI, MAT

# SCANNER #
sys = Scanner()

# SEQUENCE #
# Import shaped pulse
#RF_Hz = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_fields/oc_field.mat")["b1"];
#t_sp = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_fields/oc_field.mat")["t_s"];
#RF_T = (RF_Hz)/(2π*γ)

# just some test
#RFamp = 2e-6;
#RFdur = π / 2 / (2π * γ * RFamp)

RF_Hz = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_fields/oc_field.mat")["b1"];
t_sp = matread("/Users/amandanicotina/Documents/Julia/Projects/KomaMRIScripts/OC_fields/oc_field.mat")["t_s"];
RF_T = (RF_Hz)/(2π*γ)

# 1st block -> RF block
exc = RF(RF_T', t_sp);

# 1st block -> RF block
#exc = RF(RFamp, RFdur);

# 2nd block -> ADC block => maybe unnecessary
#nADC = 1 ;
#durADC = 0.1e-3 ;
#delay = 1e-3 ;
#aqc = ADC(nADC, durADC)

# concatenating the two blocks
seq  = Sequence()
seq += exc
#seq += aqc
# 3rd block -> Imaging sequence
seq += PulseDesigner.EPI(0.2, 10, sys)

# plot
p1 = plot_seq(seq; slider = false, height = 300, max_rf_samples=Inf)

# PHANTOM #
obj = Phantom{Float64}(name = "spin1", x = [0.], T1 = [138e-3], T2 = [118e-3])
#p3 = plot_phantom_map(obj, :T1;  darkmode=false)

# SIMULATE #
# Raw signal
mag_signal = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"state"));
raw = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"raw"));
#raw_ismrmrd = signal_to_raw_data(raw, seq);
p2 = plot_signal(raw; slider = false, height = 300);
p2

# RECONSTRUCT #
# Get the acquisition data
acq = AcquisitionData(raw)
acq.traj[1].circular = false #This is to remove a circular mask

# Setting up the reconstruction parameters
Nx, Ny = raw.params["reconSize"][1:2]
reconParams = Dict{Symbol,Any}(:reco=>"direct", :reconSize=>(Nx, Ny))
image = reconstruction(acq, reconParams)

# Plotting the recon
slice_abs = abs.(image[:, :, 1])
p5 = plot_image(slice_abs; height=400)