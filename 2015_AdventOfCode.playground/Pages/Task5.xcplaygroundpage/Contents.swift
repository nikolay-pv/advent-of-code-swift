//: [Previous](@previous)

import Foundation

func isNice(_ str: String.SubSequence) -> Bool {
    let targetVowels = "aeiou"
    if (str.compactMap{ targetVowels.contains($0) ? 1 : nil }.reduce(0, +) < 3) {
        return false
    }
    let forbiddenPairs = ["ab", "cd", "pq", "xy"]
    var doubles : Bool = false
    for (a, b) in zip(str, str.dropFirst()) {
        if (forbiddenPairs.contains("\(a)\(b)")) {
            return false
        }
        if (a == b) {
            doubles = true
        }
    }
    for (a, b) in zip(str.dropFirst(), str.dropFirst(2)) {
        if (forbiddenPairs.contains("\(a)\(b)")) {
            return false
        }
        if (a == b) {
            doubles = true
        }
    }
    return doubles
}

var input = getInput().split(separator: "\n")

// MARK:- Part 1
var niceCount = input.compactMap{ isNice($0) ? 1 : nil }.reduce(0, +)
print("There are \(niceCount) strings")

func isNicer(_ str: String.SubSequence) -> Bool {
    guard let regex = try? NSRegularExpression(pattern: "(\\w\\w).*\\1") else {
        return false
    }
    let rule1 = regex.firstMatch(in: String(str), options: [], range: NSRange(location: 0, length: str.utf16.count)) != nil
    guard let regex2 = try? NSRegularExpression(pattern: "(\\w)\\w\\1") else {
        return false
    }
    let rule2 = regex2.firstMatch(in: String(str), options: [], range: NSRange(location: 0, length: str.utf16.count)) != nil
    return rule1 && rule2
}

// MARK:- Part 2
var nicestCount = input.compactMap{ isNicer($0) ? 1 : nil }.reduce(0, +)
print("There are \(nicestCount) nicest strings")

//: [Next](@next)
