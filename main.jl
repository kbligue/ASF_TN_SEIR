using Revise
using ASF_TN_SEIR
using StatsBase
using DataFrames

#Set file locations
data_folder = "data"
W_file_name = "W.csv"
states_at_t0_file_name = "states_at_t0.csv"

#Set parameters
Tmax = 10

W = read_sparse_matrix(data_folder, W_file_name)
states_at_t0 = read_matrix(data_folder, states_at_t0_file_name)

D = size(W)[1]

States = Array{Int32, 3}(undef, D, 4, Tmax)
States[:, :, 1] .= states_at_t0

Destination, Source, Wij = findnz(W)

number_of_movements = length(Wij)
col_names = [:S, :E, :I, :R, :source, :dest]
Δ = DataFrame(; (col => Vector{Int32}(undef, number_of_movements) for col in col_names)...)
Δ_ct = 1

for i in 1:D # DO FOR EVERY LOCATION
    t = 1
    is_departing_from_loc_i = Source .== i
    destinations_from_loc_i = Destination[is_departing_from_loc_i]
    number_departing_from_loc_i = Wij[is_departing_from_loc_i]
    number_departing_dict = Dict(destinations_from_loc_i .=> number_departing_from_loc_i)

    X = vcat(
        fill(S, current_state_for_loc_i[S]),
        fill(E, current_state_for_loc_i[E]),
        fill(I, current_state_for_loc_i[I]),
        fill(R, current_state_for_loc_i[R])
        )

    for j in destinations_from_loc_i
        #Sample without replacement
        Δij = zeros(UInt8, 4)

        idx = sample(1:length(X), number_departing_dict[j]; replace=false)
        idx
        x = X[idx]
        deleteat!(X, sort!(idx))

        #Count SEIR symbols
        for xi in x #Add @inbounds once tested
            Δij[xi] += 1
        end
        Δ[Δ_ct, S:R] = Δij
        Δ[Δ_ct, :source] = i
        Δ[Δ_ct, :dest] = j
        Δ_ct += 1
        println("from source $i to dest $j: $Δij")
    end

end

for i in 2:2 
    state = States[i, :, t]
    for record_ct in 1:nrow(Δ)
        if Δ.source[record_ct] == i
            state .-= collect(Δ[record_ct, S:R])
            j = Δ.dest[record_ct]
            println("$record_ct: $i to $j, subtracted to state")
        elseif Δ.dest[record_ct] == i
            state .+= collect(Δ[record_ct, S:R])
            j = Δ.dest[record_ct]
            println("$record_ct: $j to $i, added to state")
        end
    end
end
    
