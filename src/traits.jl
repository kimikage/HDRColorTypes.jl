
ColorTypes.red(c::AbstractRGBE) = comp1(c)
ColorTypes.green(c::AbstractRGBE) = comp2(c)
ColorTypes.blue(c::AbstractRGBE) = comp3(c)

ColorTypes.comp1(c::CCCE32{T}) where {T} = T(c.c1 * _get_scale_float32(c))
ColorTypes.comp2(c::CCCE32{T}) where {T} = T(c.c2 * _get_scale_float32(c))
ColorTypes.comp3(c::CCCE32{T}) where {T} = T(c.c3 * _get_scale_float32(c))
