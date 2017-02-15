module Trees

import Base: isempty, getindex, setindex!, search

export  Tree,
        TreeNode,
        node_key,
        node_value,
        left_node,
        right_node,
        has_left,
        has_right

"A tree node with a key and value"
type TreeNode{K, V}
  key::K
  value::V

  left::Nullable{TreeNode{K, V}}
  right::Nullable{TreeNode{K, V}}

  function TreeNode(key::K, value::V)
    new(key,
        value,
        Nullable{TreeNode{K, V}}(),
        Nullable{TreeNode{K, V}}())
  end
end

TreeNode{K, V}(key::K, value::V) = TreeNode{K, V}(key, value)

node_key{K, V}(n::TreeNode{K, V})   = n.key
node_value{K, V}(n::TreeNode{K, V}) = n.value
left_node(n::TreeNode)  = get(n.left)
right_node(n::TreeNode) = get(n.right)

has_left(n::TreeNode) = !isnull(n.left)
has_right(n::TreeNode) = !isnull(n.right)

function add{K, V}(root::TreeNode{K, V}, child::TreeNode{K, V})
  if node_key(child) == node_key(root)
    root.value = node_value(child)
  elseif node_key(child) < node_key(root)
    if has_left(root)
      add(left_node(root), child)
    else
      root.left = node
    end
  else
    if has_right(root)
        add(right_node(root))
      else
        root.right = node
    end
  end
end

function search{K, V}(root::TreeNode{K, V}, key::K)
  if node_key(root) == key
		return Nullable(root)
	elseif value < root.value
		if hasleft(root)
			return search(root.left, value)
		end
	else
		if hasright(root)
			return search(root.right, value)
		end
	end
	Nullable{TreeNode{k, V}}()
end

type Tree{K, V}
  root::Nullable{TreeNode{K,V}}
  Tree{K, V}(root::TreeNode{K,V}) = new(Nullable(root))
  Tree() = new(Nullable{TreeNode{K,V}}())
end

function Tree{K,V}(ps::Pair{K,V}...)
  k, v = ps[1]
  root = TreeNode(k, v)
  for (k, v) in ps[2:end]
    n = TreeNode(k, v)
    add(root, n)
  end
  Tree{K, V}(root)
end

isempty(t::Tree) = isnull(t.root)

function getindex{K,V}(t::Tree{K,V}, key::K)
  if isnull(t.root)
    throw(KeyError(key))
  else
    search(get(t.root), key)
  end
end

function setindex!{K, V}(t::Tree{K, V}, value::V, key::K)
  if isnull(t.root)
    t.root = Nullable(TreeNode(key, value))
  else
    root = get(t.root)
    add(root, TreeNode(key, value))
  end
end

end # module
