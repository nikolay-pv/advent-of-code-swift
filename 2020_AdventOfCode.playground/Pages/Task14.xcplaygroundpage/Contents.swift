//: [Previous](@previous)

import Foundation

extension String {
    init(_ num: Int, radix: Int, inSize: Int) {
        let s = String(num, radix: radix)
        self = s.count < inSize ? String(repeating: "0", count: inSize - s.count) + s : s
    }
}

func applyMask(_ value: Int, mask: String) -> Int {
    var valueStr = String(Int(value), radix: 2, inSize: 36)
    valueStr = valueStr.enumerated().map { (i, char) in
        if mask[i] == "X" {
            return String(char)
        }
        return mask[i]
    }.joined()
    return Int(valueStr, radix: 2)!
}

var input = getInput().split(separator: "\n")

// MARK:- Part 1
let memRegex = NSRegularExpression("^mem\\[(\\d+)\\] = (\\d+)$")
var memory = [Int: Int]()
var mask = ""
input.forEach{ instruction in
    if instruction.starts(with: "mask") {
        mask = String(instruction.split(separator: " ").last!)
    } else {
        let mem = String(instruction)
        let groups = memRegex.matchingGroups(in: mem)
        assert(groups.count == 2)
        guard let loc = Int(mem[groups[0]]), let value = Int(mem[groups[1]]) else {
            fatalError()
        }
        memory[loc] = applyMask(value, mask: mask)
    }
}
let answer = memory.values.reduce(0, +)
print("The answer is \(answer)")


// MARK:- Part 2
func generateAddress<Container: Collection>(_ start: Int, powersOfTwo: Container) -> [Int]
    where Container.Element == Int
{
    guard powersOfTwo.count != 0 else {
        return [start]
    }
    let power = powersOfTwo.first!
    let increment = Int(pow(2.0, Double(power)))
    let others = powersOfTwo.dropFirst()
    return generateAddress(start, powersOfTwo: others) + generateAddress(start + increment, powersOfTwo: others)
}

func getAddresses(_ value: Int, mask: String) -> [Int] {
    var valueStr = String(Int(value), radix: 2, inSize: 36)
    var xs = [Int]()
    valueStr = valueStr.enumerated().map { (i, char) in
        if mask[i] == "X" {
            xs.append(valueStr.count - i - 1)
            return "0"
        }
        return (mask[i] == "1") ? "1" : String(char)
    }.joined()
    return generateAddress(Int(valueStr, radix: 2)!, powersOfTwo: xs)
}

//print(getAddresses(42, mask: "000000000000000000000000000000X1001X"))
//print(getAddresses(26, mask: "00000000000000000000000000000000X0XX"))

var memory2 = [Int: Int]()
var mask2 = ""
input.forEach{ instruction in
    if instruction.starts(with: "mask") {
        mask2 = String(instruction.split(separator: " ").last!)
    } else {
        let mem = String(instruction)
        let groups = memRegex.matchingGroups(in: mem)
        assert(groups.count == 2)
        guard let loc = Int(mem[groups[0]]), let value = Int(mem[groups[1]]) else {
            fatalError()
        }
        Set(getAddresses(loc, mask: mask2)).forEach{
            memory2[$0] = value
        }
    }
}

let newAnswer = memory2.values.reduce(0, +)
print("The answer is \(newAnswer)")
assert(4180503649478 < newAnswer)

//: [Next](@next)
