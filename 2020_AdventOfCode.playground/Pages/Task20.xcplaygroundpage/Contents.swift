//: [Previous](@previous)

import Foundation

public struct Tile: Hashable {
    var id: Int
    var edges: [Edge] { Array(allEdges.values) }
    var edgeHashes: [Int] { allEdges.values.map{ $0.hashValue } }
    private var allEdges: [Side: Edge]
    var centralPart: [String]

    enum Side {
        case top, bottom, left, right
        // rotates counter-clockwise
        func next() -> Side {
            switch self {
            case .top: return .left
            case .bottom: return .right
            case .left: return .bottom
            case .right: return .top
            }
        }
        func opposed() -> Side {
            switch self {
            case .top: return .bottom
            case .bottom: return .top
            case .left: return .right
            case .right: return .left
            }
        }
    }

    public struct Edge: Hashable {
        private var original: String
        public var value: Int

        // takes the stringlike of type #.#. as input
        public init<StringLike: StringProtocol>(_ edge: StringLike) {
            original = String(edge).replacingOccurrences(of: ".", with: "0").replacingOccurrences(of: "#", with: "1")
            value = Int(original, radix: 2)!
        }

        mutating public func mirror() {
            original = String(original.reversed())
            value = Int(original, radix: 2)!
        }

        // Hashable
        // indexes the # from the middle of the string, negative to the left and positive to the right
        // returns the hash of the array of hashes of the above arrayed indices and the mirrored version of it
        // such hash is the same for strings read left to right and right to left
        public func hash(into hasher: inout Hasher) {
            let halfLen = original.count / 2
            let middle = original.index(original.startIndex, offsetBy: halfLen)
            var indexes = [Int]()
            indexes.append(contentsOf: original[..<middle].enumerated().compactMap{
                return $1 == "1" ? $0 - halfLen : nil
            })
            indexes.append(contentsOf: original[middle...].enumerated().compactMap{
                return $1 == "1" ? $0 + 1 : nil
            })
            let inverse = indexes.reversed().map{ $0 * -1 }
            let hashes = [indexes.hashValue, inverse.hashValue].sorted()
            hasher.combine(hashes.first!)
            hasher.combine(hashes.last!)
        }
    }

    init<StringLike: StringProtocol>(_ tile: StringLike) {
        var lines = tile.split(separator: "\n")
        let idLine = lines.removeFirst()
        self.id = Int(String(idLine.trimmingCharacters(in: [":"]).split(separator: " ").last!))!
        var edges = [Side: Edge]()
        edges[.top] = Edge(lines.first!)
        edges[.bottom] = Edge(lines.last!)
        // read from bottom to top
        edges[.right] = Edge(lines.reversed().map{ String($0.last!) }.joined())
        edges[.left] = Edge(lines.reversed().map{ String($0.first!) }.joined())
        self.allEdges = edges
        // use the bottom one to show boundaries
        self.centralPart = lines[1..<(lines.count - 1)].map{ String($0[1..<($0.count - 1)]) } as [String]
//        self.centralPart = lines.map{ String($0) }
    }
}

let input = getInput().split(separator: ";").map{ Tile($0) }

// MARK:- Part 1
var edgeCount = [Int: Int]()
for tile in input {
    for e in tile.edgeHashes {
        edgeCount[e] = (edgeCount[e] ?? 0) + 1
    }
}
let uniqueEdges = Set(edgeCount.filter{ $1 == 1 }.keys)
var corners = [Tile]()
for tile in input {
    if uniqueEdges.intersection(tile.edgeHashes).count == 2 {
        corners.append(tile)
        if corners.count == 4 {
            break
        }
    }
}
print(Set(corners.map{$0.id}))
let answer = Set(corners.map{ $0.id }).reduce(1, *)
print("The answer is \(answer)")
assert(104831106565027 == answer)


// MARK:- Part 2
extension Tile {
    public enum Transformation {
        case flipHorizontal, flipVertical, rotate // counter-clockwise
    }

    static public func transform(_ picture: [String], by transformation: Tile.Transformation) -> [String] {
        switch transformation {
        case .flipHorizontal:
            return picture.reversed()
        case .flipVertical:
            return picture.map{ String($0.reversed()) }
        case .rotate:
            var rotated = [String]()
            for i in (0..<picture.first!.count).reversed() {
                rotated.append( picture.map{ $0[i] }.joined() )
            }
            return rotated
        }
    }

