//: [Previous](@previous)

import Foundation
import CryptoKit

func computeHash(input: String, suffix: Int) -> String {
    let data = "\(input)\(suffix)"
    return String(Insecure.MD5.hash(data: data.data(using: .ascii)!).description.split(separator: " ").last!)
}

var input = getInput()

// MARK:- Part 1 & 2
var part1: Int?
var part2: Int?

for suffix in 254574..<1100000 {
    let r = computeHash(input: input, suffix: suffix)
    if (r.starts(with: "00000") && part1 == nil) {
        part1 = suffix
        print(suffix)
    }
    if (r.starts(with: "000000") && part2 == nil) {
        part2 = suffix
        print(suffix)
    }
    if (part1 != nil && part2 != nil) {
        break
    }
}

//: [Next](@next)
