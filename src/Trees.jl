module Trees

export Tree

include("treenode.jl")

"""
A facade to the binary search tree,
presenting it as a sorted map or dictionary
"""
type Tree{K, V}
  root::Nullable{TreeNode{K,V}}
  Tree{K, V}(root::TreeNode{K,V}) = new(Nullable(root))
  Tree() = new(Nullable{TreeNode{K,V}}())
end

include("red-black.jl")
include("tree.jl")

function test_tree()
  letters = collect('A':'Z')
  numbers = map(Int, letters)
  Tree(zip(letters, numbers) |> collect |> shuffle)
end


# Tree rotation test data
#    
#      a               b
#     / \      -->    / \
#    t1  b           a   t3
#       / \         / \
#      t2  t3      t1  t2

function left_rotable_tree()
    Tree(10=>"a", 5=>"t1", 15=>"b", 20=>"t3", 12=>"t2")
end

function right_rotable_tree()
    Tree(15=>"b", 10=>"a", 20=>"t3", 5=>"t1", 12=>"t2")
end


end # module
