module Solver

using ..Core: Node
using ..MazeGeneration: Maze

export solve


# Function to solve the maze using the right-hand rule
function solve(maze::Maze)
    current = maze.start
    goal = maze.goal
    path = [current]
    # visualize_path(maze.nodes, maze.start, maze.goal, path)

    # Directions in order of preference: right, down, left, up
    directions = Dict("right" => (0, 1), "down" => (1, 0), "left" => (0, -1), "up" => (-1, 0))
    direction_order = ["right", "up", "left", "down"] #counter clock wise
    current_direction = "up"
    stuck_counter = 0
    max_stuck_counter = 9
     
    while !(current.x == goal.x && current.y == goal.y)
        # println("Current Node: $(current.x), $(current.y)")
        # println("Facing Direction: $current_direction")

        # Try to turn right
        d = findfirst(direction -> direction == current_direction, direction_order) # gegen Uhrzeiger 
        # ugly but it works :)
        if d == 1 
            right_idx = 4
        elseif d == 2 
            right_idx = 1
        elseif d == 3
            right_idx = 2
        elseif d == 4 
            right_idx = 3
        end
        loc_right = direction_order[right_idx]
        next_cell = move(current, directions[loc_right], maze.nodes)

        # println("Right of Facing Direction: $loc_right")

        if !isnothing(next_cell) && can_move(current, next_cell) 
            # println("Action: Can move right.")
            current_direction = loc_right
            current = next_cell
            push!(path, current)
            stuck_counter = 0
            # visualize_path(maze.nodes, maze.start, maze.goal, path)

        else # Turn counter-clockwise 
            # println("Action: Turn.")
            stuck_counter +=1
            d = findfirst(direction -> direction == current_direction, direction_order) # counter clockwise
            # ugly but it works :)
            if d == 1 
                direction_index = 2
            elseif d == 2 
                direction_index = 3
            elseif d == 3
                direction_index = 4
            elseif d == 4 
                direction_index = 1
            end
            current_direction = direction_order[direction_index]
        end

        # If stuck in loop, break out
        if stuck_counter > max_stuck_counter
            println("Stuck in a loop, breaking out")
            break
        end

    end
    maze.path = path
    maze.path = shortestpath(path)
    return path
end

# Function to find the shortest path by removing cycles
function shortestpath(path::Vector{Node})
    seen_nodes = Dict{Node, Int}()
    i = 1
    while i <= length(path)
        node = path[i]
        if haskey(seen_nodes, node)
            start_idx = seen_nodes[node]
            end_idx = i - 1
            # println("Removing cycle from index $start_idx to $end_idx")
            splice!(path, start_idx:end_idx)
            i = start_idx # reset to the position where the cycle started
            empty!(seen_nodes) # reset seen_nodes as the indices have changed
            for j in 1:i-1
                seen_nodes[path[j]] = j
            end
        else
            seen_nodes[node] = i
            i += 1
        end
    end
    return path
end


 
# Helper function to move in the given direction
function move(node::Node, direction::Tuple{Int, Int}, nodes::Matrix{Node})
    y, x = node.y + direction[1], node.x + direction[2]
    if y > 0 && y <= size(nodes, 1) && x > 0 && x <= size(nodes, 2)
        return nodes[y, x]
    else
        return nothing
    end
end

# Helper function to check if the move is possible
function can_move(current::Node, next_node::Node)
    if next_node.x == current.x + 1
        return !current.walls[:right]
    elseif next_node.x == current.x - 1
        return !current.walls[:left]
    elseif next_node.y == current.y + 1
        return !current.walls[:bottom]
    elseif next_node.y == current.y - 1
        return !current.walls[:top]
    end
    return false
end

end 
