function plot_from_long(A::AbstractArray, folderpath::AbstractString, png_name::AbstractString;
                        title::String = "", xlabel::String = "", ylabel::String = "")
    nodes, comps, times = size(A)
    x = range(1, times)
    y = Matrix{Int}(undef, times, nodes)
    label = Matrix{String}(undef, 1, nodes)
    for d in 1:nodes
        y[:, d] = A[d, 3, :]
        label[d] = string(d)
    end
    @show label
    p = plot(x, y, title = title, xlabel = xlabel, ylabel = ylabel, label = label)
    display(p)

    outpath = joinpath(folderpath, png_name)
    savefig(p, outpath)
end

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
        value = zeros(nodes*comps*times)
    )

    value = Vector{Int32}(undef, 0)

    for d in 1:nodes
        @show d
        for c in 1:comps
            @show c
            append!(value, A[d, c, :])
        end
    end
    @show length(value)
    df.value = value

    path = joinpath(@__DIR__, "..", data_folder, file_name)
    CSV.write(path, df)
    println("Saved -> path")
end

function save_by_time(A, data_folder)
    @views for t in axes(A, 3)
        df = DataFrame(A[:, :, t], :auto)
        CSV.write(joinpath(@__DIR__, "..", data_folder, "state_t$(t).csv"), df)
    end
end