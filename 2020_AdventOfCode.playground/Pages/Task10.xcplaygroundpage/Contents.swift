//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: "\n").map{ Int($0)! }

// MARK:- Part 1
// add the device and outlet joltages
let adapters = (input + [0, input.max()! + 3]).sorted()
let diffs = zip(adapters.dropFirst(), adapters.dropLast()).map{ $0 - $1 }
let countDiffs = diffs.reduce(into: [Int: Int]()) { $0[$1] = ($0[$1] ?? 0) + 1 }
print(countDiffs)
let answer = countDiffs[1]! * countDiffs[3]!
print("The answer is \(answer)")


// MARK:- Part 2
var ways = [1, 1] + Array(repeating: 0, count: adapters.count - 2)
for i in 2..<ways.count {
    for j in max(i - 3, 0)..<i {
        ways[i] += adapters[i] - adapters[j] <= 3 ? ways[j] : 0
    }
}
let newAnswer = ways.last!
print("The answer is \(newAnswer)")


//: [Next](@next)
