function perform_infection_step!(t, States, α, β, γ, population)
    @views for i in 2:D
        println("Location $i")
        δ_SE = rand(Binomial(States[i, S, t+1], min(1, α*state_at_time_t[i, I]/population[i])))
        println("δ_SE: $δ_SE")
        δ_EI = rand(Binomial(States[i, E, t+1], γ))
        println("δ_EI: $δ_EI")
        δ_IR = rand(Binomial(States[i, I, t+1], β))
        println("δ_IR: $δ_IR")

        States[i, S, t+1] = States[i, S, t+1] - δ_SE
        States[i, E, t+1] = States[i, E, t+1] + δ_SE - δ_EI
        States[i, I, t+1] = States[i, I, t+1] + δ_EI - δ_IR
        States[i, R, t+1] = States[i, R, t+1] + δ_IR
    end
end