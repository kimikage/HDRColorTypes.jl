using Test, HDRColorTypes
using ColorTypes
using Colors
using ColorVectorSpace
using Aqua

@testset "Aqua" begin
    Aqua.test_all(HDRColorTypes)
end

@testset "utilities" begin
    include("utilities.jl")
end

@testset "construct" begin
    include("construct.jl")
end

@testset "traits" begin
    include("traits.jl")
end

@testset "Conversions" begin
    include("conversions.jl")
end
