module PowerModelsGMDLib
const _PMGLib = PowerModelsGMDLib

    import InfrastructureModels
    const _IM = InfrastructureModels
    import PowerModels
    const _PM = PowerModels
    # import PowerModelsRestoration
    # const _PMR = PowerModelsRestoration
    import PowerModelsGMD
    const _PMG = PowerModelsGMD

    import PowerModels: pm_it_name, pm_it_sym, nw_ids, nws, ismultinetwork
    import InfrastructureModels: optimize_model!, @im_fields, nw_id_default

    import JSON
    import JuMP
    import Memento

    # Suppressing information and warning messages:
    const _LOGGER = Memento.getlogger(@__MODULE__)
    __init__() = Memento.register(_LOGGER)

    function silence()
        Memento.info(_LOGGER, "Suppressing information and warning messages for the rest of this session.
        Use the Memento package for more fine-grained control of logging.")
        Memento.setlevel!(Memento.getlogger(_IM), "error")
        Memento.setlevel!(Memento.getlogger(_PM), "error")
        Memento.setlevel!(Memento.getlogger(_PMGMD), "error")
        Memento.setlevel!(Memento.getlogger(_PMGMDLib), "error")
    end

    function logger_config!(level)
        Memento.config!(Memento.getlogger("PowerModelsGMDLib"), level)
    end

    import LinearAlgebra
    import SparseArrays

    import CSV
    using GZip
    using DataFrames

    # Add IO functions
    include("io/common.jl")
    include("io/gic.jl")
    
    # Add problem specifications:
    include("prob/gmd.jl")
end
