# Test cases for GIC file parser

@testset "Test .gic file parser" begin
    @testset "200 Node Case" begin
        gic_file = "../data/verified_cases/200Bus/activsg200.gic.gz"
        io = GZip.open(gic_file)
        data_dict = PowerModelsGMD.parse_gic(io)
        close(io)
        @test isa(data_dict, Dict)

        @test length(data_dict["SUBSTATION"]) == 111
        for (key, item) in data_dict["SUBSTATION"]
            @test length(item) == 7
        end

        @test length(data_dict["BUS"]) == 200
        for (key, item) in data_dict["BUS"]
            @test length(item) == 2
        end

        @test length(data_dict["TRANSFORMER"]) == 66
        for (key, item) in data_dict["TRANSFORMER"]
            @test length(item) == 17
        end

        @test length(data_dict["BRANCH"]) == 180
        for (key, item) in data_dict["BRANCH"]
            @test length(item) == 6
        end
    end
end
