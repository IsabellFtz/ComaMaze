module MazeGeneration

include("core.jl")
include("visualize.jl")

using .Core
using .Visualize

export Node, neighbors, Maze, generate_maze, visualize, solve

# Defnition von Maze
mutable struct Maze
    nodes::Matrix{Node}
    start::Node
    goal::Node
    path::Union{Vector{Node}, Nothing}
end

include("solver.jl")
using .Solver
using Random

# Konstruktor für eine Basis Maze. Diese Basis Maze wird benutzt um einen zufääligen labyrinth zu generieren
function Maze(height::Int, width::Int)
    nodes = [Node(x, y, false) for y in 1:height, x in 1:width]
    maze = Maze(nodes, nodes[1,1], nodes[height, width], nothing)
    generate_maze!(maze)
    return maze
end



#Generiert aus einer Basis Maze einen richtigen Labyrinth
function generate_maze!(maze::Maze)
    stack = []
    #Zufällig Wahl des Startpunktes
    start_x = rand(1:size(maze.nodes, 2))
    start_y = rand(1:size(maze.nodes, 1))
    
    #Nutze den Startpunkt als ersten Knoten
    current = maze.nodes[start_y, start_x]
    
    #Ziel ist es alles Nodes mindestens einmal besucht zu haben
    current.visited = true
    maze.start = current
    push!(stack, current)
    
    #Solange der Vektor stack nichtleer ist wird der Algorithmus ausgeführt
    #Wenn der leer ist, dann wurden alle Nodes rausgepoppt, da alle keine unbesuchbaren Nachbarn mehr hatten  
    while !isempty(stack)
        current = stack[end]
        neighbors_list = neighbors(current, maze.nodes)
        unvisited_neighbors = [n for n in neighbors_list if !n.visited]

        if !isempty(unvisited_neighbors)

            #Zufällige Wahl eines unbesuchten Nachbarns
            next_node = rand(unvisited_neighbors)
            next_node.visited = true

            #Entfernen der Wand zwischen Current Node und Nachbarn
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

    #Setze ein zufälliges Ziel
    end_x = rand(1:size(maze.nodes, 2))
    end_y = rand(1:size(maze.nodes, 1))
    #Um sicher zu stellen dass Start und Ende nicht gleich sein können
    while end_x == start_x && end_y == start_y
        end_x = rand(1:size(maze.nodes, 2))
        end_y = rand(1:size(maze.nodes, 1))
    end
    
    maze.goal = maze.nodes[end_y, end_x]
end



# Überladung der Base.Show Funktion für die Visualisierung der Labyrinthen
function Base.show(io::IO, maze::Maze)
    solve(maze)
    visualize(maze.nodes, maze.start, maze.goal, maze.path)
end

end 
