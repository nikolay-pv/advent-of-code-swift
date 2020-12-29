//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: ";")
print(input)
let first = input.first!.split(separator: "\n").filter{ !$0.contains("Player") }.map{ Int($0)! }
let second = input.last!.split(separator: "\n").filter{ !$0.contains("Player") }.map{ Int($0)! }

//// MARK:- Part 1
let game = Game(first: first, second: second)
let answer = game.playGame()
print("The answer is \(answer)")

// MARK:- Part 2
var recursive = RecursiveGame(first: first, second: second)
let newAnswer = recursive.playGame().1
assert(newAnswer < 133565)
assert(7066 < newAnswer)
print("The answer is \(newAnswer)")

//: [Next](@next)
