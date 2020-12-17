import Foundation

public struct Cube: Hashable {
    private var x: Int
    private var y: Int
    private var z: Int
    private var w: Int
    private static var zero = Cube(x: 0, y: 0, z: 0, w: 0)

    public init(x: Int, y: Int, z: Int, w: Int = 0) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    public var neighbours: [Cube] {
        Cube.enableForth
            ? Cube.neighbours4D.map{ $0.offsetting(x: x, y: y, z: z, w: w) }
            : Cube.neighbours3D.map{ $0.offsetting(x: x, y: y, z: z) }
    }

    private func offsetting(x: Int, y: Int, z: Int, w: Int = 0) -> Cube {
        Cube(x: self.x + x, y: self.y + y, z: self.z + z, w: self.w + w)
    }

    public static var enableForth: Bool = false
    private static let neighbours3D: Set<Cube> = {
        createNeighbours(for: .threeD)
    }()
    private static let neighbours4D: Set<Cube> = {
        createNeighbours(for: .fourD)
    }()
    private static func createNeighbours(for dim: Dimensionality = .threeD) -> Set<Cube>{
        var neighbours = Set<Cube>()
        let ws = dim == .fourD ? [-1, 0, 1] : [0]
        for _x in [-1, 0, 1] {
            for _y in [-1, 0, 1] {
                for _z in [-1, 0, 1] {
                    for _w in ws {
                        let c = Cube(x: _x, y: _y, z: _z, w: _w)
                        if c != Cube.zero {
                            neighbours.insert(c)
                        }
                    }
                }
            }
        }
        return neighbours
    }

    enum Dimensionality {
        case threeD, fourD
    }
}

public func hasEnoughActive(for cube: Cube, in cubes: [Cube: Bool], with exactThresholds: [Int]) -> Bool {
    var count = 0
    for adjacent in cube.neighbours {
        guard let active = cubes[adjacent] else {
            continue
        }
        count += active ? 1 : 0
    }
    return exactThresholds.contains(count)
}

public func liveCycle(cubes: [Cube: Bool]) -> [Cube: Bool] {
    var queue = cubes.keys.flatMap{ $0.neighbours }
    queue.append(contentsOf: cubes.keys)
    var nextCycle = [Cube: Bool]()
    for cube in Set(queue) {
        if cubes.keys.contains(cube) && cubes[cube]! && hasEnoughActive(for: cube, in: cubes, with: [2, 3]) {
            nextCycle[cube] = true
        } else if !cubes.keys.contains(cube) && hasEnoughActive(for: cube, in: cubes, with: [3]) {
            nextCycle[cube] = true
        }
    }
    return nextCycle
}
