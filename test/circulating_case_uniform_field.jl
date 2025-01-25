using PowerModelsGMD
const _PMGMD = PowerModelsGMD

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
import Memento
Memento.setlevel!(Memento.getlogger(_PMGMD), "error")
Memento.setlevel!(Memento.getlogger(_IM), "error")
Memento.setlevel!(Memento.getlogger(_PM), "error")

_PMGMD.logger_config!("error")
const TESTLOG = Memento.getlogger(_PMGMD)
Memento.setlevel!(TESTLOG, "error")

ipopt_solver = JuMP.optimizer_with_attributes(Ipopt.Optimizer, "tol" => 1e-4, "print_level" => 0, "sb" => "yes")
juniper_solver = JuMP.optimizer_with_attributes(Juniper.Optimizer, "nl_solver" => _PM.optimizer_with_attributes(Ipopt.Optimizer, "tol" => 1e-4, "print_level" => 0, "sb" => "yes"), "log_levels" => [])
setting = Dict{String,Any}("output" => Dict{String,Any}("branch_flows" => true))


data = raw"C:\Users\305232\Repos\gmd-tools\data\networks\CirculatingCase\circulating_case_uniform_field.m"
case = _PM.parse_file(data)
_PMGMD.add_gmd_3w_branch!(case)
sol= _PMGMD.solve_gmd(case) # linear solver
# sol=  _PMGMD.solve_gmd(case, ipopt_solver; setting=setting) # for opt solver

high_error = 1e-2 # abs(value) >= .0001

low_error = 1 # abs(value) < .0001

@testset "solve of gmd" begin
	@testset "dc bus voltage" begin
		@test isapprox(sol["solution"]["gmd_bus"]["1"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["2"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["3"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["4"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["5"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["6"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["7"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["8"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["9"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["10"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["11"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["12"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["13"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["14"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["15"]["gmd_vdc"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["gmd_bus"]["16"]["gmd_vdc"], 0.0, rtol=low_error)
	end
	@testset "auto transformers" begin
		@test isapprox(sol["solution"]["qloss"]["8"], 0.0, rtol=low_error) || isapprox(sol["solution"]["qloss"]["8"], 0.0, rtol=low_error) 
		@test isapprox(sol["solution"]["ieff"]["8"], 0.0000000000, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["12"], 0.0, rtol=low_error) || isapprox(sol["solution"]["qloss"]["12"], 0.0, rtol=low_error) 
		@test isapprox(sol["solution"]["ieff"]["12"], 0.0000000000, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["5"], 0.0, rtol=low_error) || isapprox(sol["solution"]["qloss"]["5"], 0.0, rtol=low_error) 
		@test isapprox(sol["solution"]["ieff"]["5"], 0.0000000000, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["4"], 0.0, rtol=low_error) || isapprox(sol["solution"]["qloss"]["4"], 0.0, rtol=low_error) 
		@test isapprox(sol["solution"]["ieff"]["4"], 0.0000000000, rtol=low_error)
	end
	@testset "d-y transformers" begin
	end
	@testset "y-d transformers" begin
		@test isapprox(sol["solution"]["qloss"]["3"], 0.0, rtol=low_error) || isapprox(sol["solution"]["qloss"]["3"], 0.0, rtol=low_error) 
		@test isapprox(sol["solution"]["ieff"]["3"], 0.0000000000, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["9"], 0.0, rtol=low_error) || isapprox(sol["solution"]["qloss"]["9"], 0.0, rtol=low_error) 
		@test isapprox(sol["solution"]["ieff"]["9"], 0.0000000000, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["13"], 0.0, rtol=low_error) || isapprox(sol["solution"]["qloss"]["13"], 0.0, rtol=low_error) 
		@test isapprox(sol["solution"]["ieff"]["13"], 0.0000000000, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["6"], 0.0, rtol=low_error) || isapprox(sol["solution"]["qloss"]["6"], 0.0, rtol=low_error) 
		@test isapprox(sol["solution"]["ieff"]["6"], 0.0000000000, rtol=low_error)
	end
	@testset "y-y transformers" begin
	end
	@testset "d-d transformers" begin
	end
	@testset "lines" begin
		@test isapprox(sol["solution"]["qloss"]["1"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["1"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["2"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["2"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["7"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["7"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["10"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["10"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["11"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["11"], 0.0, rtol=low_error)
	end
end