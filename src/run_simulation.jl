function run_simulation(Tmax, transmission_params, W, states_at_t0, population)
    
    D = size(W)[1]

    States = Array{Int32, 3}(undef, D, 4, Tmax)
    States[:, :, 1] .= states_at_t0

    Destination, Source, Wij = findnz(W)

    number_of_movements = length(Wij)
    col_names = [:S, :E, :I, :R, :source, :dest]
    Δ = DataFrame(; (col => Vector{Int32}(undef, number_of_movements) for col in col_names)...)

    #FOR TIME t loop
    for t in 1:(Tmax-1)
        perform_migration_step!(t, States, Source, Destination, Wij, Δ, D)
        perform_infection_step!(t, States, transmission_params, population, D)
    end
    
end