using KomaMRI

# SCANNER #
sys = Scanner() # default hardware definition

# SEQUENCE #
# 1st block -> RF pulse
ampRF = 2e-6                        # 2 uT RF amplitude
durRF = π / 2 / (2π * γ * ampRF)    # required duration for a 90 deg RF pulse
exc = RF(ampRF,durRF)

# 2nd block -> ADCs
nADC = 8192         # number of acquisition samples
durADC = 250e-3     # duration of the acquisition
delay =  1e-3       # small delay
acq = ADC(nADC, durADC, delay)

# concatenating
seq = Sequence()  # empty sequence
seq += exc        # adding RF-only block
seq += acq        # adding ADC-only block
p1 = plot_seq(seq; slider=false, height=300)

# PHANTOM #
obj = Phantom{Float64}(x=[0.], T1=[1000e-3], T2=[100e-3])

# SIMULATE #
raw = simulate(obj, seq, sys)

p2 = plot_signal(raw; slider=false, height=300)
