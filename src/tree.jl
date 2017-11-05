import Base: isempty, getindex, setindex!, show, eltype

# Implement iteration interface
import Base: start, next, done, iteratorsize

# I don't know any other way to get hold of the
# individual type parameters held in Tuple and Pair
pair_key{K, V}(::Type{Pair{K, V}}) = K
pair_value{K, V}(::Type{Pair{K, V}}) = V
pair_key{K, V}(::Type{Tuple{K, V}}) = K
pair_value{K, V}(::Type{Tuple{K, V}}) = V

eltype(t::Type{Tree}) = TreeNode

function make_tree{T<:AbstractTree}(::Type{T}, ps::Vector)
    k, v = ps[1]
    root = eltype(T){typeof(k), typeof(v)}(k, v)
    for (k, v) in ps[2:end]
      n = eltype(T){typeof(k), typeof(v)}(k, v)
      add!(root, n)
    end
    T{typeof(k), typeof(v)}(root)    
end

Tree(ps::Vector) = make_tree(Tree, ps)

# "Make tree from pair of values, just like a dictionary"
# function Tree(ps)
#   k, v = ps[1]
#   root = TreeNode(k, v)
#   for (k, v) in ps[2:end]
#     n = TreeNode(k, v)
#     add!(root, n)
#   end
#   T = eltype(ps)
#   K = pair_key(T)
#   V = pair_value(T)
#   Tree{K, V}(root)
# end

Tree{K,V}(ps::Pair{K,V}...) = Tree{K, V}(ps)
Tree{K,V}(ps::Tuple{K,V}...) = Tree{K, V}(ps)

isempty(t::AbstractTree) = isnull(t.root)

function getindex(t, key)
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

function setindex!{K, V}(t::AbstractTree{K, V}, value::V, key::K)
  if isnull(t.root)
    t.root = Nullable(eltype(t)(key, value))
  else
    root = get(t.root)
    add!(root, TreeNode(key, value))
  end
end

# Iteration interface
function start(t::AbstractTree)
  if isnull(t.root)
    typeof(T)[]
  else
    [get(t.root)]
  end
end

function next(t::AbstractTree, stack::Vector)
	n = pop!(stack)
	if has_left(n)
		push!(stack, left_child(n))
	end
	if has_right(n)
		push!(stack, right_child(n))
	end
	(node_key(n) => node_value(n)), stack
end

done(t::AbstractTree, stack::Vector) = isempty(stack)

iteratorsize(t::AbstractTree) =  Base.SizeUnknown()


function show{K, V}(io::IO, t::AbstractTree{K, V})
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

function swap_child_of_parent(t::AbstractTree, a::AbstractTreeNode, b::AbstractTreeNode)
    if isnull(a.parent)
        t.root = Nullable(b)
    else
        p = node_parent(a)
        if !isnull(p.left) && get(p.left) == a
            set_left_child!(p, b)
        else
            set_right_child!(p, b)
        end    
    end    
end

# Based on page 240 in Algorithms in a Nutshell
#    
#      a               b
#     / \      -->    / \
#    t1  b           a   t3
#       / \         / \
#      t2  t3      t1  t2
#    
function rotate_left(t::AbstractTree, a::AbstractTreeNode)
    @assert has_right(a) "Can't rotate left if there is no right child"
    b = right_child(a)
    t2 = b.left
    swap_child_of_parent(t, a, b)
    
    set_left_child!(b, a)
    set_right_child!(a, t2)
end

function rotate_right(t::AbstractTree, b::AbstractTreeNode)
    @assert has_left(b) "Can't rotate left if there is no left child"
    a = left_child(b)
    t2 = a.right
    swap_child_of_parent(t, b, a)
    
    set_right_child!(a, b)
    set_left_child!(b, t2)
end
