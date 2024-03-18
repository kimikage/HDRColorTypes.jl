"""
    frexp8(val)

Return `(x, exp)` such that `x` has a magnitude in the interval [0, 255.5), and
`val` is equal to `x * 2^exp`.
"""
frexp8(val) = frexp8(Float32(val))
function frexp8(val::Float32) # TODO: specialize `frexp8` for Float16
    if !(val > Float32(0x1p-137)) # includes NaN32
        return (0.0f0, -136)
    end
    if val > Float32(0x1ffp118)
        return (255.49998f0, 119)
    end
    u32 = reinterpret(UInt32, val)
    m32 = u32 & 0x7fffff
    e32 = u32 >> 0x17
    if iszero(e32) # subnormal numbers
        # 0b0000000_00010000_00000001 * 2f0^-149 -> (0.50024414f0, -136)
        # 0b0011111_11101111_11111111 * 2f0^-149 -> (255.49976f0, -136)
        u32 < 0b0011111_11110000_00000000 && return (u32 * Float32(0x1p-13), -136)
        u32 < 0b0111111_11100000_00000000 && return (u32 * Float32(0x1p-14), -135)
        u32 < 0b1111111_11000000_00000000 && return (u32 * Float32(0x1p-15), -134)
        return (u32 * Float32(0x1p-16), -133)
    else
        e32m = Int(e32) + (m32 >= 0x7f8000 ? -133 : -134)
        e32r = m32 >= 0x7f8000 ? 0x42800000 : 0x43000000
        f32 = reinterpret(Float32, m32 | e32r)
        return (f32, e32m)
    end
end