    public func transformed(_ transformation: Transformation) -> Tile {
        switch transformation {
        case .flipHorizontal:
            var edges = self.allEdges
            let top = edges[.top]
            edges[.top] = edges[.bottom]
            edges[.bottom] = top
            edges[.left]!.mirror()
            edges[.right]!.mirror()
            var res = self
            res.allEdges = edges
            res.centralPart = Tile.transform(centralPart, by: transformation)
            return res
        case .flipVertical:
            var edges = self.allEdges
            let left = edges[.left]
            edges[.left] = edges[.right]
            edges[.right] = left
            edges[.top]!.mirror()
            edges[.bottom]!.mirror()
            var res = self
            res.allEdges = edges
            res.centralPart = Tile.transform(centralPart, by: transformation)
            return res
        case .rotate:
            var edges = self.allEdges
            for side in allEdges.keys {
                let newSide = side.next()
                edges[newSide] = allEdges[side]
                if newSide == .top || newSide == .bottom {
                    edges[newSide]!.mirror()
                }
            }
            var res = self
            res.allEdges = edges
            res.centralPart = Tile.transform(centralPart, by: transformation)
            return res
        }
    }

    mutating func transforming(_ transformation: Transformation) {
        self = transformed(transformation)
    }

    func getSide(for hash: Int) -> Side? {
        for (s, e) in allEdges {
            if e.hashValue == hash {
                return s
            }
        }
        return nil
    }

    func matching(other: Tile, on: Side) -> Bool {
        return allEdges[on]!.value == other.allEdges[on.opposed()]!.value
    }

    var sideLen: Int { centralPart.count }
}

struct Puzzle {
    var tiles = [Tile]()
    var positions = [Position]()
    var assembledPuzzle = [String]()

    init(_ tiles: [Tile], corners: [Tile]) {
        catalogEdges(tiles)
        solvePuzzle(tiles, corners: corners)
        assemble()
    }

    func search(seaMonster: [String]) -> Int {
        print("Searching...")
        var monstersCount = 0
        let seaMonsterHeight = seaMonster.count
        let maxRow = assembledPuzzle.count - seaMonsterHeight
        let seaMonsterLen = seaMonster.first!.count
        let maxCol = assembledPuzzle.first!.count - seaMonsterLen
        for verticalStride in 0...maxRow {
            let rows = assembledPuzzle[verticalStride..<(verticalStride + seaMonsterHeight)]
            hor: for horizontalStride in 0...maxCol {
    //            rows.enumerated().forEach({ print($1[horizontalStride..<(horizontalStride + seaMonsterLen)], seaMonster[$0]) })
                for (i, row) in rows.enumerated() {
                    let zoneOfInterest = row[horizontalStride..<(horizontalStride + seaMonsterLen)]
                    if !zip(zoneOfInterest, seaMonster[i]).allSatisfy({ $1 == " " || $1 == $0 }) {
                        continue hor
                    }
                }
                monstersCount += 1
            }
        }
        print("Found \(monstersCount)")
        return monstersCount
    }

    public func display() {
        assembledPuzzle.forEach{ print($0) }
    }

    public func count(character: Character = "#") -> Int {
        assembledPuzzle.joined().filter{ $0 == character }.count
    }

    private var hashToIndex = [Int: [Int]]()
    private mutating func catalogEdges(_ tiles: [Tile]) {
        for (i, tile) in tiles.enumerated() {
            for e in tile.edgeHashes {
                if hashToIndex.keys.contains(e) {
                    hashToIndex[e]!.append(i)
                } else {
                    hashToIndex[e] = [i]
                }
            }
        }
    }

