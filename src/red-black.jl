is_black(n::TreeNode) = n.black
is_red(n::TreeNode) = !is_black(n)

is_left_black(n::TreeNode) = isnull(n.left) || is_black(left_child(n))
is_right_black(n::TreeNode) = isnull(n.right) || is_black(right_child(n))

"`have_two_blacks(n::TreeNode)` Check if both children are black. In which case node should be red"
have_two_blacks(n::TreeNode) = is_left_black(n) && is_right_black(n)