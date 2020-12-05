//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: "\n").map{
    $0.map{ c -> String in
        switch c {
        case "L", "F":
            return "0"
        case "R", "B":
            return "1"
        default:
            fatalError()
        }
    }.joined(separator: "")
}

let boardingsIDs = input.map { binary -> Int in
    let row = Int(String(binary.dropLast(3)), radix: 2)!
    let column = Int(String(binary.dropFirst(7)), radix: 2)!
    return row * 8 + column
}


// MARK:- Part 1
let highestTicketID = boardingsIDs.max()!
// wrong submissions
assert(1035 > highestTicketID)
print("The highest ticked ID is \(highestTicketID)")
assert(926 == highestTicketID)


// MARK:- Part 2
// arithmetic progression
let idealSum = (boardingsIDs.min()! + boardingsIDs.max()!) * (boardingsIDs.count + 1) / 2
let searchID = idealSum - boardingsIDs.reduce(0, +)
print("The Santa's boarding pass ID is \(searchID)")


//: [Next](@next)
