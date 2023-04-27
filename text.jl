
ampRF = [2e-6 3e-6] # 2μT RF amplitude
durRF = [1e-3 1.5e-3]


function rf_pulse()
    rf = [2e-6 3e-6]
    return rf
end

function rf_duration()
    del = [1e-3 1.5e-3]
    return del
end
rf = rf_pulse()
dur = rf_duration()

seq = Sequence()
exc = RF(rf, dur)

seq += exc
p1 = plot_seq(seq; slider = false, height = 300)


Sequence(RF::Array{ampRF,1})
