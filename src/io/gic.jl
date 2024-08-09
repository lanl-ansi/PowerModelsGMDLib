#################################################################
#                                                               #
# This file provides functions for interfacing with .gic files  #
#                                                               #
#################################################################

function parse_gic(file::String)::Dict
    io =  endswith(file, ".gz") ? GZip.open(file) : open(file)
    gic_data = parse_gic(io)
    close(io)
    return gic_data
end

