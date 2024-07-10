module Visualize

using ..Core: Node

export visualize


#Funktion zur Visualisierung von Mazes und gegebenen Pfaden(meistens die Lösungspfade)
function visualize(nodes::Matrix{Node}, start::Node, goal::Node, path::Vector{Node} = Node[])
    height, width = size(nodes)
    println("Visualizing the maze:")

    for y in 1:height
        #Visualisierung der horizontalen Wände
        for x in 1:width
            node = nodes[y, x]
            print(node.walls[:top] ? "+---" : "+   ")
        end
        println("+")
        #Visualisierung der vertikalen Wände
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

    #Die unterste Wand
    for x in 1:width
        print("+---")
    end
    println("+")
end

function visualize(nodes::Matrix{Node}, start::Node, goal::Node)
    height, width = size(nodes)
    println("Visualizing the maze:")

    for y in 1:height
        for x in 1:width
            node = nodes[y, x]
            print(node.walls[:top] ? "+---" : "+   ")
        end
        println("+")
        
        for x in 1:width
            node = nodes[y, x]
            print(node.walls[:left] ? "| " : "  ")
            if node == start
                print("Ⓢ ")
            elseif node == goal
                print("☆ ")
            else
                print("  ")
            end
        end
        println("|")
    end

    for x in 1:width
        print("+---")
    end
    println("+")
end

end 
