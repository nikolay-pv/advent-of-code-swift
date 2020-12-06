//: [Previous](@previous)

import Foundation

// added ; instead of empty lines
var input = getInput().split(separator: ";")

// MARK:- Part 1
let totalNumberOfYes = input.reduce(0) { result, groupAnswers in
    let differentAnswers = Set(groupAnswers.replacingOccurrences(of: "\n", with: "")).count
    return result + differentAnswers
}
print("The number of yes answers across the groups is \(totalNumberOfYes)")
assert(6549 == totalNumberOfYes)


// MARK:- Part 2
let leastNumberOfYes = input.reduce(0) { result, groupAnswers in
    let parsedAnswers = groupAnswers.split(separator: "\n").map{ Set($0) }
    let sameAnswers = parsedAnswers.dropFirst().reduce(parsedAnswers.first!) { $0.intersection($1) }.count
    return result + sameAnswers
}
print("The sum of intersection of yes answers across the groups is \(leastNumberOfYes)")
assert(3466 == leastNumberOfYes)

//: [Next](@next)
