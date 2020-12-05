//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: "\n")

// MARK:- Part 1
// Count # in positions 3 * row
let rowLen = input.first!.count
var treeCount = input.enumerated().compactMap{ $1[$0 * 3 % rowLen] == "#" ? 1 : nil }.count
print("Number of trees on the way is \(treeCount)")

// MARK:- Part 2
// Count # on multiple patterns
struct DescentAngle : Hashable {
    var right: Int
    var down: Int
}
var patterns = [DescentAngle(right: 1, down: 1): 0,
                DescentAngle(right: 5, down: 1): 0,
                DescentAngle(right: 7, down: 1): 0,
                DescentAngle(right: 1, down: 2): 0]

input.enumerated().map{ row, line in
    for key in patterns.keys {
        if (row % key.down == 0 && line[(row / key.down) * key.right % rowLen] == "#") {
            patterns[key]! += 1
        }
    }
}
patterns[DescentAngle(right: 3, down: 1)] = treeCount // has been found already

let multiplePatterns = patterns.values.reduce(1, *)
assert(multiplePatterns != 4997836800)
print("Multiplied number of trees encountered on each of the slopes = \(multiplePatterns)")

//: [Next](@next)
