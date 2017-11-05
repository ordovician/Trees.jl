type RBTreeNode{K, V} <:  AbstractTreeNode{K, V}
    key::K
    value::V

    parent::Nullable{RBTreeNode{K, V}}
    left::Nullable{RBTreeNode{K, V}}
    right::Nullable{RBTreeNode{K, V}}

    black::Bool
    function RBTreeNode(key::K, value::V)
        null = Nullable{RBTreeNode{K, V}}()
        new(key, value, null, null, null, true)
    end
end


is_black(n::RBTreeNode) = n.black
is_red(n::RBTreeNode) = !is_black(n)

is_left_black(n::RBTreeNode) = isnull(n.left) || is_black(left_child(n))
is_right_black(n::RBTreeNode) = isnull(n.right) || is_black(right_child(n))

"`have_two_blacks(n::TreeNode)` Check if both children are black. In which case node should be red"
have_two_blacks(n::RBTreeNode) = is_left_black(n) && is_right_black(n)

"Give the parent node a left child node, updating parent pointer and existing left child"
function set_left_child!{K, V}(parent::RBTreeNode{K, V}, child::RBTreeNode{K, V})
    detach_left_child(parent)
    parent.left = Nullable(child)
    child.parent = Nullable(parent)
end


"Give the parent node a right child node, updating parent pointer and existing right child"
function set_right_child!{K, V}(parent::RBTreeNode{K, V}, child::RBTreeNode{K, V})
    detach_right_child(parent)
    parent.right = Nullable(child)
    child.parent = Nullable(parent)
end



"""
Adds or replaces a node.
If node with given key already exists,
it will replace previous value in that node.
"""
function add!{K, V}(root::RBTreeNode{K, V}, child::RBTreeNode{K, V})
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