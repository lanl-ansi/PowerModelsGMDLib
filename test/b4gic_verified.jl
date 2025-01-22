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

file = "../data/verified_cases/4Bus/b4gic.m.gz"
sol = _PMGLib.solve_gmd(file)

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
