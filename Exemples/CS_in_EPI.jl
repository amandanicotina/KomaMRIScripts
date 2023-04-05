# BRAIN PHANTOM #
obj = brain_phantom2D()
p1 = plot_phantom_map(obj, :T2; height=400)
p2 = plot_phantom_map(obj, :Δw; height=400)


# EPI #
seq_file = joinpath(dirname(pathof(KomaMRI)), "../examples/3.koma_paper/comparison_accuracy/sequences/EPI/epi_100x100_TE100_FOV230.seq")
seq = read_seq(seq_file)
p3 = plot_seq(seq; range=[0 40], slider=true, height=300)

# SIMULATE #
raw = simulate(obj, seq, sys)
p4 = plot_signal(raw; range=[98.4 103.4] , height=300)

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