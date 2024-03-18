"""
`HDRColorTypes` module provides color types for high dynamic range imaging.
Currently this package supports the following Radiance formats:
- [`RGBE32`](@ref)
- [`XYZE32`](@ref)
"""
module HDRColorTypes

using ColorTypes

import Base: convert

# re-export
export AbstractRGB
export RGB, RGB24, ARGB32
export XYZ

export AbstractCCCE, CCCE32, ccce32
export AbstractRGBE, RGBE32, rgbe32
export AbstractXYZE, XYZE32, xyze32

include("utilities.jl")

include("types.jl")
include("traits.jl")
include("conversions.jl")

end # module
