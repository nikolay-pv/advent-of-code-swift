//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: "\n").map{ Command(line: $0) }

// MARK:- Part1
// solution is moved to sources to speedup
var litNumber = countLitLamps(for: input)
assert(416 < litNumber)
assert(293449 < litNumber)
print("Number of lit lights is \(litNumber)")
assert(377891 == litNumber)

// MARK:- Part2
var totalBrightness = computeBrightness(for: input)
print("Total brightness is \(totalBrightness)")
assert(14110788 == totalBrightness)

//: [Next](@next)
