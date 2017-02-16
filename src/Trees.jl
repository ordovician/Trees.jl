module Trees

include("treenode.jl")
include("tree.jl")

function test_tree()
  letters = collect('A':'Z')
  numbers = map(Int, letters)
  Tree(zip(letters, numbers) |> collect |> shuffle)
end

end # module
