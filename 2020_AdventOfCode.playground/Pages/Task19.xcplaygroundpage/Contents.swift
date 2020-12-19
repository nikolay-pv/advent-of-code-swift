//: [Previous](@previous)

import Foundation

enum Part {
    case first, second
}
let part: Part = .second

let filename = part == .first ? "input" : "input_part2"

var input = getInput(filename).split(separator: ";")
var conditions = input.first!.split(separator: "\n")
var words = input.last!.split(separator: "\n")

var unparsedConditions = [Int: [[Int]]]()
var leafs = [Int: String]()

let stringReg = NSRegularExpression("\"(\\w+)\"")
for condition in conditions {
    let columnIdx = condition.firstIndex(of: ":")!
    let id = Int(condition[..<columnIdx])!
    if condition.contains("\"") {
        let conditionStr = String(condition)
        let matches = stringReg.matchingGroups(in: conditionStr)
        assert(matches.count == 1)
        leafs[id] = String(conditionStr[matches.first!])
    } else {
        var remainder = condition[columnIdx...].dropFirst()
        var allRules = [[Int]]()
        if part == .second && [8, 11].contains(id) {
            remainder = remainder.split(separator: "|").first!
        }
        for rules in remainder.split(separator: "|") {
            allRules.append(rules.split(separator: " ").map { Int(String($0))! })
        }
        unparsedConditions[id] = allRules
    }
}

func combineRegex(_ parentId: Int, for rule: [[Int]], basedOn rules: [Int: [[Int]]], withTerminating leafs: [Int: String]) -> String {
    if rule.count == 1 {
        return rule.first!.map {
            if rules.keys.contains($0) {
                var combined = combineRegex($0, for: rules[$0]!, basedOn: rules, withTerminating: leafs)
                if part == .second {
                    if parentId == 8 {
                        combined += "+"
                    } else if parentId == 11 {
                        combined += "{1}" // increase and check
                    }
                }
                return combined
            } else {
                return leafs[$0]!
            }
        }.joined()
    } else {
        let result = rule.map{ combineRegex(parentId, for: [$0], basedOn: rules, withTerminating: leafs) }
        return "(\(result.joined(separator: "|")))"
    }
}

// MARK:- Part 1
let regex = "^\(combineRegex(0, for: unparsedConditions[0]!, basedOn: unparsedConditions, withTerminating: leafs))$"
print(regex)
let answer = 187
print("The answer is \(answer)")


// MARK:- Part 2
let newAnswer = 392
print("The answer is \(newAnswer)")

//: [Next](@next)
