function parse_files(ac_file::String, gic_file::String, voltage_file::String; kwargs...)::Dict
    net =  parse_files(ac_file, gic_file; kwargs...)
    io = is_gzipped(voltage_file) ? GZip.open(voltage_file) : open(voltage_file)
    _PMG.add_coupled_voltages!(io, net)
    close(io)
    # TODO: include 3W transformers function?
    return net
end

function parse_files(ac_file::String, gic_file::String; kwargs...)::Dict
    ac_data = parse_file(ac_file; kwargs...)

    # TODO: try function passing here?
    io = is_gzipped(gic_file) ? GZip.open(gic_file) : open(gic_file)
    gic_data = _PMG.parse_gic(io)
    close(io)

    return _PMG.generate_dc_data(gic_data, ac_data)
end

function parse_file(file::String; kwargs...)::Dict
    basename = splitpath(file)[end]
    casename, ext = splitext(lowercase(basename))
    io = (ext == ".gz") ? GZip.open(file) : open(file)
    casename2, ext2 = (ext == ".gz") ? splitext(casename) : (casename, ext)
    net = (ext2 == ".raw") ? _PM.parse_psse(io; kwargs...) : _PM.parse_matpower(io; kwargs...)
    close(io)

    if !haskey(net, "name")
        net["name"] = casename2
    end

    return net
end

is_gzipped = filename -> lowercase(splitext(filename)[end]) == ".gz"

function has_ext(filename, ext)
    return lowercase(splitext(filename)[end]) == ext
end

get_ext = filename -> lowercase(splitext(filename)[end])



