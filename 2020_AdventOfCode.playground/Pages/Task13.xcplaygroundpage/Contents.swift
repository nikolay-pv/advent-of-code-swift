//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: "\n")

// MARK:- Part 1
let earliestTime = Int(input.first!)!
let buses = input.last!.split(separator: ",").filter{ $0 != "x" }.compactMap{ Int($0) }
var fastestDeparture = (bus: Int.max, waiting: Int.max)
buses.forEach{ bus in
    let waitingTime = bus - earliestTime % bus
    if waitingTime < fastestDeparture.waiting {
        fastestDeparture.bus = bus
        fastestDeparture.waiting = waitingTime
    }
}
let answer = fastestDeparture.bus * fastestDeparture.waiting
print("The answer is \(answer)")


// MARK:- Part 2
var busWaitingTimes = input.last!.split(separator: ",").enumerated().compactMap{ i, id -> (bus: Int, remainder: Int)? in
    if id == "x" {
        return nil
    }
    return (bus: Int(id)!, remainder: i)
}
print(busWaitingTimes.map { "-\($0.remainder % $0.bus) mod \($0.bus)" }.joined(separator: "\n"))
print("Use available solutions: https://www.dcode.fr/chinese-remainder")


//: [Next](@next)
