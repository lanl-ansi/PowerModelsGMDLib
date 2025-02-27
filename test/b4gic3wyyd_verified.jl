using PowerModelsGMDLib
const _PMGLib = PowerModelsGMDLib

using PowerModelsGMD
const _PMG = PowerModelsGMD

import InfrastructureModels
const _IM = InfrastructureModels

import PowerModels
const _PM = PowerModels

import JSON
import JuMP
import Ipopt
import Juniper
import LinearAlgebra
import SparseArrays
using Test
using GZip
import Memento

Memento.setlevel!(Memento.getlogger(_PMG), "error")
Memento.setlevel!(Memento.getlogger(_IM), "error")
Memento.setlevel!(Memento.getlogger(_PM), "error")

_PMG.logger_config!("error")
const TESTLOG = Memento.getlogger(_PMG)
Memento.setlevel!(TESTLOG, "error")

ipopt_solver = JuMP.optimizer_with_attributes(Ipopt.Optimizer, "tol" => 1e-4, "print_level" => 0, "sb" => "yes")
juniper_solver = JuMP.optimizer_with_attributes(Juniper.Optimizer, "nl_solver" => _PM.optimizer_with_attributes(Ipopt.Optimizer, "tol" => 1e-4, "print_level" => 0, "sb" => "yes"), "log_levels" => [])
setting = Dict{String,Any}("output" => Dict{String,Any}("branch_flows" => true))

# data = "../test/data/matpower/b4gic3wyyd.m"
# case = _PM.parse_file(data)

file = "../data/verified_cases/Simple_3w_transformers/b4gic3wyyd.m.gz"
case = _PMGLib.parse_file(file)
_PMG.add_gmd_3w_branch!(case)
sol= _PMG.solve_gmd(case) # linear solver
# sol = _PMG.solve_gmd(case, ipopt_solver; setting=setting) # for opt solver

high_error = 1e-2 # abs(value) >= .0001
low_error = 1 # abs(value) < .0001

@testset "Verified B4GIC 3W YYD solve of GMD" begin
	@testset "dc bus voltage" begin
		@test isapprox(sol["solution"]["gmd_bus"]["1"]["gmd_vdc"], -13.27352524, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["2"]["gmd_vdc"], 20.14576149, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["3"]["gmd_vdc"], -3.4361186, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["4"]["gmd_vdc"], -19.74683189, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["5"]["gmd_vdc"], 29.97056007, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["6"]["gmd_vdc"], -13.27352524, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["7"]["gmd_vdc"], 20.14576149, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["8"]["gmd_vdc"], -3.4361186, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["9"]["gmd_vdc"], -0.76892352, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["10"]["gmd_vdc"], -6.29955006, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["11"]["gmd_vdc"], -6.29955006, rtol=high_error)
	end
	@testset "auto transformers" begin
		@test isapprox(sol["solution"]["qloss"]["6"], 18.367863993876263, rtol=high_error) || isapprox(sol["solution"]["qloss"]["6"], 18.56320979069289, rtol=high_error) 
		@test isapprox(sol["solution"]["ieff"]["6"], 11.4537258100, rtol=high_error)
		@test isapprox(sol["solution"]["qloss"]["7"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["7"], 0.0, rtol=low_error)
	end
	@testset "d-y transformers" begin
		@test isapprox(sol["solution"]["qloss"]["5"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["5"], 0.0, rtol=low_error)
	end
	@testset "y-d transformers" begin
		@test isapprox(sol["solution"]["qloss"]["3"], 55.89169590261849, rtol=high_error) || isapprox(sol["solution"]["qloss"]["3"], 56.50864542657024, rtol=high_error) 
		@test isapprox(sol["solution"]["ieff"]["3"], 33.5761413600, rtol=high_error)
		@test isapprox(sol["solution"]["qloss"]["1"], 34.90488176862414, rtol=high_error) || isapprox(sol["solution"]["qloss"]["1"], 34.687372653164, rtol=high_error) 
		@test isapprox(sol["solution"]["ieff"]["1"], 22.1224536900, rtol=high_error)
	end
	@testset "y-y transformers" begin
	end
	@testset "d-d transformers" begin
	end
	@testset "lines" begin
		@test isapprox(sol["solution"]["ieff"]["2"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["4"], 0.0, rtol=low_error)
	end
end
