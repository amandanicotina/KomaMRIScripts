using KomaMRI
using StaticArrays

""" seq = Sequence()
    seq = Sequence(GR)
    seq = Sequence(GR, RF)
    seq = Sequence(GR, RF, ADC)
    seq = Sequence(GR, RF, ADC, DUR)
    seq = Sequence(GR::Array{Grad,1})
    seq = Sequence(GR::Array{Grad,1}, RF::Array{RF,1})
    seq = Sequence(GR::Array{Grad,1}, RF::Array{RF,1}, A::ADC, DUR, DEF)

The Sequence struct.
# Arguments
- `GR`:  (`::Matrix{Grad}`) gradient matrix, rows are for (x,y,z) and columns are for time
- `RF`:  (`::Matrix{RF}`) RF matrix, the 1 row is for the coil and columns are for time
- `ADC`: (`::Vector{ADC}`) ADC vector in time
- `DUR`: (`::Vector{Float64}`, `[s]`) duration of each sequence-block, this enables
            delays after RF pulses to satisfy ring-down times
- `DEF`: (`::Dict{String, Any}`) dictionary with relevant information of the sequence.
          The possible keys are [`"AdcRasterTime"`, `"GradientRasterTime"`, `"Name"`, `"Nz"`,
          `"Num_Blocks"`, `"Nx"`, `"Ny"`, `"PulseqVersion"`, `"BlockDurationRaster"`,
          `"FileName"`, `"RadiofrequencyRasterTime"`]
# Returns
- `seq`: (`::Sequence`) Sequence struct
"""