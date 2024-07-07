module Visualize

using ..Core: Node

export MazeViz, visualize

# Define the MazeViz struct containing the visualization of the maze
struct MazeViz
    # Add fields for visualization (empty for now)
end

# Function to visualize the maze in the terminal
function visualize(nodes::Matrix{Node}, start::Node, goal::Node, path::Vector{Node} = Node[])
    height, width = size(nodes)
    println("Visualizing the maze:")

    for y in 1:height
        # Top border
        for x in 1:width
            node = nodes[y, x]
            print(node.walls[:top] ? "+---" : "+   ")
        end
        println("+")
        # Left border and cell content
        for x in 1:width
            node = nodes[y, x]
            print(node.walls[:left] ? "| " : "  ")
            if node == start
                print("Ⓢ ")
            elseif node == goal
                print("☆ ")
            elseif node in path
                print("• ")
            else
                print("  ")
            end
        end
        println("|")
    end

    # Bottom border
    for x in 1:width
        print("+---")
    end
    println("+")
end

end # module Visualize
