module ASF_TN_SEIR

using CSV
using DelimitedFiles
using Distributions
using Tables

export S, E, I, R
export to_table

const S = 1
const E = 2
const I = 3
const R = 4

to_table(x) = Tables.table(x)
end