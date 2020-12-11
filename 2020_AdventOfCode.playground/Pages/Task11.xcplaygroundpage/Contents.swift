//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: "\n")

// MARK:- Part 1
var ss = SeatingSystem(input: input, neighbourTolerance: 4, for: .part1)
ss.runSimulation()
let answer = ss.occupiedSeatsCount
print("The answer is \(answer)")

// MARK:- Part 2
var ss2 = SeatingSystem(input: input, neighbourTolerance: 5, for: .part2)
ss2.runSimulation()
let newAnswer = ss2.occupiedSeatsCount
print("The answer is \(newAnswer)")


//: [Next](@next)
