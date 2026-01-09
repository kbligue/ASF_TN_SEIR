import Pkg
Pkg.activate(@__DIR__)

using Revise
using ASF_TN_SEIR

#Set file locations
data_folder = "data"
pop_file_name = "population.csv"
W_file_name = "W.csv"
states_at_t0_file_name = "states_at_t0.csv"
output_file_name = "result.csv"
#Set simulation parameters
Tmax = 10

#Set transmission parameters
α = 0.28
β = 0.0625 
γ = 0.167

W = read_sparse_matrix(data_folder, W_file_name)
states_at_t0 = read_matrix(data_folder, states_at_t0_file_name)
population = read_vector(data_folder, pop_file_name)

States = run_simulation!(Tmax, α, β, γ, W, states_at_t0, population)
save_by_time(States, data_folder)
#save_long(States, data_folder, output_file_name)