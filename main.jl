using Revise
using ASF_TN_SEIR
# WRITE CODE TO LOAD PROJECT?

#Set file locations
data_folder = "data"
pop_file_name = "population.csv"
W_file_name = "W.csv"
states_at_t0_file_name = "states_at_t0.csv"

#Set simulation parameters
Tmax = 10

#Set transmission parameters
transmission_params = Dict(
    "α" => 0.28, 
    "β" => 0.0625, 
    "γ" => 0.167
    )
α = 0.28
β = 0.0625
γ = 0.167 

W = read_sparse_matrix(data_folder, W_file_name)
states_at_t0 = read_matrix(data_folder, states_at_t0_file_name)
population = read_vector(data_folder, pop_file_name)

run_simulation(Tmax, transmission_params, W, states_at_t0, population)