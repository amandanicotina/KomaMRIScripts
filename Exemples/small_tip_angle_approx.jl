using KomaMRI


# RF PULSE #
B1 = 4.92e-6
Trf = 3.2e-3
zmax = 2e-2
fmax = 5e3
z = range(-zmax, zmax, 400)
Gz = fmax / (γ * zmax)

seq = PulseDesigner.RF_sinc(B1, Trf, sys; G=[0;0;Gz], TBP=8)
p2 = plot_seq(seq; max_rf_samples=Inf, slider=false)

# SIMULATE #
simParams = Dict{String, Any}("Δt_rf" => Trf / length(seq.RF.A[1]))
M = simulate_slice_profile(seq; z, simParams)

# SIMULATE LARGE TIP ANGLE #
α_desired = 120 + 0im               # The multiplication of a complex number scales the RF pulse of a Sequence
α = KomaMRI.get_flip_angles(seq)[1] # Previous FA approx 30 deg
seq = (α_desired / α) * seq         # Scaling the pulse to have a flip angle of 120
M = simulate_slice_profile(seq; z, simParams)