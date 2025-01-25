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
using GZip
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

# file =  "../data/CirculatingCase/circulating_case.m.gz"
# sol= _PMGMD.solve_gmd(file) # linear solver

raw_file = "../data/circulating_case/circulating_case.raw.gz" 
gic_file = "../data/circulating_case/circulating_case.gic.gz" 
csv_file = "../data/circulating_case/circulating_case.csv.gz" 
raw_io = GZip.open(raw_file)
gic_io = GZip.open(gic_file)
csv_io = GZip.open(csv_file)

sol = _PMGMD.solve_gmd(raw_io, gic_io, csv_io)

close(raw_io)
close(gic_io)
close(csv_io)

high_error = 1e-2 # abs(value) >= .0001
low_error = 1 # abs(value) < .0001

@testset "solve of gmd" begin
	@testset "dc bus voltage" begin
		@test isapprox(sol["solution"]["gmd_bus"]["1"]["gmd_vdc"], 0.09542208, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["2"]["gmd_vdc"], 0.05761958, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["3"]["gmd_vdc"], -0.01057484, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["4"]["gmd_vdc"], -0.14246683, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["5"]["gmd_vdc"], 1863.796875, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["6"]["gmd_vdc"], 1128.5949707, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["7"]["gmd_vdc"], 1122.28527832, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["8"]["gmd_vdc"], -203.40647888, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["9"]["gmd_vdc"], -209.6942749, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["10"]["gmd_vdc"], 0.09542208, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["11"]["gmd_vdc"], 0.05761958, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["12"]["gmd_vdc"], -0.01057484, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["13"]["gmd_vdc"], 1863.8190918, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["14"]["gmd_vdc"], -2979.13818359, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["15"]["gmd_vdc"], -2586.25708008, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["16"]["gmd_vdc"], -0.14246683, rtol=high_error)
	end
	@testset "auto transformers" begin
		@test isapprox(sol["solution"]["qloss"]["8"], 1.3392945, rtol=high_error) || isapprox(sol["solution"]["qloss"]["8"], 1.3392945, rtol=high_error) 
		@test isapprox(sol["solution"]["ieff"]["8"], 2.1131007700, rtol=high_error)
		@test isapprox(sol["solution"]["qloss"]["5"], 1.3439595000000002, rtol=high_error) || isapprox(sol["solution"]["qloss"]["5"], 1.3439595000000002, rtol=high_error) 
		@test isapprox(sol["solution"]["ieff"]["5"], 2.1204595600, rtol=high_error)
		@test isapprox(sol["solution"]["qloss"]["4"], 0.005679, rtol=high_error) || isapprox(sol["solution"]["qloss"]["4"], 0.005679, rtol=high_error) 
		@test isapprox(sol["solution"]["ieff"]["4"], 0.0089595200, rtol=high_error)
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
		@test isapprox(sol["solution"]["qloss"]["12"], 0.0, rtol=low_error) || isapprox(sol["solution"]["qloss"]["12"], 0.0, rtol=low_error) 
		@test isapprox(sol["solution"]["ieff"]["12"], 0.0000000000, rtol=low_error)
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