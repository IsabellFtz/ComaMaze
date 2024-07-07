module MazeGeneration

include("core.jl")
include("visualize.jl")

using .Core
using .Visualize

export Node, neighbors, Maze, generate_maze, visualize, solve

# Define the Maze struct
mutable struct Maze
    nodes::Matrix{Node}
    start::Node
    goal::Node
    path::Union{Vector{Node}, Nothing}
end

include("solver.jl")

using .Solver

using Random

# Outer constructor to initialize a maze with given height and width and generate the maze
function Maze(height::Int, width::Int)
    # Initialize nodes
    nodes = [Node(x, y, false) for y in 1:height, x in 1:width]
    maze = Maze(nodes, nodes[1,1], nodes[height, width], nothing)
    generate_maze!(maze)
    return maze
end

# Define directions
directions = Dict(
    "up" => (-1, 0),
    "down" => (1, 0),
    "left" => (0, -1),
    "right" => (0, 1)
)

# Define the order of directions to move: up, right, down, left
dir_order = ["up", "right", "down", "left"]

# Function to get the right direction relative to the current direction
function right_direction(current_dir::String)
    idx = findfirst(x -> x == current_dir, dir_order)
    return dir_order[mod(idx, 4) + 1]
end

function generate_maze!(maze::Maze)
    stack = []
    # Start at a random node
    start_x = rand(1:size(maze.nodes, 2))
    start_y = rand(1:size(maze.nodes, 1))
    println("Random start position: ($start_x, $start_y)")  # Debug print
    current = maze.nodes[start_y, start_x]
    current.visited = true
    maze.start = current
    push!(stack, current)
    current_dir = "down"  # Start by moving down

    while !isempty(stack)
        current = stack[end]
        neighbors_list = neighbors(current, maze.nodes)
        unvisited_neighbors = [n for n in neighbors_list if !n.visited]

        if !isempty(unvisited_neighbors)
            # Choose a random unvisited neighbor
            next_node = rand(unvisited_neighbors)
            next_node.visited = true

            # Determine the direction to the next node
            dx, dy = next_node.x - current.x, next_node.y - current.y
            if dx == 1
                current_dir = "right"
            elseif dx == -1
                current_dir = "left"
            elseif dy == 1
                current_dir = "down"
            elseif dy == -1
                current_dir = "up"
            end

            # Debug prints
            println("Current Node: $(current.x), $(current.y)")
            println("Current Direction: $current_dir")
            println("Right Direction: $(right_direction(current_dir)), Right Index: $(mod(findfirst(x -> x == current_dir, dir_order), 4) + 1)")

            # Remove the wall between current and next_node
            if next_node.x == current.x + 1
                current.walls[:right] = false
                next_node.walls[:left] = false
            elseif next_node.x == current.x - 1
                current.walls[:left] = false
                next_node.walls[:right] = false
            elseif next_node.y == current.y + 1
                current.walls[:bottom] = false
                next_node.walls[:top] = false
            elseif next_node.y == current.y - 1
                current.walls[:top] = false
                next_node.walls[:bottom] = false
            end

            push!(stack, next_node)
        else
            pop!(stack)
        end
    end

    # Set a random end node
    end_x = rand(1:size(maze.nodes, 2))
    end_y = rand(1:size(maze.nodes, 1))
    println("Random end position: ($end_x, $end_y)")  # Debug print
    maze.goal = maze.nodes[end_y, end_x]
end



# Overload the Base.show function for Maze to include visualization
function Base.show(io::IO, maze::Maze)
    solve(maze)
    visualize(maze.nodes, maze.start, maze.goal, maze.path)
end

end # module MazeGeneration
