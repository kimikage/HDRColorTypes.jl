
function Base.convert(::Type{C}, ccce::AbstractCCCE) where {C<:Colorant}
    if ccce isa AbstractRGBE
        return _convert_from_rgbe(C, ccce)
    else
        return _convert_from_xyze(C, ccce)
    end
end

function Base.convert(::Type{C}, rgbe::AbstractRGBE) where {C<:AbstractRGBE}
    _convert_between_rgbes(C, rgbe)
end

function Base.convert(::Type{C}, rgb::AbstractRGB) where {C<:AbstractRGBE}
    _convert_to_rgbe(C, rgb)
end
function Base.convert(::Type{C}, xyz::XYZ) where {C<:AbstractXYZE}
    _convert_to_xyze(C, xyz)
end


function _convert_from_rgbe(::Type{C}, rgbe::RGBE32) where {C<:AbstractRGB}
    C(((rgbe.c1, rgbe.c2, rgbe.c3) .* _get_scale_float32(rgbe.e))...)
end

function _convert_from_xyze(::Type{C}, xyze::XYZE32) where {C<:XYZ}
    C(((xyze.c1, xyze.c2, xyze.c3) .* _get_scale_float32(xyze.e))...)
end

function _convert_between_rgbes(::Type{C}, rgbe::RGBE32) where {C<:RGBE32}
    ccce32(C, rgbe.c1, rgbe.c2, rgbe.c3, rgbe.e)
end

function _convert_between_rgbes(::Type{C}, rgbe::AbstractRGBE) where {C<:AbstractRGBE}
    C(red(rgbe), green(rgbe), blue(rgbe))
end

function _convert_to_rgbe(::Type{C}, rgb::AbstractRGB) where {C<:RGBE32}
    ccce32(C, _to_ccce8888((red(rgb), green(rgb), blue(rgb)))...)
end

function _convert_to_xyze(::Type{C}, xyz::XYZ) where {C<:XYZE32}
    ccce32(C, _to_ccce8888((xyz.x, xyz.y, xyz.z))...)
end

_get_scale_float32(c::CCCE32) = _get_scale_float32(c.e)

function _get_scale_float32(e::UInt8)
    if e <= 0x9 # subnormal
        ef32 = UInt32(0x2000) << e
    else
        ef32 = UInt32(e - 0x9) << 0x17
    end
    return reinterpret(Float32, ef32)
end

_to_ccce8888(c::Tuple) = _to_ccce8888(Float32.(c))

function _to_ccce8888(c::NTuple{3,Float32})
    ce1, ce2, ce3 = frexp8.(c)
    c1, e1 = ce1
    c2, e2 = ce2
    c3, e3 = ce3
    ldexp8(val::Float32, n::Int) = round(UInt8, ldexp(val, n))
    me = max(e1, e2, e3)
    des = (e1, e2, e3) .- me
    return ldexp8.((c1, c2, c3), des)..., unsafe_trunc(UInt8, me + 136)
end
