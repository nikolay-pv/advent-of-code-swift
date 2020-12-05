//: [Previous](@previous)

import Foundation

struct Password {
    var countMin: Int
    var countMax: Int
    var targetLetter: Character
    var password: String

    func validate() -> Bool {
        let count = password.compactMap{ $0 == targetLetter ? targetLetter : nil }.count
        return countMin <= count && count <= countMax
    }

    // treat countMin and countMax as positional arguments now
    func validate2() -> Bool {
        var hasFirst = false
        var hasSecond = false
        for (i, c) in password.enumerated() {
            if (i == countMin - 1) {
                hasFirst = c == targetLetter
            } else if (i == countMax - 1) {
                hasSecond = c == targetLetter
                break
            }
        }
        return hasFirst != hasSecond
    }
}

func createPassword(line: String) -> Password? {
    guard let regex = try? NSRegularExpression(pattern: "^(\\d+)-(\\d+) (\\w): (\\w+)$") else {
        return nil
    }
    let matches = regex.matches(in: line, range: NSRange(location: 0, length: line.utf16.count))
    let entireGroup = matches[0]

    guard let min = Int(line[Range(entireGroup.range(at: 1), in: line)!]),
          let max = Int(line[Range(entireGroup.range(at: 2), in: line)!]),
          let target = line[Range(entireGroup.range(at: 3), in: line)!].first
    else {
        return nil
    }
    let pass = line[Range(entireGroup.range(at: 4), in: line)!]
    return Password(countMin: min, countMax: max, targetLetter: target, password: String(pass))
}

var input = getInput().split(separator: "\n").compactMap{ createPassword(line: String($0)) }

// MARK:- Part 1

let numberOfValid = input.reduce(0) { $0 + ($1.validate() ? 1 : 0) }
print("Number of valid passwords \(numberOfValid)")

// MARK:- Part 2
// treat countMin and countMax as positional arguments now
let numberOfValid2 = input.reduce(0) { $0 + ($1.validate2() ? 1 : 0) }
assert(numberOfValid2 != 395)
print("Number of valid passwords according to second rule \(numberOfValid2)")

//: [Next](@next)
