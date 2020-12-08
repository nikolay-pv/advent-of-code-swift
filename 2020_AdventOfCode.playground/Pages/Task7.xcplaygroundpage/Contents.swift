//: [Previous](@previous)

import Foundation

final class WeightedGraph {
    private var edges = [Edge.IdType : Edge]()
    private var nodes = [Node.IdType : Node]()

    init<NodeCollection: Collection>(nodes: NodeCollection)
    where NodeCollection.Element == Node.IdType {
        nodes.forEach {
            self.nodes[$0] = Node(id: $0)
        }
    }

    func addEdge(from: Node.IdType, to: Node.IdType, with weight: Int) {
        guard let fromNode = nodes[from], let toNode = nodes[to] else {
            print("Can't find the nodes in the graph - skip adding edge")
            return
        }
        let edge = Edge(from: fromNode, to: toNode, weight: weight)
        edges[edge.id] = edge
        fromNode.outcoming.append(edge)
        toNode.incoming.append(edge)
    }

    // part 1
    func getParentNodes(for nodeId: Node.IdType) -> [Node.IdType] {
        guard let node = nodes[nodeId] else {
            print("Can't find the needed node in graph")
            return []
        }
        var visited = [Node.IdType]()
        node.incoming.forEach{ edge in
            edge.from.traverseUp{
                visited.append($0)
            }
        }
        return visited
    }
    // part 2
    func countWeightedChildren(for nodeId: Node.IdType) -> Int {
        guard let node = nodes[nodeId] else {
            print("Can't find the needed node in graph")
            return -1
        }
        return node.outcoming.map {
            return $0.weight * $0.to.accumulateNumberOfBags()
        }.reduce(0, +)
    }

    class Edge {
        typealias IdType = UUID
        var id = UUID()
        var from: Node
        var to: Node
        var weight: Int
        init(from: Node, to: Node, weight: Int) {
            self.from = from
            self.to = to
            self.weight = weight
        }
    }
    class Node {
        typealias IdType = String
        var id: String
        var incoming = [Edge]()
        var outcoming = [Edge]()
        init(id: String) {
            self.id = id
        }

        func traverseUp(_ closure : @escaping (Node.IdType) -> Void) {
            closure(self.id)
            incoming.forEach{
                $0.from.traverseUp(closure)
            }
        }

        func accumulateNumberOfBags() -> Int {
            if outcoming.count == 0 {
                return 1
            }
            // count self
            return 1 + outcoming.map {
                return $0.weight * $0.to.accumulateNumberOfBags()
            }.reduce(0, +)
        }
    }
}


var input = getInput().split(separator: "\n").map{ aline -> (parent: String, children: [(count: Int, id: String)]) in
    let line = String(aline)
    guard let parentBagRegex = try? NSRegularExpression(pattern: "^(\\w+ \\w+) bag"),
          let parentBagMatch = parentBagRegex.firstMatch(in: line, range: NSRange(location: 0, length: line.utf16.count))
    else {
        fatalError()
    }
    let parentId = line[Range(parentBagMatch.range(at: 1), in: line)!]
    guard let childrenRegex = try? NSRegularExpression(pattern: "(\\d+) (\\w+ \\w+) bag") else {
        fatalError()
    }
    let matches = childrenRegex.matches(in: line, range: NSRange(location: 0, length: line.utf16.count))
    var childrenIds = [(count: Int, id: String)]()
    for match in matches {
        let count = line[Range(match.range(at: 1), in: line)!]
        let bagId = line[Range(match.range(at: 2), in: line)!]
        childrenIds.append((count: Int(count)!, id: String(bagId)))
    }
    return (parent: String(parentId), children: childrenIds)
}

// MARK:- Part 1
var bags = Set(input.flatMap{ [$0.parent] + $0.children.map{ countId in countId.id } })
let bagsGraph = WeightedGraph(nodes: bags)
input.forEach{ relation in
    relation.children.forEach{ child in
        bagsGraph.addEdge(from: relation.parent, to: child.id, with: child.count)
    }
}
let parentBags = Set(bagsGraph.getParentNodes(for: "shiny gold"))
let answer = parentBags.count
//assert(149 > answer)
print("The answer is \(answer)")


// MARK:- Part 2
let newAnswer = bagsGraph.countWeightedChildren(for: "shiny gold")
print("The answer is \(newAnswer)")
//assert(20297 < newAnswer)

//: [Next](@next)
