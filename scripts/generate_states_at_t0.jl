import Pkg
Pkg.activate(joinpath(@__DIR__, ".."))
using ASF_TN_SEIR

using CSV
using Distributions
using DelimitedFiles
using Tables

data_folder = "data"
data_file_name = "population.CSV"
output_folder = "data"

p_E = 0.001
p_I = 0.001
p_R = 0.001

input_path = joinpath(@__DIR__, "..", data_folder, data_file_name)
population = vec(readdlm(input_path, ',', Int32))

D_size = length(population)

X = zeros(Int32, D, 4)

E0 = Int32.(rand.(Binomial.(population, p_E)))
I0 = Int32.(rand.(Binomial.(population, p_I)))
R0 = Int32.(rand.(Binomial.(population, p_R)))
S0 = population - E0 - I0 - R0

X[:, S] .= S0
X[:, E] .= E0
X[:, I] .= I0
X[:, R] .= R0

outpath = joinpath(@__DIR__, "..", output_folder, "states_at_t0.csv")
CSV.write(outpath, Tables.table(X); writeheader = false)