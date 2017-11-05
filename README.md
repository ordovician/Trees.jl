# Trees
An implementation of a binary search tree. It is intended to be a red-black tree, but the code for balancing the tree is in a separate branch and not finnished. 

It has been designed to have a dictionary interface. So you can create a tree like this:

    t = Tree("one" => 1, "two" => 2, "three" => 3)
    
And add extra elements like this:

    t["four"] = 4
    t["one"] = 10
    
The code was written for Julia v0.5, and has not yet been updated to v0.6 syntax.

[![Build Status](https://travis-ci.org/ordovician/Trees.jl.svg?branch=master)](https://travis-ci.org/ordovician/Trees.jl)

[![Coverage Status](https://coveralls.io/repos/ordovician/Trees.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/ordovician/Trees.jl?branch=master)

[![codecov.io](http://codecov.io/github/ordovician/Trees.jl/coverage.svg?branch=master)](http://codecov.io/github/ordovician/Trees.jl?branch=master)
