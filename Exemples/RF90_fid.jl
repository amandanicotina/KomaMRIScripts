using KomaMRI

# SCANNER #
sys = Scanner()

# RF PULSE #
# 1st block -> RF block
ampRF = 2e-6; # 2μT RF amplitude
durRF = π / 2 / (2π * γ * ampRF); # This is the required duration for a 90deg pulse with ampRF 
                                 # (π / 2) / (2π * γ * ampRF)
exc = RF(ampRF, durRF)

# 2nd block -> ADC block
nADC = 8192 ;
durADC = 250e-3 ;
delay = 1e-3 ;
aqc = ADC(nADC, durADC, delay)

# concatenating the two blocks
seq  = Sequence()
seq += exc
seq += aqc
p1 = plot_seq(seq; slider = false, height = 300)

# PHANTOM #
obj = Phantom{Float64}(x = [0.], T1 = [1000e-3], T2 = [100e-3],Δw=[-2π*100])
p3 = plot_phantom_map(obj, :T1;  darkmode=false)

# SIMULATE #
raw = simulate(obj, seq, sys)
p2 = plot_signal(raw; slider = false, height = 300)


#new

# RECONSTRUCT #
# Get the acquisition data
acq = AcquisitionData(raw);
acq.traj[1].circular = false #This is to remove a circular mask

# Setting up the reconstruction parameters
Nx, Ny = raw.params["reconSize"][1:2];
reconParams = Dict{Symbol,Any}(:reco=>"direct", :reconSize=>(Nx, Ny))
image = reconstruction(acq, reconParams)

# Plotting the recon
slice_abs = abs.(image[:, :, 1]);
p5 = plot_image(slice_abs; height=400)