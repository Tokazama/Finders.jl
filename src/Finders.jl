module Finders

using ChainedFixes, IntervalSets

using Base: OneTo, TwicePrecision

export
    find_first,
    find_firsteq,
    find_firstgt,
    find_firstlt,
    find_firstgteq,
    find_firstlteq,
    find_last,
    find_lasteq,
    find_lastgt,
    find_lastlt,
    find_lastgteq,
    find_lastlteq,
    findin,
    find_all,
    find_alleq,
    find_allgt,
    find_alllt,
    find_allgteq,
    find_alllteq

include("findin.jl")
include("findvalue.jl")
include("find_firsteq.jl")
include("find_firstgt.jl")
include("find_firstlt.jl")
include("find_firstgteq.jl")
include("find_firstlteq.jl")
include("find_lasteq.jl")
include("find_lastgt.jl")
include("find_lastlt.jl")
include("find_lastgteq.jl")
include("find_lastlteq.jl")
include("findall.jl")
include("findlast.jl")
include("findfirst.jl")

end # module
