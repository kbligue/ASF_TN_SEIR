using CSV, Tables

# SET VALUES
D = 5 #Number of locations
output_folder = "data"

w_ij_not_zero = Dict(
    (1,2) => 5, #Connection from outside world
    (2,4) => 7,
    (3,4) => 2,
    (4,5) => 9
)

W = zeros(D, D)

for ((i, j), w_ij) in w_ij_not_zero
    W[i, j] = w_ij
    W[j, i] = w_ij
end

outpath = joinpath(@__DIR__, "..", output_folder, "W.csv")
CSV.write(outpath, Tables.table(W); writeheader = false)