module Core

# Export the definitions of Node and neighbors
export Node, neighbors

# Define the Node struct representing a cell in the maze
mutable struct Node
    x::Int    # x-coordinate of the cell
    y::Int    # y-coordinate of the cell
    visited::Bool    # Indicates whether the cell has been visited
    walls::Dict{Symbol, Bool} # Indicates the presence of walls: :top, :bottom, :left, :right
    Node(x, y, visited) = new(x, y, visited, Dict(:top => true, :bottom => true, :left => true, :right => true))
end

# Function to find the neighbors of a given cell
function neighbors(node::Node, nodes::Matrix{Node})
    height, width = size(nodes)
    neighbors = []
    # Check the cell to the left
    if node.x > 1
        push!(neighbors, nodes[node.y, node.x - 1])
    end
    # Check the cell to the right
    if node.x < width
        push!(neighbors, nodes[node.y, node.x + 1])
    end
    # Check the cell above
    if node.y > 1
        push!(neighbors, nodes[node.y - 1, node.x])
    end
    # Check the cell below
    if node.y < height
        push!(neighbors, nodes[node.y + 1, node.x])
    end
    return neighbors
end

end 
