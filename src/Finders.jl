module Finders

using ChainedFixes
using IntervalSets
using OffsetArrays

using OffsetArrays: IdOffsetRange
using Base: OneTo, TwicePrecision, step_hp

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

for f in (:find_lasteq, :find_lastgt, :find_lastgteq, :find_lastlt, :find_lastlteq,
          :find_firsteq, :find_firstgt, :find_firstgteq, :find_firstlt, :find_firstlteq)
    @eval begin
        function $f(x, r::IdOffsetRange)
            idx = $f(x - r.offset, parent(r))
            if idx isa Nothing
                return idx
            else
                return idx + r.offset
            end
        end
    end
end

end # module
