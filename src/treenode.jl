import Base: search, show

export  TreeNode,
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
