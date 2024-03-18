using Test, HDRColorTypes
using ColorTypes

@testset "RGBE32 accessors" begin
    rgbef64 = RGBE32{Float64}(1.5, 3.141, 0.015625)
    rgbef32 = RGBE32{Float32}(1.5, 3.141, 0.015625)
    rgbef16 = RGBE32{Float16}(1.5, 3.141, 0.015625)

    @test red(rgbef64) === comp1(rgbef64) === 1.5
    @test red(rgbef32) === comp1(rgbef32) === 1.5f0
    @test red(rgbef16) === comp1(rgbef16) === Float16(1.5)

    @test green(rgbef64) === comp2(rgbef64) === 201 / 64 === 3.140625
    @test green(rgbef32) === comp2(rgbef32) === Float32(201 / 64)
    @test green(rgbef16) === comp2(rgbef16) === Float16(201 / 64)

    @test blue(rgbef64) === comp3(rgbef64) === 0.015625
    @test blue(rgbef32) === comp3(rgbef32) === 0.015625f0
    @test blue(rgbef16) === comp3(rgbef16) === Float16(0.015625)

    @test_throws Exception comp4(xyzef32)

    @test alpha(rgbef64) === 1.0
    @test alpha(rgbef32) === 1.0f0
    @test alpha(rgbef16) === Float16(1)
end

@testset "XYZE32 accessors" begin
    xyzef64 = XYZE32{Float64}(1.5, 3.141, 0.015625)
    xyzef32 = XYZE32{Float32}(1.5, 3.141, 0.015625)
    xyzef16 = XYZE32{Float16}(1.5, 3.141, 0.015625)

    @test comp1(xyzef64) === 1.5
    @test comp1(xyzef32) === 1.5f0
    @test comp1(xyzef16) === Float16(1.5)

    @test comp2(xyzef64) === 201 / 64 === 3.140625
    @test comp2(xyzef32) === Float32(201 / 64)
    @test comp2(xyzef16) === Float16(201 / 64)

    @test comp3(xyzef64) === 0.015625
    @test comp3(xyzef32) === 0.015625f0
    @test comp3(xyzef16) === Float16(0.015625)

    @test_throws Exception comp4(xyzef32)
    @test_throws Exception red(xyzef32)

    @test alpha(xyzef64) === 1.0
    @test alpha(xyzef32) === 1.0f0
    @test alpha(xyzef16) === Float16(1)
end
