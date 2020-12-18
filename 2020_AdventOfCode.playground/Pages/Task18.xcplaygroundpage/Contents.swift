//: [Previous](@previous)

import Foundation

enum Operation: String {
    case plus = "+", minus = "-", multiply = "*"
    func perform(lhs: Int, rhs: Int) -> Int {
        switch self {
        case .plus:
            return lhs + rhs
        case .minus:
            return lhs - rhs
        case .multiply:
            return lhs * rhs
        }
    }
}

enum Precedence {
    case identical, sumFirst

    // checks precedence of the last (on a stack) element compared to new
    func check(last: String, new: String) -> Int {
        switch self {
        case .identical:
            return 0 // all operations the same
        case .sumFirst:
            switch last {
            case "+":
                return "-*".contains(new) ? 1 : 0
            case "-", "*":
                return new == "+" ? -1 : 0
            default:
                fatalError()
            }
        }
    }
}

// Shunting yard simplified
func convertToRPN(_ equation: [String], with precedence: Precedence) -> [String] {
    var output = [String]()
    var operators = [String]()
    for el in equation {
        switch el {
        case "+", "-", "*":
            if let last = operators.last, "+-*".contains(last), precedence.check(last: last, new: el) >= 0 {
                output.append(operators.popLast()!)
            }
            operators.append(el)
        case "(":
            operators.append(el)
        case ")":
            while operators.last! != "(" {
                output.append(operators.popLast()!)
            }
            operators.popLast() // discard parentesis
        default:
            output.append(el)
        }
    }
    while operators.count > 0 {
        output.append(operators.popLast()!)
    }
    return output
}

func evaluate(_ equation: [String], with precedence: Precedence = .identical) -> Int {
    let rpn = convertToRPN(equation, with: precedence)
    var digits = [Int]()
    for el in rpn {
        if "+-*".contains(el) {
            let operation = Operation(rawValue: el)!
            let rhs = digits.popLast()!
            let lhs = digits.popLast()!
            digits.append(operation.perform(lhs: lhs, rhs: rhs))
        } else {
            digits.append(Int(el)!)
        }
    }
    assert(digits.count == 1)
    return digits.first!
}

func tokenise<StringLike: StringProtocol>(_ string: StringLike) -> [String] {
    let input = string.split(separator: " ")
    let tokens = input.flatMap{ token -> [String] in
        if token.starts(with: "(") {
            let res = [token.trimmingCharacters(in: ["("])]
            return Array(repeating: "(", count: token.count - res.first!.count) + res
        } else if token.last == ")" {
            let res = [token.trimmingCharacters(in: [")"])]
            return res + Array(repeating: ")", count: token.count - res.first!.count)
        } else {
            return [String(token)]
        }
    }
    return tokens
}


var input = getInput().split(separator: "\n").map{ tokenise($0) }

// MARK:- Part 1
let answer = input.map { evaluate($0) }.reduce(0, +)
print("The answer is \(answer)")


// MARK:- Part 2
let newAnswer = input.map { evaluate($0, with: .sumFirst) }.reduce(0, +)
print("The answer is \(newAnswer)")


//: [Next](@next)
