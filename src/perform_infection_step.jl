function perform_infection_step!(t, States, α, β, γ, population, D)
    for i in 2:D
        S_i = States[i, S, t+1]
        E_i = States[i, E, t+1]
        I_i = States[i, I, t+1]
        R_i = States[i, R, t+1]

        δ_SE = rand(Binomial(S_i, 
                            min(1, α*I_i/population[i])))
        δ_EI = rand(Binomial(E_i, γ))
        δ_IR = rand(Binomial(I_i, β))

        States[i, S, t+1] = S_i - δ_SE
        States[i, E, t+1] = E_i + δ_SE - δ_EI
        States[i, I, t+1] = I_i + δ_EI - δ_IR
        States[i, R, t+1] = R_i + δ_IR
    end
end
