
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

function read_vector(data_folder::AbstractString,  file_name::AbstractString)
    path = joinpath(@__DIR__, "..", data_folder, file_name)
    return vec(readdlm(path, ',', Int32))
end

function save_long(A, data_folder::AbstractString,  file_name::AbstractString)
    nodes, comps, times = size(A)

    df = DataFrame(
        node = repeat(1:nodes, inner=comps*times),
        compartment = repeat(1:comps, inner=times, outer=nodes),
        time = repeat(1:times, outer=nodes*comps),
        value = vec(A)
    )

    path = joinpath(@__DIR__, "..", data_folder, file_name)
    CSV.write(path, df)
end

function save_by_time(A, data_folder)
    @views for t in axes(A, 3)
        df = DataFrame(A[:, :, t], :auto)
        CSV.write(joinpath(@__DIR__, "..", data_folder, "state_t$(t).csv"), df)
    end
end
