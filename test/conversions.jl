using Test, HDRColorTypes
using ColorTypes
using ColorTypes.FixedPointNumbers

@testset "$CE to $C" for (CE, C) in ((RGBE32, RGB), (XYZE32, XYZ))

    Cf64 = C{Float64}
    Cf32 = C{Float32}
    Cf16 = C{Float16}

    ce32 = ccce32(CE{Float32}, 0x0080ff00)

    @test convert(Cf64, ce32) === Cf64(0.0, 128 * 2.0^-136, 255 * 2.0^-136)
    @test convert(Cf32, ce32) === Cf32(0.0, 128 * 2.0^-136, 255 * 2.0^-136)
    @test convert(Cf16, ce32) === Cf16(0.0, 128 * 2.0^-136, 255 * 2.0^-136)

    ce32 = ccce32(CE{Float32}, 0x0080ff80)
    @test convert(Cf64, ce32) === Cf64(0.0, 128 / 256, 255 / 256)
    @test convert(Cf32, ce32) === Cf32(0.0, 128 / 256, 255 / 256)
    @test convert(Cf32, ce32) === Cf32(0.0, 128 / 256, 255 / 256)

end

@testset "RGBE32 -> RGB -> RGBE32" begin
    count = 0
    for c1 in 0x00:0xff, e in 0x00:0xff
        rgbe = rgbe32(c1, 0x00, 0xff, e)
        rgb = convert(RGB{Float32}, rgbe)
        rgbe2 = convert(RGBE32{Float32}, rgb)
        rgbe === rgbe2 || break
        count += 1
    end
    @test count == 0x10000
end

@testset "RGBE32 to RGB{N0f8}" begin
    @test convert(RGB{N0f8}, rgbe32(0x0080ff00)) === RGB{N0f8}(0.0, 0.0, 0.0)
    @test convert(RGB{N0f8}, rgbe32(0x0080ff80)) === RGB{N0f8}(0.0, 128 / 256, 255 / 256)
    @test_throws Exception convert(RGB{N0f8}, rgbe32(0x0080ff81))
end
