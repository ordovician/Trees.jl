import Base: search, show

export  AbstractTreeNode,
        TreeNode,
        node_key,
        node_value,
        left_child,
        right_child,
        has_left,
        has_right,
        add!,
        search

abstract AbstractTreeNode{K, V}

"A tree node with a key and value"
type TreeNode{K, V} <:  AbstractTreeNode{K, V}
    key::K
    value::V

    parent::Nullable{TreeNode{K, V}}
    left::Nullable{TreeNode{K, V}}
    right::Nullable{TreeNode{K, V}}

    black::Bool
    function TreeNode(key::K, value::V)
        null = Nullable{TreeNode{K, V}}()
        new(key, value, null, null, null, true)
    end
end

TreeNode{K, V}(key::K, value::V) = TreeNode{K, V}(key, value)

"Key is the value we use to index our data with in the tree"
node_key{K, V}(n::AbstractTreeNode{K, V})   = n.key

"The value we are storing in the tree which we retrieve by giving its key"
node_value{K, V}(n::AbstractTreeNode{K, V}) = n.value
node_parent(n::AbstractTreeNode) = get(n.parent)
left_child(n::AbstractTreeNode)  = get(n.left)
right_child(n::AbstractTreeNode) = get(n.right)

function set_parent!(child::AbstractTreeNode, parent::AbstractTreeNode)
  child.parent = Nullable(parent)
end

function detach_left_child{K, V}(parent::AbstractTreeNode{K, V})
    if has_left(parent)
        left_child(parent).parent = Nullable{eltype(parent)}()
    end
end

function detach_right_child{K, V}(parent::AbstractTreeNode{K, V})
    if has_right(parent)
        right_child(parent).parent = Nullable{eltype(parent)}()
    end
end


"Give the parent node a left child node, updating parent pointer and existing left child"
function set_left_child!{K, V}(parent::AbstractTreeNode{K, V}, child::AbstractTreeNode{K, V})
    detach_left_child(parent)
    parent.left = Nullable(child)
    child.parent = Nullable(parent)
end

function set_left_child!{K, V}(parent::AbstractTreeNode{K, V}, child::Nullable{AbstractTreeNode{K, V}})
    if !isnull(child)
        set_left_child!(parent, get(child))
    else
        detach_left_child(parent)
        parent.left = child
        child.parent = Nullable(parent)        
    end
end

"Give the parent node a right child node, updating parent pointer and existing right child"
function set_right_child!{K, V}(parent::AbstractTreeNode{K, V}, child::AbstractTreeNode{K, V})
    detach_right_child(parent)
    parent.right = Nullable(child)
    child.parent = Nullable(parent)
end

function set_right_child!{K, V}(parent::AbstractTreeNode{K, V}, child::Nullable{AbstractTreeNode{K, V}})
    if !isnull(child)
        set_right_child!(parent, get(child))
    else
        detach_right_child(parent)
        parent.right = child
        child.parent = Nullable(parent)        
    end
end

has_parent(n::AbstractTreeNode) = !isnull(n.parent)

"Does tree node have a left child?"
has_left(n::AbstractTreeNode) = !isnull(n.left)

"Does tree node have a right child?"
has_right(n::AbstractTreeNode) = !isnull(n.right)

"Does the tree node have any children at all?"
has_children(n::AbstractTreeNode) = has_left(n) || has_right(n)

function show(io::IO, n::AbstractTreeNode, depth::Integer)
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

function show{K, V}(io::IO, node_or_null::Nullable{AbstractTreeNode{K, V}}, depth::Integer)
  if isnull(node_or_null)
    print(io, "  "^depth)
    println(io, "null")
  else
    show(io, get(node_or_null), depth)
  end
end

function show{K, V}(io::IO, n::AbstractTreeNode{K, V})
  if has_children(n)
    show(io, n, 1)
  else
    print(io, "AbstractTreeNode(", node_key(n), ", ", node_value(n),")")
  end
end

"""
Adds or replaces a node.
If node with given key already exists,
it will replace previous value in that node.
"""
function add!{K, V}(root::AbstractTreeNode{K, V}, child::AbstractTreeNode{K, V})
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
function search{K, V}(root::AbstractTreeNode{K, V}, key::K)
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
	Nullable{eltype(root)}()
end

