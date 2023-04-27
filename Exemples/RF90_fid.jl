using KomaMRI

# SCANNER #
sys = Scanner()

# RF PULSE #
# 1st block -> RF block
ampRF = 1e-5 # 2μT RF amplitude
α = π
durRF = α / (2π * γ * ampRF) # This is the required duration for a 90deg pulse with ampRF 
                                 # (π / 2) / (2π * γ * ampRF)
exc = RF(ampRF, durRF);

# 2nd block -> ADC block
nADC = 8190 ;
durADC = 250e-3 
delay = 1e-4
aqc = ADC(nADC, durADC, delay)

# concatenating the two blocks
seq  = Sequence()
seq += exc
seq += aqc
p1 = plot_seq(seq; slider = false, height = 300)

# PHANTOM #
obj = Phantom{Float64}(x = [0.1], T1 = [1000e-3], T2 = [100e-3], Δw = [50.0])

# SIMULATE #
raw = simulate(obj, seq, sys)
p2 = plot_signal(raw; slider = false, height = 300)

# RECONSTRUCT #
# Get the acquisition data
acq = AcquisitionData(raw)
#acq.traj[1].circular = false #This is to remove a circular mask

# Setting up the reconstruction parameters
Nx, Ny = [100; 100] #raw.params["reconSize"][1:2]
reconParams = Dict{Symbol,Any}(:reco=>"direct", :reconSize=>(Nx, Ny))
image = reconstruction(acq, reconParams)

# Plotting the recon
slice_abs = abs.(image[:, :, 1])
p5 = plot_image(slice_abs; height=400)