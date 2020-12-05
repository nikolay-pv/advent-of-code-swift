import UIKit


enum Brace : Int {
    case left = 1, right = -1, other = 0

    init(_ char: Character) {
        switch char {
        case "(":
            self = .left
            break
        case ")":
            self = .right
            break
        default:
            self = .other
            break
        }
    }
}

// MARK:- Part 1
let inputFile = getInput()
print(inputFile.reduce(0, { $0 + Brace($1).rawValue }))

// MARK:- Part 2
var floor = 0
var pos = inputFile.firstIndex {
    floor += Brace($0).rawValue
    return floor < 0
}
if let pos = pos {
    print(pos.utf16Offset(in: inputFile) + 1)
}
