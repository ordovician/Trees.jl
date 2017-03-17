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