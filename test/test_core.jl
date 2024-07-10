include("../src/core.jl")
using .Core: neighbors
using .Core: Node

# Create grid of nodes
nodes = [Node(x, y, false) for y in 1:5, x in 1:5]

# Determine size of grid
height, width = size(nodes)

# Print coordinates of each node 
println("Coordinates of all nodes:")
for y in 1:height
    for x in 1:width
        println("Node at (x, y): (", nodes[y, x].x, ", ", nodes[y, x].y, ")")
    end
end

# Select test node 
node = nodes[2, 5]

# Get neighbors of test node
neighbors_list = neighbors(node, nodes)

# Print coordinates of test node and its neighbors
println("\nSelected test node (x, y): (", node.x, ", ", node.y, ")")
println("Neighbors of selected node:")
for neighbor in neighbors_list
    println("Neighbor at (x, y): (", neighbor.x, ", ", neighbor.y, ")")
end
