# test_core.jl

using Test
include("../src/core.jl")

# Explicitly use Core.Node
using .Core: Node

# Your test cases
height = 5
width = 5
nodes = [Node(x, y, false) for y in 1:height, x in 1:width]
length(nodes) == height * width
println(nodes[1, 1] isa Node)
println(nodes)



