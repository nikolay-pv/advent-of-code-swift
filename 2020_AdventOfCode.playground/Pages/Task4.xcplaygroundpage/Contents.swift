//: [Previous](@previous)

import Foundation

// added ; instead of empty lines - faster
var input = getInput().split(separator: ";").map{ $0.replacingOccurrences(of: " ", with: "\n").split(separator: "\n") }


// MARK:- Part 1
let requiredFields : Set<String.SubSequence> = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
let numberOfValidPassports = input.map{ (record) -> Int in
    let recordFields = Set(record.map { field in
        field.split(separator: ":").first!
    })
    let missingFields = requiredFields.subtracting(recordFields)
    if (missingFields.count == 1) {
        // cid is optional
        return missingFields.first! == "cid" ? 1 : 0
    }
    if (missingFields.count > 0) {
        return 0 // invalid
    }
    return 1 // valid
}.reduce(0, +)
// wrong submissions
assert(251 != numberOfValidPassports)
assert(210 > numberOfValidPassports)
print("The answer is \(numberOfValidPassports)")


// MARK:- Part 2
struct Passport {
    var byr: Int?
    var isByrValid: Bool {
        byr != nil && byr! >= 1920 && byr! <= 2002
    }

    var iyr: Int?
    var isIyrValid: Bool {
        iyr != nil && iyr! >= 2010 && iyr! <= 2020
    }

    var eyr: Int?
    var isEyrValid: Bool {
        eyr != nil && eyr! >= 2020 && eyr! <= 2030
    }

    var hgt: (Int, Unit)?
    var isHgtValid: Bool {
        guard let hgt = hgt else {
            return false
        }
        switch hgt.1 {
        case .cm:
            return 150 <= hgt.0 && hgt.0 <= 193
        case .inches:
            return 59 <= hgt.0 && hgt.0 <= 76
        }
    }

    var hcl: String?
    var isHclValid: Bool {
        guard let hcl = hcl else {
            return false
        }
        return hcl.count == 7 && hcl.starts(with: "#") && Int(hcl.dropFirst(), radix: 16) != nil
    }

    var ecl: EyeColor?
    var isEclValid: Bool { ecl != nil }

    var pid: String?
    var isPidValid: Bool {
        guard let pid = pid else {
            return false
        }
        return pid.count == 9 && Int(pid) != nil
    }

    var cid: String? // not required

    var isValid: Bool {
        isByrValid && isIyrValid && isEyrValid && isHgtValid && isHclValid && isEclValid && isPidValid
    }

    enum Unit: String {
        case cm="cm", inches="in"
    }
    enum EyeColor: String {
        case amb = "amb", blu = "blu", brn = "brn", gry = "gry", grn = "grn", hzl = "hzl", oth = "oth"
    }
    enum Fields: String {
        case byr = "byr", iyr = "iyr", eyr = "eyr", hgt = "hgt", hcl = "hcl", ecl = "ecl", pid = "pid", cid = "cid"
    }

    init(record: [String.SubSequence]) {
        for pair in record {
            let keyVal = pair.split(separator: ":")
            guard let field = Fields(rawValue: String(keyVal.first ?? "")),
                  let value = keyVal.last,
                  keyVal.count == 2 else {
                print("Can't find keyValue in the record!")
                continue
            }
            switch field {
            case .byr: byr = Int(value)
            case .iyr: iyr = Int(value)
            case .eyr: eyr = Int(value)
            case .hgt:
                guard let height = Int(value.dropLast(2)),
                      let unit = Unit(rawValue: String(value.dropFirst(value.count - 2))) else {
                    continue
                }
                hgt = (height, unit)
            case .hcl: hcl = String(value)
            case .ecl: ecl = EyeColor(rawValue: String(value))
            case .pid: pid = String(value)
            case .cid: cid = String(value)
            }
        }
    }
}

let newAnswer = input.map{ Passport(record: $0).isValid ? 1 : 0}.reduce(0, +)
print(newAnswer)
assert(13 != newAnswer)
assert(109 == newAnswer)
print("The answer is \(newAnswer)")


//: [Next](@next)
