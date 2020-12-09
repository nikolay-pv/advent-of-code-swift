//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: "\n").map{ Int($0)! }

// MARK:- Part 1
func searchFistNumber(in numbers: [Int], withPreamble preamble: Int = 25) -> Int {
    guard numbers.count > preamble else {
        return -1
    }
    var components = Set(numbers[..<preamble])
    for (i, num) in numbers[preamble...].enumerated() {
        let differences = components.map{ num - $0 }
        if components.intersection(differences).count <= 1 { // single match is not enough
            return num
        }
        // rotate the preamble
        components.remove(numbers[i])
        components.insert(num)
    }
    return -1
}
let answer = searchFistNumber(in: input)
print("The answer is \(answer)")
assert(177777905 == answer)


// MARK:- Part 2
func searchContiguousRange(in numbers: [Int], withSum: Int) -> Int {
    let maxIndx = numbers.firstIndex{ $0 > withSum }!
    for min in 0...maxIndx {
        for max in (min...maxIndx).reversed() {
            let subrange = numbers[min...max]
            let sum = subrange.reduce(0, +)
            if sum == withSum {
                return subrange.min()! + subrange.max()!
            } else if sum < withSum { // speed up, no need to reduce upper boundary if we can't get the sum
                break
            }
        }
    }
    return -1
}
let newAnswer = searchContiguousRange(in: input, withSum: answer)
print("The answer is \(newAnswer)")
assert(15566425 < newAnswer)
assert(23463012 == newAnswer)


//: [Next](@next)
