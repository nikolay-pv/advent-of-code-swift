//: [Previous](@previous)

import Foundation
import SwiftUI


enum Direction: Character {
    case north = "N", south = "S", east = "E", west = "W", left = "L", right = "R", forward = "F"
}

var input = getInput().split(separator: "\n").map{ (Direction(rawValue: $0.first!)!, Int($0.dropFirst())!) }

// MARK:- Part 1
class Ship {
    var position = (0, 0)
    var distanceToOrigin : Int { abs(position.0) + abs(position.1) }
    var direction = Angle.zero // the angles to the east direction

    func process(dir: Direction, value: Int) {
        if dir == .left || dir == .right {
            turn(dir: dir, angle: value)
        } else {
            move(dir: dir, value: value)
        }
    }

    func move(dir: Direction, value: Int) {
        switch dir {
        case .forward:
            position.0 += Int(Double(value) * cos(direction.radians))
            position.1 += Int(Double(value) * sin(direction.radians))
        case .north: position.1 += value
        case .south: position.1 -= value
        case .east: position.0 += value
        case .west: position.0 -= value
        default: fatalError()
        }
//        print("moved to \(position)")
    }

    func turn(dir: Direction, angle: Int) {
        switch dir {
        case .left: direction.degrees += Double(angle)
        case .right: direction.degrees -= Double(angle)
        default: fatalError()
        }
//        print("turned to \(direction.degrees)")
    }
}
//let ship = Ship()
//input.forEach{ ship.process(dir: $0.0, value: $0.1) }
//print("The Manhattan distance to origin is \(ship.distanceToOrigin)")


// MARK:- Part 2
class ShipWithWaypoint {
    var position = (0, 0)
    var waypoint = (10, 1) // relative to position
    var distanceToOrigin : Int { abs(position.0) + abs(position.1) }

    func process(dir: Direction, value: Int) {
        if dir == .left || dir == .right {
            turn(dir: dir, angle: Angle(degrees: Double(value)))
        } else {
            move(dir: dir, value: value)
        }
    }

    func move(dir: Direction, value: Int) {
        switch dir {
        case .forward:
            position.0 += waypoint.0 * value
            position.1 += waypoint.1 * value
        case .north: waypoint.1 += value
        case .south: waypoint.1 -= value
        case .east: waypoint.0 += value
        case .west: waypoint.0 -= value
        default: fatalError()
        }
    }

    func turn(dir: Direction, angle: Angle) {
        let vec = (Double(waypoint.0), Double(waypoint.1))
        let rad = angle.radians
        switch dir {
        case .left:
            waypoint.0 = Int(cos(rad) * vec.0) - Int(sin(rad) * vec.1)
            waypoint.1 = Int(sin(rad) * vec.0) + Int(cos(rad) * vec.1)
        case .right:
            waypoint.0 = Int(cos(rad) * vec.0) + Int(sin(rad) * vec.1)
            waypoint.1 = Int(-sin(rad) * vec.0) + Int(cos(rad) * vec.1)
        default: fatalError()
        }
    }
}

let shipW = ShipWithWaypoint()
input.forEach{ shipW.process(dir: $0.0, value: $0.1) }
print("The Manhattan distance to origin is \(shipW.distanceToOrigin)")
assert(21869 < shipW.distanceToOrigin)
assert(22852 > shipW.distanceToOrigin)


//: [Next](@next)
