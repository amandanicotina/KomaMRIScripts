using KomaMRI, MAT, Plots

# SCANNER
sys = Scanner()

# Importing MATLAB data
file = open("oc_field.mat", "r")

t_sp = matread("oc_field.mat")["t_s"];
Mmax = matread("oc_field.mat")["Mmax"];
Mmin = matread("oc_field.mat")["Mmin"];

function rf_sequence!(file, Seq::Sequence)
    # Reading MATLAB data
    RF_Hz = matread("oc_field.mat")["b1"];
    tf_sp = matread("oc_field.mat")["tf_s"];

    # SEQUENCE
    # convert to Tesla
    RF_T = RF_Hz/γ;

    # 1st block -> RF block
    exc = RF(RF_T', tf_sp);

    # 2nd block -> ADC block
    nADC = 1 ;
    durADC = 1e-4 ;
    #delay = 1e-3 ;
    aqc = ADC(nADC, durADC)

    # concatenating the two blocks
    seq  = Seq
    seq += exc
    seq += aqc

    return seq
end

seq = rf_sequence!(file, Sequence())

# plot
p1 = plot_seq(seq; slider = false, height = 300, max_rf_samples=Inf)
    
# PHANTOM #
obj = Phantom{Float64}(name = "spin1", x = [0.], T1 = [100e-3], T2 = [50e-3]);
#p2 = plot_phantom_map(obj, :T1;  darkmode=false)

pieces = 300; 

function magnetization(seq::Sequence, obj::Phantom, file, pieces::Int)
    # Empty arrays
    M_koma = zeros(Float64, 3, pieces);
    t_koma = zeros(1, pieces);

    # SEQUENCE PIECES
    #1st block -> RF block
    exc = RF(rf, t_block);
    
    # 2nd block -> ADC block
    nADC = 1 ;
    durADC = 1e-3 ;
    #delay = 1e-3 ;
    aqc = ADC(nADC, durADC)
        
     # concatenating the two blocks
    seq1  = Sequence();
    seq1 += exc;
    seq1 += aqc;

    for i in 1:pieces
        blocks = Int(length(rf_tesla)/pieces);
        rf_block = RF_T[1, 1:i*blocks] ;
        t_block = t_sp[1, i*blocks];

        # SIMULATE #
        signal1 = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"state"));
    
        # Magnetization
        M_koma[1, i] = real(signal1.xy)[];
        M_koma[2, i] = imag(signal1.xy)[];
        M_koma[3, i] = signal1.z[];
    
        # Time
        t_koma[1, i] = t_block;
        return M_koma
    end
    
    # Magnetization values
    My_koma = M_koma[2,:]';
    Mz_koma = M_koma[3,:]';
    return M_koma, My_koma, Mz_koma
end
    
    t_evol = LinRange(0.0, tf_sp, Int(length(RF_T)+1));
    
    
    plotly();
    p_mag = plot(t_evol, Mmax[4,:], line=:solid, marker=:circle, label = "OC Grape");
    plot!(t_koma', Mz_koma', seriestype=:line, marker=:circle, label = "KomaMRI");


























# SIMULATE #
# Raw signal
#raw = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"raw"));
signal1 = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"state"));
p2 = plot_signal(raw; slider = false, height = 300)


signal = simulate(obj, seq, sys; simParams=Dict{String,Any}("return_type"=>"state"));
Mx = real(signal.xy)[];
My = imag(signal.xy)[];
Mz = signal.z[];
sig = "max"

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


#################################################################
# Breaking shaped pulse into pieces

