//: [Previous](@previous)

import Foundation

struct Requirement {
    static let regex = NSRegularExpression("^(\\w+\\s*\\w*): (\\d+)-(\\d+) or (\\d+)-(\\d+)$")

    public func validate(value: Int) -> Bool {
        requirements.contains{ $0.min <= value && value <= $0.max }
    }

    public init(_ string: String) {
        let matches = Requirement.regex.matchingGroups(in: string)
        if matches.count != 5 {
            fatalError()
        }
        name = String(string[matches.first!])
        requirements.append((min: Int(string[matches[1]])!, max: Int(string[matches[2]])!))
        requirements.append((min: Int(string[matches[3]])!, max: Int(string[matches[4]])!))
    }
    private(set) var name: String
    private(set) var requirements = [(min: Int, max: Int)]()
}


var input = getInput().split(separator: ";")

var requirements = input.first!.split(separator: "\n").map{ Requirement(String($0)) }
var myTicket = input[1].split(separator: "\n").last!.split(separator: ",").map{ Int($0)! }
var others = input.last!.split(separator: "\n").dropFirst().map{ $0.split(separator: ",").map{ Int($0)! } }

// MARK:- Part 1
var allFields = others.flatMap{ $0 }
let invalidNumbers = allFields.compactMap{ field in
    requirements.allSatisfy{ !$0.validate(value: field) } ? field : nil
}
let answer = invalidNumbers.reduce(0, +)
print("The answer is \(answer)")


// MARK:- Part 2
var othersValid = others.filter{ ticket in
    ticket.allSatisfy { [requirements] field in
        requirements.contains{ $0.validate(value: field) }
    }
}
othersValid.append(myTicket)
// collect all possible values per field
var fieldValues = Array(repeating: Set<Int>(), count: myTicket.count)
for ticket in othersValid {
    for (i, val) in ticket.enumerated() {
        fieldValues[i].insert(val)
    }
}

// collect all possible field names per field
var fieldNames = myTicket.enumerated().reduce(into: [Int: [String]]()) { (res, e) in
    res[e.offset] = [String]()
}
for (i, vals) in fieldValues.enumerated() {
    for req in requirements {
        if vals.allSatisfy({ req.validate(value: $0) }) {
            fieldNames[i]!.append(req.name)
        }
    }
}

// eliminate those about which we are sure
var sortedFieldNames = fieldNames.sorted{
    $0.value.count < $1.value.count
}
var remove = [String]()
let resoledFieldNames = sortedFieldNames.map{ (key, values) -> (Dictionary<Int, [String]>.Element) in
    if values.count == 1 {
        remove.append(values.first!)
        return (key, values)
    } else {
        let newVals = values.filter{ !remove.contains($0) }
        if newVals.count == 1 {
            remove.append(newVals.first!)
        }
        return (key, newVals)
    }
}

// compute the requested value
resoledFieldNames.forEach { print("\($0.key): \($0.value)") }
let newAnswer = resoledFieldNames.compactMap { ($1.count == 1 && $1.first!.contains("departure")) ? myTicket[$0] : nil }
    .reduce(1, *)
print("The answer is \(newAnswer)")

//: [Next](@next)
