//: [Previous](@previous)

import Foundation

var input = "963275481".map{ Int(String($0))! }


// MARK:- Part 1
var part1Game = Game(input, gameSize: 9)
part1Game.play(roundsCount: 100)
let answer = part1Game.printFirst(8)
print("The answer to the first part: \(answer)")


// MARK:- Part 2
var part2Game = Game(input, gameSize: 1000000)
part2Game.play(roundsCount: 10000000)
let newAnswer = part2Game.getTwoFollowingOne()
print("The answer to the second part: \(newAnswer.0 * newAnswer.1)")

//: [Next](@next)
