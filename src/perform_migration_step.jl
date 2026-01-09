function perform_migration_step!(t, States, Source, Destination, Wij, Δ, D)
    
    Δ_ct = 1

    for i in 1:D
        is_departing_from_loc_i = Source .== i
        destinations_from_loc_i = Destination[is_departing_from_loc_i]
        number_departing_from_loc_i = Wij[is_departing_from_loc_i]
        number_departing_dict = Dict(destinations_from_loc_i .=> number_departing_from_loc_i)
        current_state_for_loc_i = States[i, :, t]

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
        end
    end

    for i in 1:D 
        state = States[i, :, t]
        for record_ct in 1:nrow(Δ)
            if Δ.source[record_ct] == i
                state .-= collect(Δ[record_ct, S:R])
            elseif Δ.dest[record_ct] == i
                state .+= collect(Δ[record_ct, S:R])
            end
        end
        States[i, :, t+1] = state
    end

    print("Updated state for time $t + 1")

end