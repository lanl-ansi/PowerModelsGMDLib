using PowerModelsGMD
const _PMGMD = PowerModelsGMD

import InfrastructureModels
const _IM = InfrastructureModels
import PowerModels
const _PM = PowerModels

import JSON
import JuMP
import Memento

# Suppressing warning messages:
Memento.setlevel!(Memento.getlogger(_PMGMD), "error")
Memento.setlevel!(Memento.getlogger(_IM), "error")
Memento.setlevel!(Memento.getlogger(_PM), "error")

_PMGMD.logger_config!("error")
const TESTLOG = Memento.getlogger(_PMGMD)
Memento.setlevel!(TESTLOG, "error")

import Ipopt
import Juniper

# Setup default optimizers:
ipopt_solver = JuMP.optimizer_with_attributes(Ipopt.Optimizer, "tol" => 1e-4, "print_level" => 0, "sb" => "yes")
juniper_solver = JuMP.optimizer_with_attributes(Juniper.Optimizer, "nl_solver" => _PM.optimizer_with_attributes(Ipopt.Optimizer, "tol" => 1e-4, "print_level" => 0, "sb" => "yes"), "log_levels" => [])
setting = Dict{String,Any}("output" => Dict{String,Any}("branch_flows" => true))

import LinearAlgebra
import SparseArrays

import CSV
using Test

include("test_cases.jl")
# Perform automated testing of PMsGMD problem specifications:
@testset "PowerModelsGMDLib Cases MatPower" begin
    include("activsg200.jl") 
    include("activsg2000_mod.jl")
end

@testset "Verified Cases MatPower" begin
    include("b4gic_verified.jl")
    include("b4gic3wydd_verified.jl")
    include("b4gic3wyyd_verified.jl")
    include("epricase_aug2022_v22_fix_verified.jl")
    include("uiuc150bus_verified.jl")
    include("activsg200_verified.jl")
    include("activsg500_verified.jl")
    #include("activsg2000_mod_verified.jl") # failing
    include("activsg10k_verified.jl")
end

@testset "Verified Cases GIC" begin
    include("parse.jl")
    include("activsg200_gic.jl") # this has a few failing tests
end

@testset "Verified Cases RAW/GIC" begin
    include("b4gic_verified_gic.jl")
    #include("b4gic3wydd_verified_gic.jl") # currently missing .gic.gz file
    include("b4gic3wyyd_verified_gic.jl")
    #include("epricase_aug2022_v22_fix_verified_gic.jl")
    #include("uiuc150bus_verified_gic.jl") # currently failing
    # include("activsg200_verified_gic.jl") .csv.gz file missing data
end

