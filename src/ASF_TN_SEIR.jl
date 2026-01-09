module ASF_TN_SEIR

using CSV
using DataFrames
using DelimitedFiles
using Distributions
using SparseArrays
using StatsBase

export S, E, I, R
export read_matrix, read_sparse_matrix, read_vector, save_long, save_by_time
export perform_migration_step!, perform_migration_step!, run_simulation!
export findnz

const S = UInt8(1)
const E = UInt8(2)
const I = UInt8(3)
const R = UInt8(4)

include("io.jl")
include("run_simulation.jl")
include("perform_migration_step.jl")
include("perform_infection_step.jl")


end