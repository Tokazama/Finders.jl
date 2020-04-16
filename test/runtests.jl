# TODO this requires OffsetArrays
using Test, ChainedFix, Finders

using Base: OneTo

@noinline function find_first_tests(x, collection)
    @testset "find first test - $x, $(typeof(collection))" begin
        @test @inferred(catch_nothing(find_firstgt(x, collection))) ==
              catch_nothing(findfirst(i -> i > x,  collection)) ==
              catch_nothing(find_first(>(x),  collection))

        @test @inferred(catch_nothing(find_firstgteq(x, collection))) ==
              catch_nothing(findfirst(i -> i >= x, collection)) ==
              catch_nothing(find_first(>=(x),  collection))

        @test @inferred(catch_nothing(find_firstlt(x, collection))) ==
              catch_nothing(findfirst(i -> i < x, collection)) ==
              catch_nothing(find_first(<(x),  collection))

        @test @inferred(catch_nothing(find_firstlteq(x, collection))) ==
              catch_nothing(findfirst(i -> i <= x, collection)) ==
              catch_nothing(find_first(<=(x),  collection))

        @test @inferred(catch_nothing(find_firsteq(x, collection))) ==
              catch_nothing(findfirst(i -> i == x, collection)) ==
              catch_nothing(find_first(==(x),  collection))
    end
end

@noinline function find_last_tests(x, collection)
    @testset "find last test - $x, $(typeof(collection))" begin
        @test @inferred(catch_nothing(find_lastgt(x, collection))) ==
              catch_nothing(findlast(i -> i > x,collection)) ==
              catch_nothing(find_last(>(x), collection))

        @test @inferred(catch_nothing(find_lastgteq(x, collection))) ==
              catch_nothing(findlast(i -> i >= x, collection)) ==
              catch_nothing(find_last(>=(x), collection))

        @test @inferred(catch_nothing(find_lastlt(x, collection))) ==
              catch_nothing(findlast(i -> i < x,collection)) ==
              catch_nothing(find_last(<(x), collection))

        @test @inferred(catch_nothing(find_lastlteq(x,collection))) ==
              catch_nothing(findlast(i -> i <= x, collection)) ==
              catch_nothing(find_last(<=(x), collection))

        @test @inferred(catch_nothing(find_lasteq(x, collection))) ==
              catch_nothing(findlast(i -> i == x, collection)) ==
              catch_nothing(find_last(==(x), collection))
    end
end

@noinline function find_all_tests(x, collection)
    @testset "find all test - $x, $(typeof(collection))" begin
        @test @inferred(find_allgt(x, collection)) ==
              findall(i -> i > x, collection) ==
              find_all(>(x),  collection)

        @test @inferred(find_allgteq(x, collection)) ==
              findall(i -> i >= x, collection) ==
              find_all(>=(x),  collection)

        @test @inferred(find_alllt(x, collection)) ==
              findall(i -> i < x, collection) ==
              find_all(<(x),  collection)

        @test @inferred(find_alllteq(x, collection)) ==
              findall(i -> i <= x, collection) ==
              find_all(<=(x),  collection)

        @test @inferred(find_alleq(x, collection)) ==
              findall(i -> i == x, collection) ==
              find_all(==(x),  collection)
    end
end

@noinline function filter_tests(x, collection)
    @testset "filter test - $x, $(typeof(collection))" begin
        @test @inferred(filter(>(x), collection)) ==
              filter(i -> i > x, collection) ==
              filter(>(x), as_fixed(collection))

        @test @inferred(filter(>=(x), collection)) ==
              filter(i -> i >= x, collection) ==
              filter(>=(x), as_fixed(collection))

        @test @inferred(filter(<(x), collection)) ==
              filter(i -> i < x, collection) ==
              filter(<(x), as_fixed(collection))

        @test @inferred(filter(<=(x), collection)) ==
              filter(i -> i <= x, collection) ==
              filter(<=(x), as_fixed(collection))

        @test @inferred(filter(==(x), collection)) ==
              filter(i -> i == x, collection) ==
              filter(==(x), as_fixed(collection))
    end
end

