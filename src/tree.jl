import Base: isempty, getindex, setindex!, show

# Implement iteration interface
import Base: start, next, done, iteratorsize

export  Tree

"""
A facade to the binary search tree,
presenting it as a sorted map or dictionary
"""
type Tree{K, V}
  root::Nullable{TreeNode{K,V}}
  Tree{K, V}(root::TreeNode{K,V}) = new(Nullable(root))
  Tree() = new(Nullable{TreeNode{K,V}}())
end

# I don't know any other way to get hold of the
# individual type parameters held in Tuple and Pair
pair_key{K, V}(::Type{Pair{K, V}}) = K
pair_value{K, V}(::Type{Pair{K, V}}) = V
pair_key{K, V}(::Type{Tuple{K, V}}) = K
pair_value{K, V}(::Type{Tuple{K, V}}) = V

"Make tree from pair of values, just like a dictionary"
function Tree(ps)
  k, v = ps[1]
  root = TreeNode(k, v)
  for (k, v) in ps[2:end]
    n = TreeNode(k, v)
    add!(root, n)
  end
  T = eltype(ps)
  K = pair_key(T)
  V = pair_value(T)
  Tree{K, V}(root)
end

Tree{K,V}(ps::Pair{K,V}...) = Tree(ps)
Tree{K,V}(ps::Tuple{K,V}...) = Tree(ps)

isempty(t::Tree) = isnull(t.root)

function getindex{K,V}(t::Tree{K,V}, key::K)
  if isnull(t.root)
    throw(KeyError(key))
  else
    n = search(get(t.root), key)
    if isnull(n)
      throw(KeyError(key))
    else
      node_value(get(n))
    end
  end
end

function setindex!{K, V}(t::Tree{K, V}, value::V, key::K)
  if isnull(t.root)
    t.root = Nullable(TreeNode(key, value))
  else
    root = get(t.root)
    add!(root, TreeNode(key, value))
  end
end

# Iteration interface
function start{K, V}(t::Tree{K, V})
  if isnull(t.root)
    TreeNode{K, V}[]
  else
    [get(t.root)]
  end
end

function next{K, V}(t::Tree{K, V}, stack::Vector{TreeNode{K, V}})
	n = pop!(stack)
	if has_left(n)
		push!(stack, left_child(n))
	end
	if has_right(n)
		push!(stack, right_child(n))
	end
	(node_key(n) => node_value(n)), stack
end

done{K, V}(t::Tree{K, V}, stack::Vector{TreeNode{K, V}}) = isempty(stack)

iteratorsize(t::Tree) =  Base.SizeUnknown()


function show{K, V}(io::IO, t::Tree{K, V})
  xs = collect(t)
  len = length(xs)
  println(io, "Tree{$K, $V} with $len entries:")
  n = 1
  limit = 10 # Max elements to show
  for (k, v) in xs
    print(io, "  ")
    show(io, k)
    print(io, " => ")
    show(io, v)
    n < len && println(io)
    n >= limit && (print(io, "  …"); break)
    n += 1
  end
end
