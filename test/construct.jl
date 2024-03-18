using Test, HDRColorTypes
using ColorTypes
using ColorTypes.FixedPointNumbers

@testset "construct $C from numbers" for C in (RGBE32, XYZE32)
    # Float64
    #@test C(0x00p0, 0x00p-128, 0xffp-128) === C{Float32}(0x00, 0x00, 0x00, 0x00, Val{true})

    #@test C(0x00p0, 0x80p0, 0xffp0) === C{Float32}(0x00, 0x80, 0xff, 0x80, Val{true})
end

@testset "construct $C from color" for C in (RGBE32, XYZE32)
    # Float64
end

@testset "construct $C with 0-arg" for C in (RGBE32, XYZE32)
    @test C() === ccce32(C{Float32}, 0x000000)
    @test C{Float16}() === ccce32(C{Float16}, 0x000000)
end
