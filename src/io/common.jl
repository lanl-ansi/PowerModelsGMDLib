function parse_files(ac_file::String, gic_file::String; kwargs...)::Dict
    ac_basename, ac_ext = lowercase(splitext(ac_file)[end])
    ac_data = Dict()

    if ac_ext == ".gz"
        ac_basename, ac_ext = splitext(ac_basename)
        io = GZip.open(ac_file)

        if ext == ".m"
            ac_data =  PowerModels.parse_matpower(io; kwargs...)
        elseif ext == ".raw"
            ac_data =  PowerModels.parse_raw(io; kwargs...)
        end

        close(io)
    else
        ac_data = PowerModels.parse_file(ac_file)
    end

    gic_basename, gic_ext = lowercase(splitext(gic_file)[end])
    gic_data = Dict()

    if gic_ext == ".gz"
        gic_basename, _ = splitext(gic_basename)
        io = GZip.open(gic_file)


    gic_data = parse_gic(gic_file)
    raw_data = _PM.parse_file(raw_file)
    net =  generate_dc_data(gic_data, raw_data)
    add_coupled_voltages!(voltage_file, net)
    return net
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
