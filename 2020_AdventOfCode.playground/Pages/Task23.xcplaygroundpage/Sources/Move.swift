import Foundation

public final class Game {
    public private(set) var cups = [Int]()
    public private(set) var ringCount: Int
    public private(set) var entryPoint: Int

    public func printFirst(_ numberOfCups: Int = 8) -> String {
        var nextOne = cups[1]
        var res = ""
        while nextOne != 1 || res.count != numberOfCups {
            res.append("\(nextOne)")
            nextOne = cups[nextOne]
        }
        return res
    }

    public func getTwoFollowingOne() -> (Int, Int) {
        let nextOne = cups[1]
        let nextNextOne = cups[nextOne]
        return (nextOne, nextNextOne)
    }

    public func play(roundsCount: Int) {
        var current = entryPoint
        for _ in 1...roundsCount {
            current = move(current: current)
        }
    }

    private func move(current: Int) -> Int {
        let firstToMoveValue = cups[current]
        let middleToMoveValue = cups[firstToMoveValue]
        let lastToMoveValue = cups[middleToMoveValue]
        // get destination
        var destination = current
        while [firstToMoveValue, middleToMoveValue, lastToMoveValue].contains(destination)
                || destination == current {
            destination -= 1
            if destination == 0 {
                destination = ringCount
            }
        }
        // repoint the current
        let newCurrent = cups[lastToMoveValue]
        cups[current] = newCurrent
        // move the range
        cups[lastToMoveValue] = cups[destination]
        cups[destination] = firstToMoveValue
        return newCurrent
    }

    public init(_ input: [Int], gameSize: Int = 9) {
        // forward linked list
        var result = Array(1...(gameSize + 1)) // index = label, stored Value = pointing index
        result[0] = 0 // add padding for easier handling
        // fill in input
        for (position, value) in input.dropLast().enumerated() {
            result[value] = input[position + 1]
        }
        // make a ring
        if gameSize > input.count {
            result[input.last!] = input.count + 1
            result[result.endIndex - 1] = input.first!
        } else {
            result[input.last!] = input.first!
        }
        cups = result
        ringCount = gameSize
        entryPoint = input.first!
    }
}
