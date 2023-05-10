using KomaMRI


# SCANNER #
sys = Scanner()

# RF PULSE #
# 1st block -> RF block
<<<<<<< HEAD
ampRF = 1e-5 # 2μT RF amplitude
α = π
durRF = α / (2π * γ * ampRF) # This is the required duration for a 90deg pulse with ampRF 
=======
ampRF = 2e-6; # 2μT RF amplitude
durRF = π / 2 / (2π * γ * ampRF); # This is the required duration for a 90deg pulse with ampRF 
>>>>>>> 6156674f33d7cd899699d86d1f158d263bf7dbb0
                                 # (π / 2) / (2π * γ * ampRF)
exc = RF(ampRF, durRF)

# 2nd block -> ADC block
<<<<<<< HEAD
nADC = 8190 ;
durADC = 250e-3 
delay = 1e-4
=======
nADC = 8192 ;
durADC = 250e-3 ;
delay = 1e-3 ;
>>>>>>> 6156674f33d7cd899699d86d1f158d263bf7dbb0
aqc = ADC(nADC, durADC, delay)

# concatenating the two blocks
seq  = Sequence()
seq += exc
seq += aqc
p1 = plot_seq(seq; slider = false, height = 300)

# PHANTOM #
<<<<<<< HEAD
obj = Phantom{Float64}(x = [0.1], T1 = [1000e-3], T2 = [100e-3], Δw = [50.0])
=======
obj = Phantom{Float64}(name = "spin1", x = [0.], T1 = [1000e-3], T2 = [100e-3],Δw=[-2π*100])
#p3 = plot_phantom_map(obj, :T1;  darkmode=false)
>>>>>>> 6156674f33d7cd899699d86d1f158d263bf7dbb0

# SIMULATE #
raw = simulate(obj, seq, sys)
p2 = plot_signal(raw; slider = false, height = 300)

<<<<<<< HEAD
# RECONSTRUCT #
# Get the acquisition data
acq = AcquisitionData(raw)
#acq.traj[1].circular = false #This is to remove a circular mask

# Setting up the reconstruction parameters
Nx, Ny = [100; 100] #raw.params["reconSize"][1:2]
=======
sig = simulate(obj, seq, sys, simParams=Dict{String,Any}("return_type"=>"mat"))
# Fourier Transform
signal = sig[:,:,1];
fourier = fft(signal);
fieldTesla = sys.B0;
fieldHz = (2π*γ)*fieldTesla;
freq = LinRange(-fieldHz/2, fieldHz/2, 8192);
plot(freq, abs.(fourier))

# RECONSTRUCT #
# Get the acquisition data
acq = AcquisitionData(raw);
acq.traj[1].circular = false #This is to remove a circular mask

# Setting up the reconstruction parameters
Nx, Ny = raw.params["reconSize"][1:2];
>>>>>>> 6156674f33d7cd899699d86d1f158d263bf7dbb0
reconParams = Dict{Symbol,Any}(:reco=>"direct", :reconSize=>(Nx, Ny))
image = reconstruction(acq, reconParams)

# Plotting the recon
<<<<<<< HEAD
slice_abs = abs.(image[:, :, 1])
p5 = plot_image(slice_abs; height=400)
=======
slice_abs = abs.(image[:, :, 1]);
p5 = plot_image(slice_abs; height=400)


>>>>>>> 6156674f33d7cd899699d86d1f158d263bf7dbb0
