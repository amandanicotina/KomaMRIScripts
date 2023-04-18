# PHANTOM #
include("phantom_2D.jl")
#obj = Phantom{Float64}(x = [0.1; 0.2], T1 = [1; 1]*1000e-3, T2 = [1; 1]*100e-3)
p1 = plot_phantom_map(obj, :Δw; height = 400, darkmode=false)

# EPI #
seq_file = joinpath(dirname(pathof(KomaMRI)), "../examples/3.koma_paper/comparison_accuracy/sequences/EPI/epi_100x100_TE100_FOV230.seq")
seq = read_seq(seq_file)
p3 = plot_seq(seq; range=[0 100], slider=true, height=300)

# SIMULATE #
sys = Scanner()
raw = simulate(obj, seq, sys)
p4 = plot_signal(raw; range=[98.4 103.4] , height=300)

# RECONSTRUCT #
# Get the acquisition data
acq = AcquisitionData(raw);
acq.traj[1].circular = false #This is to remove a circular mask

# Setting up the reconstruction parameters
Nx, Ny = [400 400]#raw.params["reconSize"][1:2];
reconParams = Dict{Symbol,Any}(:reco=>"direct", :reconSize=>(Nx, Ny))
image = reconstruction(acq, reconParams)

# Plotting the recon
slice_abs = abs.(image[:, :, 1]);
p5 = plot_image(slice_abs; height=400)

#p6 = plot_M0(seq)
