function parse_file(file::String; kwargs...)::Dict
    basename, ext = lowercase(splitext(file)[end])

    if ext == ".gz"
        basename, ext = splitext(basename)
        io = GZip.open(file)

        if ext == ".gic"
            gic_data = parse_gic(io)
            close(io)
            return gic_data
        elseif ext == ".m"
            ac_data =  PowerModels.parse_matpower(file; kwargs...)
            close(io)
            return ac_data
        elseif ext == ".raw"
            ac_data =  PowerModels.parse_raw(file; kwargs...)
            close(io)
            return ac_data
        end
    end

    io = open(file)
    return parse_gic(io)
    close(io)
end

# TODO: handle csv voltage file?
function parse_files(files::String...; kwargs...)::Dict
    mn_data = Dict{String, Any}(
        "nw" => Dict{String, Any}(),
        "per_unit" => true,
        "multinetwork" => true
    )

    names = Array{String, 1}()

    for (i, filename) in enumerate(files)
        data = parse_file(filename; kwargs...)

        delete!(data, "multinetwork")
        delete!(data, "per_unit")

        mn_data["nw"]["$i"] = data
        push!(names, "$(data["name"])")
    end

    mn_data["name"] = join(names, " + ")

    return mn_data
end
