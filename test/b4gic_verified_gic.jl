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

#data = "../data/b4gic.m"
#case = _PM.parse_file(data)

raw_file = "../data/verified_cases/4Bus/b4gic.raw.gz" 
gic_file = "../data/verified_cases/4Bus/b4gic.gic.gz" 
csv_file = "../data/verified_cases/4Bus/b4gic_gic_lines.csv.gz" 

raw_io = GZip.open(raw_file)
gic_io = GZip.open(gic_file)
csv_io = GZip.open(csv_file)

sol = _PMGMD.solve_gmd(raw_io, gic_io, csv_io)

close(raw_io)
close(gic_io)
close(csv_io)

max_error = 1e-2

@testset "Verified B4GIC linear solve of GMD" begin
	@testset "auto transformers" begin
	end
	@testset "y-d transformers" begin
		 @test isapprox(sol["solution"]["qloss"]["2"], 37.220674406003006, rtol=max_error) || isapprox(sol["solution"]["qloss"]["2"], 37.313418981734294, rtol=max_error) 
		 @test isapprox(sol["solution"]["ieff"]["2"], 22.09875679, rtol=max_error)
		 @test isapprox(sol["solution"]["qloss"]["3"], 37.15240659861487, rtol=max_error) || isapprox(sol["solution"]["qloss"]["3"], 37.2689694, rtol=max_error) 
		 @test isapprox(sol["solution"]["ieff"]["3"], 22.09875679, rtol=max_error)
	end
	@testset "y-y transformers" begin
	end
	@testset "d-d transformers" begin
	end
	@testset "lines" begin
		 @test isapprox(sol["solution"]["qloss"]["1"], 0.0, rtol=max_error)
		 @test isapprox(sol["solution"]["ieff"]["1"], 0.0, rtol=max_error)
	end
end
