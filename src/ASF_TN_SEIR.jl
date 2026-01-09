module ASF_TN_SEIR

using CSV
using DataFrames
using DelimitedFiles
using SparseArrays
using StatsBase

export S, E, I, R
export read_matrix, read_sparse_matrix, read_vector, perform_migration_step!, perform_migration_step!
export findnz

const S = UInt8(1)
const E = UInt8(2)
const I = UInt8(3)
const R = UInt8(4)

include("io.jl")
include("perform_migration_step.jl")
include("perform_infection_step.jl")


end