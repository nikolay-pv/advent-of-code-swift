import Foundation
import SwiftUI


public struct HexPoint: Hashable, CustomStringConvertible{
    public static let zero = HexPoint(x: 0, y: 0, z: 0)
    public var x: Int
    public var y: Int
    public var z: Int

    static public func *(left: HexPoint, right: Int) -> HexPoint {
        return HexPoint(x: left.x * right, y: left.y * right, z: left.z * right)
    }
    static public func +(left: HexPoint, right: HexPoint) -> HexPoint {
        return HexPoint(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }
    public var description: String {
        "[\(x), \(y), \(z)]"
    }

    public var neighbours: Set<HexPoint> {
        Set(HexPoint.Direction.allCases.map{ self + $0.getVector() })
    }

    public enum Direction: String, CaseIterable, Comparable, Hashable, CustomStringConvertible {
        public var description: String { rawValue }
        static public func < (lhs: Direction, rhs: Direction) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        case east = "e", southeast = "se", southwest = "sw", west = "w", northwest = "nw", northeast = "ne"

        public func opposite() -> Direction {
            switch self {
            case .east:      return Direction.west
            case .southeast: return Direction.northwest
            case .southwest: return Direction.northeast
            case .west:      return Direction.east
            case .northwest: return Direction.southeast
            case .northeast: return Direction.southwest
            }
        }

        public func getVector() -> HexPoint {
            return Self.points[self]!
        }
        private static let points: [Direction: HexPoint] = {
            [Direction.east:     HexPoint(x: 1, y: -1, z: 0),
            Direction.southwest: HexPoint(x: -1, y: 0, z: 1),
            Direction.southeast: HexPoint(x: 0, y: -1, z: 1),
            Direction.west:      HexPoint(x: -1, y: 1, z: 0),
            Direction.northwest: HexPoint(x: 0, y: 1, z: -1),
            Direction.northeast: HexPoint(x: 1, y: 0, z: -1)]
        }()

        public static let defaultDict: [HexPoint.Direction: Int] = {
            var d = [Direction: Int]()
            Direction.allCases.forEach{ d[$0] = 0 }
            return d
        }()
    }
}

public func tokenise(_ input: String) -> [String] {
    let regex = NSRegularExpression("((e|se|sw|w|nw|ne))")
    return regex.matches(in: input, range: .init(location: 0, length: input.count)).map{ String(input[Range($0.range)!]) }
}

public func removeRedundant(_ dict: [HexPoint.Direction: Int]) -> [HexPoint.Direction: Int] {
    var res = dict
    for direction in HexPoint.Direction.allCases {
        let unused = min(res[direction]!, res[direction.opposite()]!)
        res[direction]! -= unused
        res[direction.opposite()]! -= unused
    }
    return res
}

public func simulate(_ input: Set<HexPoint>, for days: Int) -> [Int]{
    var simulation = [Int]()
    var floor = input
    for _ in 1...days {
        let flipToWhite = Set(floor.compactMap{ tile -> HexPoint? in
                                let count = tile.neighbours.intersection(floor).count
                                return count == 0 || count > 2 ? tile : nil
        })
        let neighbourWhite = Set(floor.flatMap{ $0.neighbours.subtracting(floor) })
        let flipToBlack = Set(neighbourWhite.compactMap{ $0.neighbours.intersection(floor).count == 2 ? $0 : nil } )
        floor.subtract(flipToWhite)
        floor.formUnion(flipToBlack)
        simulation.append(floor.count)
    }
    return simulation
}