    private mutating func solvePuzzle(_ tiles: [Tile], corners: [Tile]) {
        var puzzle = Array<Tile?>(repeating: nil, count: input.count)
        let lastPlacedTile = corners[0]
        let lastPlacedIdx = input.firstIndex(of: lastPlacedTile)!
        puzzle[lastPlacedIdx] = lastPlacedTile
        var shouldMatchedEdges = Set(edgeCount.filter{ $1 == 2 }.keys)
        var unmatchedEdges = Array(shouldMatchedEdges.intersection(lastPlacedTile.edgeHashes))

        var positions = Array<Position?>(repeating: nil, count: input.count)
        positions[lastPlacedIdx] = Position.zero

        while unmatchedEdges.count != 0 {
            let edge = unmatchedEdges.removeFirst()
            shouldMatchedEdges.remove(edge)
            let indices = hashToIndex[edge]!
            assert(indices.count == 2)
            var index = indices.first!
            var placedIndex = indices.last!
            if puzzle[index] != nil && puzzle[placedIndex] != nil {
                continue
            }
            if puzzle[index] != nil {
                assert(puzzle[placedIndex] == nil)
                Swift.swap(&index, &placedIndex)
            }
            // place
            var toBePlaced = input[index]
            let lastPlacedTile = puzzle[placedIndex]!
            let side = lastPlacedTile.getSide(for: edge)!
            var otherSide = toBePlaced.getSide(for: edge)!
            while otherSide != side.opposed() {
                toBePlaced.transforming(.rotate)
                otherSide = toBePlaced.getSide(for: edge)!
        //        print("Rotating the tile \(toBePlaced.id)")
            }
            if !lastPlacedTile.matching(other: toBePlaced, on: side) {
                switch side {
                case .left, .right:
                    toBePlaced.transforming(.flipHorizontal)
                case .top, .bottom:
                    toBePlaced.transforming(.flipVertical)
                }
        //        print("Flipping the tile \(toBePlaced.id)")
            }
            var lastPlacedPos = positions[placedIndex]!
            switch side {
            case .left, .right:
                lastPlacedPos.col += (side == .left ? -1 : 1)
            case .top, .bottom:
                lastPlacedPos.row += (side == .top ? -1 : 1)

            }
            puzzle[index] = toBePlaced
            positions[index] = lastPlacedPos
        //    print("Placed \(toBePlaced.id) at \(lastPlacedPos.row) \(lastPlacedPos.col)")
            unmatchedEdges.append(contentsOf: shouldMatchedEdges.intersection(toBePlaced.edgeHashes))
        }
        self.tiles = puzzle.compactMap{ $0 }
        self.positions = positions.compactMap{ $0 }
        assert(self.tiles.count == puzzle.count)
        assert(self.positions.count == positions.count)
    }

    private mutating func assemble() {
        let minCol = positions.compactMap{ $0.col }.min()!
        let minRow = positions.compactMap{ $0.row }.min()!
        let origin = Position(row: minRow, col: minCol)
        // use the bottom one to show boundaries
        let squareLen = input.first!.sideLen
        // let squareLen = input.first!.sideLen + 1
        let puzzleSize = Int(sqrt(Double(input.count)))
        var wholePuzzle = Array(repeating: String(repeating: " ", count: squareLen * puzzleSize), count: squareLen * puzzleSize)
        for i in 0..<tiles.count {
            let pos = positions[i] - origin
            let tile = tiles[i]
            let startRow = pos.row * squareLen
            let startCol = pos.col * squareLen
            for (localRow, line) in tile.centralPart.enumerated() {
                let row = startRow + localRow
                var oldRow = wholePuzzle[row]
                let range = String.Index.init(utf16Offset: startCol, in: oldRow)..<String.Index.init(utf16Offset: (startCol + line.count), in: oldRow)
                oldRow.replaceSubrange(range, with: line)
                wholePuzzle[row] = oldRow
            }
        }
        self.assembledPuzzle = wholePuzzle
    }

    struct Position: Hashable {
        var row: Int
        var col: Int
        static let zero = Position(row: 0, col: 0)

        static func +(lhs: Position, rhs: Position) -> Position {
            return Position(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
        }
        static func -(lhs: Position, rhs: Position) -> Position {
            return Position(row: lhs.row - rhs.row, col: lhs.col - rhs.col)
        }
    }
}

let seaMonster = ["                  # ",
                  "#    ##    ##    ###",
                  " #  #  #  #  #  #   "]

let puzzle = Puzzle(input, corners: corners)
puzzle.display()

var transformations = [[Tile.Transformation.rotate],
                       [Tile.Transformation.rotate, Tile.Transformation.rotate],
                       [Tile.Transformation.rotate, Tile.Transformation.rotate, Tile.Transformation.rotate],
                       [Tile.Transformation.flipVertical],
                       [Tile.Transformation.flipHorizontal],
                       [Tile.Transformation.flipVertical, Tile.Transformation.flipHorizontal],
                       []]

var monstersCount = 0
var monsterPattern = seaMonster
while monstersCount == 0 && transformations.count != 0 {
    monstersCount = puzzle.search(seaMonster: monsterPattern)
    print("Transform monster")
    monsterPattern = seaMonster
    for tr in transformations.removeFirst() {
        monsterPattern = Tile.transform(monsterPattern, by: tr)
    }
}

let seaMonsterPower = seaMonster.joined().filter({ $0 == "#" }).count
let newAnswer = puzzle.count() - monstersCount * seaMonsterPower
print("The answer is \(newAnswer)")
assert(2093 == newAnswer)

//: [Next](@next)
