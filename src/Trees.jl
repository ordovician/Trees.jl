module Trees

import Base: isempty, getindex, setindex!, search, show, keytype

# Implement iteration interface
import Base: start, next, done, iteratorsize

export  Tree,
        TreeNode,
        node_key,
        node_value,
        left_child,
        right_child,
        has_left,
        has_right,
        add!,
        search

"A tree node with a key and value"
type TreeNode{K, V}
  key::K
  value::V

  parent::Nullable{TreeNode{K, V}}
  left::Nullable{TreeNode{K, V}}
  right::Nullable{TreeNode{K, V}}

  function TreeNode(key::K, value::V)
    null = Nullable{TreeNode{K, V}}()
    new(key, value, null, null, null)
  end
end

TreeNode{K, V}(key::K, value::V) = TreeNode{K, V}(key, value)

"Key is the value we use to index our data with in the tree"
node_key{K, V}(n::TreeNode{K, V})   = n.key

"The value we are storing in the tree which we retrieve by giving its key"
node_value{K, V}(n::TreeNode{K, V}) = n.value
node_parent(n::TreeNode) = get(n.parent)
left_child(n::TreeNode)  = get(n.left)
right_child(n::TreeNode) = get(n.right)

function set_parent!(child::TreeNode, parent::TreeNode)
  child.parent = Nullable(parent)
end

"Give the parent node a left child node"
function set_left_child!(parent::TreeNode, child::TreeNode)
  parent.left = Nullable(child)
end

"Give the parent node a right child node"
function set_right_child!(parent::TreeNode, child::TreeNode)
  parent.right = Nullable(child)
end

has_parent(n::TreeNode) = !isnull(n.parent)

"Does tree node have a left child?"
has_left(n::TreeNode) = !isnull(n.left)

"Does tree node have a right child?"
has_right(n::TreeNode) = !isnull(n.right)

"Does the tree node have any children at all?"
has_children(n::TreeNode) = has_left(n) || has_right(n)

function show(io::IO, n::TreeNode, depth::Integer)
  print(io, "  "^depth)
  show(io, node_key(n))
  print(io, " => ")
  show(io, node_value(n))
  println(io)
  if has_children(n)
    show(io, n.left, depth + 1)
    show(io, n.right, depth + 1)
  end
end

function show{K, V}(io::IO, node_or_null::Nullable{TreeNode{K, V}}, depth::Integer)
  if isnull(node_or_null)
    print(io, "  "^depth)
    println(io, "null")
  else
    show(io, get(node_or_null), depth)
  end
end

function show{K, V}(io::IO, n::TreeNode{K, V})
  if has_children(n)
    show(io, n, 1)
  else
    print(io, "TreeNode(", node_key(n), ", ", node_value(n),")")
  end
end

"""
Adds or replaces a node.
If node with given key already exists,
it will replace previous value in that node.
"""
function add!{K, V}(root::TreeNode{K, V}, child::TreeNode{K, V})
  if node_key(child) == node_key(root)
    root.value = node_value(child)
  elseif node_key(child) < node_key(root)
    if has_left(root)
      add!(left_child(root), child)
    else
      set_left_child!(root, child)
    end
  else
    if has_right(root)
        add!(right_child(root), child)
      else
        set_right_child!(root, child)
    end
  end
end

"Find node containg key. Returns a nullable object"
function search{K, V}(root::TreeNode{K, V}, key::K)
  if node_key(root) == key
		return Nullable(root)
	elseif key < node_key(root)
		if has_left(root)
			return search(left_child(root), key)
		end
	else
		if has_right(root)
			return search(right_child(root), key)
		end
	end
	Nullable{TreeNode{k, V}}()
end

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
	(node_key(n), node_value(n)), stack
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

function test_tree()
  letters = collect('A':'Z')
  numbers = map(Int, letters)
  Tree(zip(letters, numbers) |> collect |> shuffle)
end

end # module
