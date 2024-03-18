using Test, HDRColorTypes

@testset "frexp8" begin
    frexp8 = HDRColorTypes.frexp8

    @test @inferred(frexp8(0.0f0)) === (0.0f0, -136)
    @test frexp8(Float32(0x1p-137)) === (0.0f0, -136)
    @test Float32(0x001001p-149) === nextfloat(Float32(0x1p-137))
    @test frexp8(Float32(0x001001p-149)) === (Float32(0x001001p-13), -136)
    @test frexp8(Float32(0x1fefffp-149)) === (Float32(0x1fefffp-13), -136)
    @test frexp8(Float32(0x1ff000p-149)) === (Float32(0x1ff000p-14), -135)
    @test frexp8(Float32(0x3fdfffp-149)) === (Float32(0x3fdfffp-14), -135)
    @test frexp8(Float32(0x3fe000p-149)) === (Float32(0x3fe000p-15), -134)
    @test frexp8(Float32(0x7fbfffp-149)) === (Float32(0x7fbfffp-15), -134)
    @test frexp8(Float32(0x7fc000p-149)) === (Float32(0x7fc000p-16), -133)
    @test frexp8(Float32(0x7fffffp-149)) === (Float32(0x7fffffp-16), -133)
    @test frexp8(Float32(0x800000p-149)) === (Float32(0x800000p-16), -133)
    @test frexp8(0.5f0) === (128.0f0, -8)
    @test frexp8(1.0f0) === (128.0f0, -7)
    @test frexp8(128.0f0) === (128.0f0, 0)
    @test frexp8(255.0f0) === (255.0f0, 0)
    @test frexp8(255.8f0) === (127.9f0, 1)
    @test frexp8(256.0f0) === (128.0f0, 1)
    @test frexp8(1000.0f0) === (250.0f0, 2)
    @test frexp8(1.6980887f38) === (255.49998f0, 119)

    @test frexp8(Inf32) === (255.49998f0, 119)

    @test frexp8(-1.0f-3) === (0.0f0, -136)
    @test frexp8(-NaN32) === (0.0f0, -136)
    @test frexp8(-Inf32) === (0.0f0, -136)

    @test frexp8(0.5) === (128.0f0, -8)
    @test frexp8(Float16(0.5)) === (128.0f0, -8)
end
