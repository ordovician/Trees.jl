using Trees
using Base.Test

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
