using Trees
using Base.Test

include("testdata.jl")

@testset "All Tests" begin
  t = Tree("one" => 1, "two" => 2, "three" => 3)

  @testset "Tree Creation Tests" begin
    @test t["one"] == 1
    @test t["two"] == 2
    @test t["three"] == 3
  end

  @testset "Tree Mutation Tests" begin
    t["four"] = 4
    t["one"] = 10
    @test t["four"] == 4
    @test t["one"] == 10
  end

  function test_data(tester::Function, data::Vector{Vector{Tuple{K, V}}}) where {K, V}
    for xs in data
      t = Tree(xs)
      d = Dict(xs)
      ys = collect(t)
      zs = collect(d)
      tester(sort(zs), sort(ys))
    end
  end

  @testset "Tree Random Access" begin
    xs = [('D', 4), ('A', 1), ('B', 2)]
    t = Tree(xs)
    d = Dict(xs)
    for (k, v) in d
      @test t[k] == v
    end

    t2 = Tree{Char, Int}()
    for (k, v) in xs
      t2[k] = v
    end
    @test sort(collect(d)) == sort(collect(t2))
  end

  @testset "Tree What Goes In Goes Out" begin
    xs = [('D', 4), ('A', 1), ('B', 2)]
    data = [xs]

    test_data(data) do xs, ys
      @test xs == ys
    end

    data = [rand_pairs() for i in 1:10]

    test_data(data) do xs, ys
      @test xs == ys
    end
  end

  @testset "Tree Data With Duplicates" begin
    # Different pair but identical key in last element
    xs1 = [('D', 4), ('A', 1), ('B', 2), ('D', 2)]

    # An identical pair in last element
    xs2 = [('D', 4), ('A', 1), ('B', 2), ('D', 4)]

    data = [xs1, xs2]
    test_data(data) do xs, ys
      @test xs == ys
    end
  end

  @testset "Tree Data Unique Pairs But Equal Keys" begin
    # Different pair but identical key in last element
    xs1 = [('D', 4), ('A', 1), ('B', 2), ('D', 2)]
    xs2 = [('D', 4), ('A', 1), ('B', 2), ('A', 4)]

    data = map(unique, [xs1, xs2])
    test_data(data) do xs, ys
      @test xs == ys
    end
  end

  @testset "TreeNode Creation Tests" begin
    n = TreeNode('B', 42)
    @test node_value(n) == 42
    @test node_key(n) == 'B'
    @test !has_left(n)
    @test !has_right(n)
  end

  @testset "TreeNode Mutation Tests" begin
    n = TreeNode('D', 5)

    add!(n, TreeNode('A', 1))
    add!(n, TreeNode('F', 3))
    @test has_left(n)
    @test has_right(n)
  end
end
