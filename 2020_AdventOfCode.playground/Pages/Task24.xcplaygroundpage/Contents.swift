//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: "\n").map{line -> [HexPoint.Direction: Int] in
    var dict = HexPoint.Direction.defaultDict
    tokenise(String(line)).forEach{
        dict[HexPoint.Direction(rawValue: $0)!]! += 1
    }
    dict = removeRedundant(dict)
    return dict
}

// MARK:- Part 1
var allFlipped = Set<HexPoint>()
for directions in input {
    let newPosition = directions.map{ $0.getVector() * $1 }.reduce(HexPoint.zero, +)
    let tile = allFlipped.firstIndex(of: newPosition)
    if tile != nil {
        allFlipped.remove(at: tile!)
    } else {
        allFlipped.insert(newPosition)
    }
}
let answer = allFlipped.count
print("The answer is \(answer)")

assert(511 > answer)

// MARK:- Part 2
var floor = allFlipped
let simulation = simulate(floor, for: 100)
simulation.enumerated().forEach({
    print("Day \($0 + 1): \($1)")
})
let newAnswer = simulation.last!
print("The answer is \(newAnswer)")

//: [Next](@next)
