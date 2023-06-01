using KomaMRI, MAT, Plots

## Read MATLAB data
function read_data(file_path)
    # MATLAB data
    mat_data = matread(file_path)
    RF_Hz = mat_data["b1"]
    tf_sp = mat_data["tf_s"]
    t_sp = mat_data["t_s"]
    Mmax = mat_data["Mmax"]
    Mmin = mat_data["Mmin"]

    return RF_Hz, tf_sp, t_sp, Mmax, Mmin
end

## Create Sequence
function create_sequence(RF_T, tf_sp, nADC, durADC)
    # RF block
    exc = RF(RF_T', tf_sp)
    
    # ADC block
    aqc = ADC(nADC, durADC)
    
    # Concatenating
    seq = Sequence()
    seq += exc
    seq += aqc
    
    return seq
end

## Simulate signal
function simulate_signal(obj, seq, sys)
    signal = simulate(obj, seq, sys; simParams=Dict("return_type" => "state"))
    Mx = real(signal.xy)[:]
    My = imag(signal.xy)[:]
    Mz = signal.z[:]

    return Mx, My, Mz
end

## Calculate fidelity
function calculate_fidelity(Mx, My, Mz, Mref)
    fidelity_Mx = round(abs(Mx[] - Mref[2, end])*100, digits=2)
    fidelity_My = round(abs(My[] - Mref[3, end])*100, digits=2)
    fidelity_Mz = round(abs(Mz[] - Mref[4, end])*100, digits=2)

    return fidelity_Mx, fidelity_My, fidelity_Mz
end


## Simulate magnetization dynamics
function simulate_magnetization_dynamics(RF_T, t_sp, sys, obj1, nADC, durADC)
    pieces = length(RF_T)
    M_koma = zeros(Float64, 3, pieces)
    t_koma = zeros(Float64, 1, pieces)
    
    for i in 1:pieces
        blocks = Int(length(RF_T) / pieces)
        rf_block = RF_T[1, 1:i*blocks]'
        t_block = t_sp[1, i*blocks]

        seq1 = create_sequence(rf_block, t_block, nADC, durADC)

        Mx, My, Mz = simulate_signal(obj1, seq1, sys)

        M_koma[1, i] = Mx[]
        M_koma[2, i] = My[]
        M_koma[3, i] = Mz[]
        t_koma[1, i] = t_block
    end
    
    return M_koma[2, :], M_koma[3, :], t_koma'
end

## Plots
function plot_results(t_evol, Mmax, t_koma, Mz_koma)
    plotly()
    plot(t_evol, Mmin[3, :], line=:solid, marker=:circle, label="OC Grape")
    plot!(t_koma, Mz_koma, seriestype=:line, marker=:circle, label="KomaMRI")
end
