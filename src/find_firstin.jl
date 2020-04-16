# TODO find_firstin
find_firstin(x, y::OneTo) = _find_firstin_oneto(x, y)

function _find_firstin_oneto(x::OneTo, y)
    if isempty(x) | isempty(y)
        return nothing
    else
        return 1
    end
end

function _find_firstin_oneto(x::OneTo, y)
    if isempty(x) | isempty(y)
        return nothing
    else
        return 1
    end
end

function find_firstin(x, y)
    out = 1
    if (step(x) > 0) & (step(y) > 0)
        for x_i in x
            idx = find_firsteq(x_i, y)
            if !isa(idx, Nothing)
                out = idx
                break
            end
        end
    else
        for x_i in x
            idx = find_lasteq(x_i, y)
            if !isa(idx, Nothing)
                out = idx
                break
            end
        end
    end
    return out
end
