//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: ",").map{ Int($0)! }

// MARK:- Part 1
var numIterations = 2020
let answer = runGame(input: input, forIterations: numIterations)
print("The answer is \(answer)")
assert(662 == answer)


// MARK:- Part 2
numIterations = 30000000
let newAnswer = runGame(input: input, forIterations: numIterations)
print("The answer is \(newAnswer)")

//: [Next](@next)
