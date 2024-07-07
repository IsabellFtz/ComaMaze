include("../src/core.jl")
include("../src/visualize.jl")

using .Core
using .Visualize

# Create a 4x4 grid of nodes
nodes = [Node(x, y, false) for y in 1:4, x in 1:4]

# Mark some nodes as visited and modify walls for testing
nodes[2, 2].visited = true
nodes[2, 2].walls[:right] = false
nodes[2, 3].visited = true
nodes[2, 3].walls[:left] = false

nodes[3, 3].visited = true
nodes[3, 3].walls[:top] = false
nodes[2, 3].walls[:bottom] = false

# Define start and goal nodes
start_node = nodes[1, 1]
goal_node = nodes[4, 4]

# Visualize the nodes (no path provided)
visualize(nodes, start_node, goal_node, Node[])

# Optionally, you can define a path for testing
path = [nodes[1, 1], nodes[2, 1], nodes[3, 1], nodes[3, 2], nodes[3, 3], nodes[4, 3], nodes[4, 4]]

# Visualize the nodes with the path
visualize(nodes, start_node, goal_node, path)
