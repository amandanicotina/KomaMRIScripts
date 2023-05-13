# Break RF pulse into tiny bits to track the magnetization throughout the rf pulse.
using KomaMRI
sys = Scanner()
include("shaped_pulses.jl")

pieces = 300;
M_sp = zeros(Float64, 3, pieces)
t_koma = zeros(1, pieces)
for i in 1:pieces
    blocks = Int(length(RF_T)/pieces)
    rf = RF_T[1, 1:i*blocks] 
    t_block = t_sp[1, i*blocks]

    #1st block -> RF block
    exc = RF(rf, t_block)
    
    # 2nd block -> ADC block
    nADC = 1 ;
    durADC = 1e-3 ;
    #delay = 1e-3 ;
    aqc = ADC(nADC, durADC)
    
    # concatenating the two blocks
    seq1  = Sequence()
    seq1 += exc
    seq1 += aqc
    #p1 = plot_seq(seq1; slider = false, height = 300, max_rf_samples=Inf)

    # PHANTOM #
    obj1 = Phantom{Float64}(name = "spin1", x = [0.], T1 = [50e-3], T2 = [25e-3]);

    # SIMULATE #
    signal1 = simulate(obj1, seq1, sys; simParams=Dict{String,Any}("return_type"=>"state"));

    # Magnetization
    M_sp[1, i] = real(signal1.xy)[]
    M_sp[2, i] = imag(signal1.xy)[]
    M_sp[3, i] = signal1.z[]

    # Time
    t_koma[1, i] = t_block
end

t_evol = LinRange(0.0, tf_sp, Int(length(RF_T)+1))
Mkoma = M_sp[2,:]';
using Plots
plot(t_evol, Mmin[3,:], line=:solid, marker=:circle, label = "OC Grape")
plot!(t_koma', Mkoma', seriestype=:line, marker=:circle, label = "KomaMRI")
#, seriestype=:scatter)
