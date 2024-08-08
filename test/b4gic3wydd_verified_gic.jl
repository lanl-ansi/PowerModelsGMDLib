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
using GZip
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

# data = "../test/data/matpower/b4gic3wydd.m"
# case = _PM.parse_file(data)

raw_file = "../data/verified_cases/Simple_3w_transformers/b4gic3wydd.raw.gz" 
gic_file = "../data/verified_cases/Simple_3w_transformers/b4gic3wydd.gic.gz" 
csv_file = "../data/verified_cases/Simple_3w_transformers/b4gic3wydd_gic_lines.csv.gz" 

raw_io = GZip.open(raw_file)
gic_io = GZip.open(gic_file)
csv_io = GZip.open(csv_file)

raw_data = PowerModels.parse_psse(raw_io)
gic_data = PowerModelsGMD.parse_gic(gic_io)
case = PowerModelsGMD.generate_dc_data(gic_data, raw_data)
PowerModelsGMD.load_voltages!(csv_io, case)

close(raw_io)
close(gic_io)
close(csv_io)

_PMGMD.add_gmd_3w_branch!(case)

sol= _PMGMD.solve_gmd(case) # linear solver
# sol=  _PMGMD.solve_gmd(case, ipopt_solver; setting=setting) # for opt solver

high_error = 1e-2 # abs(value) >= .0001
low_error = 1 # abs(value) < .0001

@testset "Verified B4GIC 3W YDD solve of GMD" begin
	@testset "dc bus voltage" begin
		@test isapprox(sol["solution"]["gmd_bus"]["1"]["gmd_vdc"], -11.52731895, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["2"]["gmd_vdc"], 0.00072924, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["3"]["gmd_vdc"], 5.7632947, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["4"]["gmd_vdc"], -17.14902496, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["5"]["gmd_vdc"], 0.00108488, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["6"]["gmd_vdc"], -11.52731895, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["7"]["gmd_vdc"], 0.00072924, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["8"]["gmd_vdc"], 5.7632947, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["9"]["gmd_vdc"], 10.56632805, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["10"]["gmd_vdc"], -85.39142609, rtol=high_error)
		@test isapprox(sol["solution"]["gmd_bus"]["11"]["gmd_vdc"], 5.7632947, rtol=high_error)
	end
	@testset "auto transformers" begin
	end
	@testset "d-y transformers" begin
		@test isapprox(sol["solution"]["qloss"]["5"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["5"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["qloss"]["7"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["7"], 0.0, rtol=low_error)
	end
	@testset "y-d transformers" begin
		@test isapprox(sol["solution"]["qloss"]["3"], 0.002023639586018325, rtol=high_error) || isapprox(sol["solution"]["qloss"]["3"], 0.00204597713472, rtol=high_error) 
		@test isapprox(sol["solution"]["ieff"]["3"], 0.0012153900, rtol=high_error)
		@test isapprox(sol["solution"]["qloss"]["1"], 30.31294471025795, rtol=high_error) || isapprox(sol["solution"]["qloss"]["1"], 30.12405016437104, rtol=high_error) 
		@test isapprox(sol["solution"]["ieff"]["1"], 19.2121181500, rtol=high_error)
	end
	@testset "y-y transformers" begin
		@test isapprox(sol["solution"]["qloss"]["6"], 30.809701042890943, rtol=high_error) || isapprox(sol["solution"]["qloss"]["6"], 31.13736819035633, rtol=high_error) 
		@test isapprox(sol["solution"]["ieff"]["6"], 19.2121334100, rtol=high_error)
	end
	@testset "d-d transformers" begin
	end
	@testset "lines" begin
		@test isapprox(sol["solution"]["ieff"]["2"], 0.0, rtol=low_error)
		@test isapprox(sol["solution"]["ieff"]["4"], 0.0, rtol=low_error)
	end
end
