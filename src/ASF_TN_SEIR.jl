module ASF_TN_SEIR

using CSV
using DataFrames

export S, E, I, R
export read_matrix

const S = 1
const E = 2
const I = 3
const R = 4

function read_matrix(data_folder::AbstractString,  file_name::AbstractString)
    path = joinpath(@__DIR__, "..", data_folder, file_name)
    df = CSV.read(path, DataFrame)
    return Matrix(df)
end

end