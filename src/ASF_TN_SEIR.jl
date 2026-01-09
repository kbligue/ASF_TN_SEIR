module ASF_TN_SEIR

using CSV
using DataFrames
using SparseArrays
using StatsBase

export S, E, I, R
export read_matrix, read_sparse_matrix
export findnz

const S = UInt8(1)
const E = UInt8(2)
const I = UInt8(3)
const R = UInt8(4)

include("perform_migration_step.jl")

function read_matrix(data_folder::AbstractString,  file_name::AbstractString)
    path = joinpath(@__DIR__, "..", data_folder, file_name)
    df = CSV.read(path, DataFrame, header=false)
    return Matrix{Int32}(df)
end

function read_sparse_matrix(data_folder::AbstractString,  file_name::AbstractString)
    path = joinpath(@__DIR__, "..", data_folder, file_name)
    I_loc = Int32[]
    J_loc = Int32[]
    V = Int32[]

    i = 1

    for row in CSV.File(path; header = false)
        for j in 1:length(row) 
            v = row[j]
            v == 0 && continue
            push!(I_loc, Int32(i))
            push!(J_loc, Int32(j))
            push!(V, v)
        end
        i += 1
    end
    return sparse(I_loc, J_loc, V)
end
end