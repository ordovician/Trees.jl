module Trees

import Base: map

# Helper for dealing with Nullable
function map(f::Function, n::Nullable)
    if isnull(n)
        n
    else 
        Nullable(f(get(n)))
    end
end

include("treenode.jl")
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
