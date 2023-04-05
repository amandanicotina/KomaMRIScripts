


function test(s::Int)
    x = collect(Float64, -s:s)
        if iseven(s)
            for i in eachindex(x)
                if mod(i,2)==1
                    x[i,1] = 0
                else
                    nothing
                end
            end
        else 
            throw(ArgumentError("Input must be an even number!"))    
        end
    return x
end


