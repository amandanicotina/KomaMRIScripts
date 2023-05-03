# PACKAGES #
using KomaMRI

# SCANNER #
sys = Scanner()

# RF PULSE #
ampRF = 5e-6; # B1 = 10 μT
α = π/2;
β = π;
durRF1 = α / (2π * γ * ampRF);
durRF2 = β / (2π * γ * ampRF);


rf1 = RF(ampRF, durRF1);
rf2 = RF(ampRF, durRF2);
#delay1 = Delay(delay1)
#delay2 = Delay(delay2)
adc = ADC(200, 1.0, 1e-3);

seq = Sequence()
seq += rf1 
#seq += delay1 
#seq += rf2
#seq += delay2
seq += adc
p1 = plot_seq(seq; slider = false)

# PHANTOM #
obj = Phantom{Float64}(x = [0.], T1 = [1000e-3], T2 = [100e-3], Δw=[-2π*100])

# SIMULATE #
raw = simulate(obj, seq, sys)
p2 = plot_signal(raw; slider = false, height = 300)
p3 = plot_M0(seq)

# Define the initial magnetization values
xy_initial = [1.0 + 0.0im, 0.0 + 0.0im, 0.0 + 0.0im]
z_initial = [0.0, 0.0, 1.0]
M = Mag(xy_initial, z_initial)
spinor = Spinor(2,2)

mul!(s::Spinor, M::Mag) = begin
    M_aux = Mag(
        2*conj.(s.α).*s.β.*M.z.+conj.(s.α).^2 .* M.xy.-s.β.^2 .*conj.(M.xy), 
        (abs.(s.α).^2 .-abs.(s.β).^2).*M.z.-2*real.(s.α.*s.β.*conj.(M.xy))
     )
    M.xy .= M_aux.xy
    M.z  .= M_aux.z
end
*(s::Spinor, M::Mag) = begin
    Mag(
        2*conj.(s.α).*s.β.*M.z.+conj.(s.α).^2 .* M.xy.-s.β.^2 .*conj.(M.xy), 
        (abs.(s.α).^2 .-abs.(s.β).^2).*M.z.-2*real.(s.α.*s.β.*conj.(M.xy))
     )
end

test = mul!(spinor, M)


