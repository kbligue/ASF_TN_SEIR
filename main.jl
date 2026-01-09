using Revise
using ASF_TN_SEIR
using DataFrames
# WRITE CODE TO LOAD PROJECT?

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
t = 1
perform_migration_step!(t, States, Source, Destination, Wij, Δ, D)




    
