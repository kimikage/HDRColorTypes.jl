# HDRColorTypes
This package is an add-on to [ColorTypes](https://github.com/JuliaGraphics/ColorTypes.jl),
and provides color types for [high dynamic range](https://en.wikipedia.org/wiki/High_dynamic_range)
imaging.

Note that types such as `RGB{Float16}` are already supported in `ColorTypes`.
Currently this package supports the Radiance formats [`RGBE32`](@ref) and
[`XYZE32`](@ref).

## `RGBE32` and `XYZE32`
`RGBE32` and `XYZE32` are color types based on floating-point numbers with three
color component mantissa parts and one exponent part shared by the three.
The mantissa parts and exponent part are all represented in 8-bit, and the
colors have the total size of 32-bit.

`RGBE32` and `XYZE32` are defined as types with four fields of type `UInt8` as
follows.
```julia
struct RGBE32{T<:AbstractFloat} <: AbstractRGBE32{T}
    c1::UInt8
    c2::UInt8
    c3::UInt8
    e::UInt8
end
```
```julia
struct XYZE32{T<:AbstractFloat} <: AbstractXYZE32{T}
    c1::UInt8
    c2::UInt8
    c3::UInt8
    e::UInt8
end
```
The fact that they have four fields contrasts with the fact that `ARGB32` and
`RGB24` have one field of type `UInt32`.
Also, the field names are not `r`, `g`, `b` or `x`, `y`, `z`, but `c1`, `c2`,
`c3`.
This is to prevent direct access to the fields by mistaking a color for `RGB`
or `XYZ`, in addition to the viewpoint of generality.

As the definitions above indicate, `RGBE32` and `XYZ32` are parametric types
with "component type" `T`.
This is common with `RGB{T}` and `XYZ{T}` and different from `ARGB32` and
`RGB24`.
If `T` is not explicitly specified in the constructor, `Float32` is applied.
```@repl ex
using HDRColorTypes
using FixedPointNumbers
RGBE32(100, 0, 0) # constructs an `RGBE32{Float32}`
RGB(100.0, 0, 0), RGB(1, 0, 0) # The determination of `T` differs from `RGB`.
RGBE32{Float16}(10, 20, 30) # You can specify `T` explicitly.
XYZE32{Float64}(10, 20, 30)
```
Of course, the type of the component values is `T`, and the values are lazily
converted.
```@repl ex
using ColorTypes
red(RGBE32{Float16}(3.14, 0, 0))
comp2(XYZE32{Float32}(0, 2.71, 0)) # The actual mantissa part is only 8-bit
```

Note that regardless of the component type `T`, the entities of the instances
of `RGBE32` and `XYZE32` are 32-bit.
```@repl ex
sizeof(RGBE32{Float32})
sizeof(RGBE32{Float64})
```
To be compatible with the `RGB` and `XYZ` constructors, it is not allowed to
pass directly the mantissa and exponent parts to the constructor arguments.
You can use the factory functions [`rgbe32`](@ref) and [`xyze32`](@ref), and
their generic version [`ccce32`](@ref).
```@repl ex
rgbe32(0x12, 0x34, 0x56, 0x78)
xyze32(0x12345678)
ccce32(RGBE32{Float64}, 0x12345678)
```
!!! warning
    It is not recommended to `reinterpret` an `RGBE32` or `XYZE32` color to
    `UInt32` as it is a source of confusion.
    ```@repl ex
    reinterpret(UInt32, rgbe32(0x12345678))
    ```
