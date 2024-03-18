
abstract type AbstractRGBE{T} <: AbstractRGB{T} end
abstract type AbstractXYZE{T} <: Color3{T} end # ColorTypes does not define AbstractXYZ

abstract type AbstractRGBE32{T} <: AbstractRGBE{T} end
abstract type AbstractXYZE32{T} <: AbstractXYZE{T} end

const AbstractCCCE{T} = Union{
    AbstractRGBE{T},
    AbstractXYZE{T},
}

"""
    RGBE32{T<:AbstractFloat} <: AbstractRGBE32{T}

32-bit RGBE color type based on the Radiance HDR format.

!!! note
    While `ColorTypes.RGB` is usually assumed to be gamma-corrected sRGB, the
    RGBE format usually handles linear RGBs.
    The color primaries may also differ from those of sRGB.
"""
struct RGBE32{T<:AbstractFloat} <: AbstractRGBE32{T}
    c1::UInt8
    c2::UInt8
    c3::UInt8
    e::UInt8
    function RGBE32{T}(r8::UInt8, g8::UInt8, b8::UInt8, e8::UInt8, ::Type{Val{true}}) where {T}
        new{T}(r8, g8, b8, e8)
    end
end

"""
    XYZE32{T<:AbstractFloat} <: AbstractXYZE32{T}

32-bit XYZE color type based on the Radiance HDR format.
"""
struct XYZE32{T<:AbstractFloat} <: AbstractXYZE32{T}
    c1::UInt8
    c2::UInt8
    c3::UInt8
    e::UInt8
    function XYZE32{T}(x8::UInt8, y8::UInt8, z8::UInt8, e8::UInt8, ::Type{Val{true}}) where {T}
        new(x8, y8, z8, e8)
    end
end

"""
    CCCE32{T} = Union{RGBE32{T}, XYZE32{T}}
"""
const CCCE32{T} = Union{
    RGBE32{T},
    XYZE32{T},
}

(::Type{C})() where {C<:CCCE32} = ccce32(C, 0x0, 0x0, 0x0, 0x0)

function (::Type{C})(c1::T1, c2::T2, c3::T3) where {T1,T2,T3,C<:CCCE32}
    Ts = promote_type(T1, T2, T3)
    if Ts <: AbstractFloat && promote_type(Ts, Float32) === Float32
        T = Ts
    else
        T = Float32
    end
    return C{T}(_to_ccce8888(Ts.((c1, c2, c3)))..., Val{true})
end

function (::Type{C})(c1::T1, c2::T2, c3::T3) where {T1,T2,T3,T,C<:CCCE32{T}}
    Ts = promote_type(T1, T2, T3)
    return C(_to_ccce8888(Ts.((c1, c2, c3)))..., Val{true})
end


(::Type{C})(rgb::AbstractRGB) where {C<:RGBE32} = _convert_to_rgbe(C, rgb)
(::Type{C})(argb::TransparentRGB) where {C<:RGBE32} = _convert_to_rgbe(C, color(argb))


(::Type{C})(xyz::XYZ) where {C<:XYZE32} = _convert_to_xyze(C, xyz)
(::Type{C})(axyz::TransparentColor{<:XYZ}) where {C<:XYZE32} = _convert_to_xyze(C, color(axyz))
"""
    ccce32(RGBE32{T}, c1::UInt8, c2::UInt8, c3::UInt8, e::UInt8) -> RGBE32{T}
    ccce32(XYZE32{T}, c1::UInt8, c2::UInt8, c3::UInt8, e::UInt8) -> XYZE32{T}

Construct a Radiance HDR format color from four arguments of `UInt8`.
If the component type `T` is not specified, `Float32` is applied.

This function is a generic version of [`rgbe32`](@ref) and [`xyze32`](@ref).
"""
function ccce32(::Type{C}, c1::UInt8, c2::UInt8, c3::UInt8, e::UInt8) where {C<:CCCE32}
    C{Float32}(c1, c2, c3, e, Val{true})
end
function ccce32(::Type{C}, c1::UInt8, c2::UInt8, c3::UInt8, e::UInt8) where {T,C<:CCCE32{T}}
    C(c1, c2, c3, e, Val{true})
end

"""
    ccce32(RGBE32{T}, ccce::UInt32) -> RGBE32{T}
    ccce32(XYZE32{T}, ccce::UInt32) -> XYZE32{T}

Construct a Radiance HDR format color from a `UInt32` value in `0xRRGGBBEE` or
`0xXXYYZZEE` format.
If the component type `T` is not specified, `Float32` is applied.

This function is a generic version of [`rgbe32`](@ref) and [`xyze32`](@ref).
"""
function ccce32(::Type{C}, ccce::UInt32) where {C<:CCCE32}
    ccce32(
        C,
        (ccce >> 0x18) % UInt8,
        (ccce >> 0x10) % UInt8,
        (ccce >> 0x08) % UInt8,
        ccce % UInt8)
end

"""
    rgbe32(r8::UInt8, g8::UInt8, b8::UInt8, e8::UInt8) -> RGBE32{Float32}

Construct an `RGBE32` color from four arguments in `UInt8`.
Note that `RGBE32(r8, g8, b8, e8)` is not allowed for compatibility with other
`AbstractRGB` and `TransparentRGB` color constructors.

See also [`ccce32`](@ref).
"""
function rgbe32(r8::UInt8, g8::UInt8, b8::UInt8, e8::UInt8)
    RGBE32{Float32}(r8, g8, b8, e8, Val{true})
end

"""
    xyze32(x8::UInt8, y8::UInt8, z8::UInt8, e8::UInt8) -> XYZE32{Float32}

Construct an `XYZE32` color from four arguments of `UInt8`.
Note that `XYZE32(x8, y8, z8, e8)` is not allowed for compatibility with other
`XYZ`, `AXYZ`, and `XYZA` color constructors.

See also [`ccce32`](@ref).
"""
function xyze32(x8::UInt8, y8::UInt8, z8::UInt8, e8::UInt8)
    XYZE32{FLoat32}(x8, y8, z8, e8, Val{true})
end

"""
    rgbe32(rgbe::UInt32) -> RGBE32{Float32}

Construct an `RGBE32` color from a `UInt32` value in `0xRRGGBBEE` format.

See also [`ccce32`](@ref).
"""
rgbe32(rgbe::UInt32) = ccce32(RGBE32{Float32}, rgbe)

"""
    xyze32(xyze::UInt32) -> XYZE32{Float32}

Construct an `XYZE32` color from a `UInt32` value in `0xXXYYZZEE` format.

See also [`ccce32`](@ref).
"""
xyze32(xyze::UInt32) = ccce32(XYZE32{Float32}, xyze)
