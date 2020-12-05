//: [Previous](@previous)

import Foundation

struct Point : Comparable, Hashable, AdditiveArithmetic {
    static var zero: Point = Point(x: 0, y: 0)

    static func + (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func - (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    static func < (lhs: Point, rhs: Point) -> Bool {
        lhs.x < rhs.x || (lhs.x == rhs.x && lhs.y < rhs.y)
    }

    var x: Int // right
    var y: Int // up

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    init?(_ direction: Direction?) {
        guard let direction = direction else {
            return nil
        }
        switch direction {
        case .north:
            x = 0
            y = 1
        case .south:
            x = 0
            y = -1
        case .east:
            x = 1
            y = 0
        case .west:
            x = -1
            y = 0
        }
    }

    enum Direction : Character {
        case north = "^", south = "v", east = ">", west = "<"
    }
}

var input = getInput().map{ Point(Point.Direction(rawValue: $0)) }

// MARK:- Part 1
var last = Point.zero
let houses = [Point.zero] + input.compactMap{ element in
    guard let element = element else {
        return nil
    }
    last += element
    return last
}
let visitedHouses = Set(houses).count
assert(visitedHouses != 10) // wrong submission
print("Total number of houses visited: \(visitedHouses)")

// MARK:- Part 2
var santaPos = Point.zero
var digiSantaPos = Point.zero
var isRealSanta = true
let teamWorkHouses = [Point.zero] + input.compactMap{ element in
    guard let element = element else {
        return nil
    }
    if (isRealSanta) {
        santaPos += element
    } else {
        digiSantaPos += element
    }
    defer {
        isRealSanta.toggle()
    }
    return isRealSanta ? santaPos : digiSantaPos
}
let teamVisitedHouses = Set(teamWorkHouses).count
print("Total number of houses visited: \(teamVisitedHouses)")

//: [Next](@next)