@noinline function count_tests(x, collection)
    @testset "count test - $x, $(typeof(collection))" begin
        @test @inferred(count(>(x), collection)) == count(i -> i > x, collection)
        @test @inferred(count(>=(x), collection)) == count(i -> i >= x, collection)
        @test @inferred(count(<(x), collection)) == count(i -> i < x, collection)
        @test @inferred(count(<=(x), collection)) == count(i -> i <= x, collection)
        @test @inferred(count(==(x), collection)) == count(i -> i == x, collection)
    end
end

@testset "find methods" begin
    for collection in (OneTo(10),
                    IdOffsetRange(OneTo(10), 2),
                    1:10,
                    IdOffsetRange(1:10, 2),
                    UnitRange(1.0, 10.0),
                    StepRange(1, 2, 10),
                    StepRange(10, -2, 1),
                    LinRange(1, 5, 10),
                    LinRange(5, 1, 10),
                    range(1.0, step=0.25, stop=10),
                    range(10.0, step=-0.25, stop=1.0))
        for x in (first(collection) - step(collection),
                first(collection) - step(collection) / 2,
                first(collection),
                first(collection) + step(collection) / 2,
                first(collection) + step(collection),
                last(collection) - step(collection),
                last(collection) - step(collection) / 2,
                last(collection),
                last(collection) + step(collection) / 2,
                last(collection) + step(collection))
            find_first_tests(x, collection)
            find_last_tests(x, collection)
            find_all_tests(x, collection)
            # FIXME - filter AbstractLinRange doesn't come out as
            # expected because getindex results in inexact values
            # in both base and AbstractLinRange.
            if !isa(collection, LinMRange)
                filter_tests(x, collection)
            end
            count_tests(x, collection)
        end
    end

    for collection in (OneTo(0), 1:0, 1:1:0, 0:-1:1,LinRange(1, 1, 0))
        for x in (-1, -0.5, 0, 0.5, 1)
            find_first_tests(x, collection)
            find_last_tests(x, collection)
            find_all_tests(x, collection)
        end
    end

    for x in (-1, -0.5, 0, 0.5, 1, 9, 9.5, 10, 10.5, 11)
        find_first_tests(x, collect(1:10))
        find_last_tests(x, collect(1:10))
        find_all_tests(x, collect(1:10))
    end
end

@testset "filter non numerics" begin
    x = Second(1):Second(1):Second(10)
    @test @inferred(find_all(and(>=(Second(1)), <=(Second(3))), x)) == 1:3
    @test @inferred(findin(Second(1):Second(1):Second(3), x)) == 1:3

    x = Second(10):Second(-1):Second(1)
    @test @inferred(findin(Second(1):Second(1):Second(3), x)) == 10:1:9
end

@testset "find_all(in(x), r)" begin
    r = @inferred(find_all(in(OneTo(10)), OneTo(8)))
    @test r == 1:8
    @test isa(r, OneTo)

    @test find_all(in(collect(1:10)), 1:20) == find_all(in(1:10), 1:20)
    @test find_all(in(1:10), collect(1:20)) == 1:10

    @testset "steps match but no overlap" begin
        r = @inferred(findin(1:3, 4:5))
        @test r == 1:0
        @test isa(r, UnitRange)
    end

    @test findin([1, 2, 3], collect(1:10)) == [1, 2, 3]

    for (x, y, z) in ((1:10, 1:2:10, 1:5),
                      (1:2:20, 1:8:20, 1:3),
                      (1:2:20, 1:10, 1:2:9),
                      (1:2:10, 1.1:1:10.1, []),
                      (UnitRange(1.1, 10.1), UnitRange(2.1, 8.1), 1:7),
                      (UnitRange(2.1, 8.1), UnitRange(1.1, 10.1), 2:8)
                     )
        @testset "find_all(in($x), $y)" begin
            @test @inferred(find_all(in(x), y)) == z
        end
    end

    @testset "find_all(in(::IntervalSets), r)" begin
        for (i,t) in ((Interval{:closed,:closed}(1, 10), 1:10),
                      (Interval{:open,:closed}(1, 10), 2:10),
                      (Interval{:closed,:open}(1, 10), 1:9),
                      (Interval{:open,:open}(1, 10), 2:9))
            @test find_all(in(i), 1:10) == t
        end
    end
end

