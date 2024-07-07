# test_maze_generation.jl
using Random
using Dates

# Get the current time in milliseconds since the epoch
current_time = now()
timestamp = convert(Int, round(Dates.value(current_time) / 1000))

# Seed the random number generator with the current timestamp
Random.seed!(timestamp)

using Test
include("../src/MazeGeneration.jl")

using .MazeGeneration

# Function to print out nodes and their walls
function print_maze_walls(maze::Maze)
    height, width = size(maze.nodes)
    for y in 1:height
        for x in 1:width
            node = maze.nodes[y, x]
            print("Node ($x, $y): ")
            for (wall, exists) in node.walls
                print("$wall=$(exists) ")
            end
            println()
        end
    end
end

# Test Maze Generation and Visualization
@testset "Maze Generation and Visualization Tests" begin
    height = 5
    width = 5
    maze = Maze(height, width)

    # Check that all nodes are visited
    all_visited = all(node -> node.visited, maze.nodes)
    @test all_visited == true

    # Check that the maze dimensions are correct
    @test size(maze.nodes, 1) == height
    @test size(maze.nodes, 2) == width

    # Print out the nodes and their walls
    println("Maze Nodes and Walls:")
    print_maze_walls(maze)

    # Test visualization
    println("Maze Visualization:")
    println(maze)  # This will call the overloaded Base.show function
end
