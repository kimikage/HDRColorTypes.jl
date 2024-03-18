using Documenter, HDRColorTypes
using ColorTypes
using FixedPointNumbers
using Colors

makedocs(
    clean=false,
    warnonly=true, # FIXME
    checkdocs=:exports,
    modules=[HDRColorTypes],
    format=Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true",
                           assets = []),
    sitename="HDRColorTypes",
    pages=[
        "Introduction" => "index.md",
        "API Reference" => "api.md",
    ]
)

deploydocs(
    repo="github.com/kimikage/HDRColorTypes.jl.git",
    devbranch = "main",
    push_preview = true
)
