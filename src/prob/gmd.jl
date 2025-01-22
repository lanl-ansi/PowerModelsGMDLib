function solve_gmd(ac_file::String; kwargs...)::Dict
    return _PMG.solve_gmd(parse_file(ac_file; kwargs...))
end

function solve_gmd(ac_file::String, gic_file::String; kwargs...)::Dict
    return _PMG.solve_gmd(parse_files(ac_file, voltage_file; kwargs...))
end

function solve_gmd(ac_file::String, gic_file::String, voltage_file::String; kwargs...)::Dict
    return _PMG.solve_gmd(parse_files(ac_file, gic_file, voltage_file; kwargs...))
end

