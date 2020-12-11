import Foundation

public final class SeatingSystem: CustomStringConvertible {
    public var description: String {
        seatMap.map{ $0.map{ t in t.description }.joined(separator: "") }.joined(separator: "\n")
    }

    public var occupiedSeatsCount: Int {
        seatMap.map{row in row.filter{ $0.occupied }.count }.reduce(0, +)
    }

    public func runSimulation() {
        for sim in 1...1000 { // 1000 iterations should suffice
            let oldSeatMap = seatMap
            var changed = false
            for c in 0..<cols {
                for r in 0..<rows {
                    let oldSeat = oldSeatMap[r][c]
                    if oldSeat.type == .floor {
                        continue
                    }
                    let neighboursCount = getNeighbours(row: r, col: c).filter{ oldSeatMap[$0.0][$0.1].occupied }.count
                    if !oldSeat.occupied && neighboursCount == 0 {
                        seatMap[r][c].occupy()
                        changed = true
                    } else if (oldSeat.occupied && neighboursCount >= tolerance) {
                        seatMap[r][c].vacate()
                        changed = true
                    }
                }
            }
//            print(self, terminator: "\n\n\n")
            if !changed {
                print("Total # of simulations \(sim)")
                break
            }
        }
    }

    public init<StringLike: StringProtocol>(input: [StringLike], neighbourTolerance: Int, for part: AOCPart) {
        seatMap = input.map{ $0.map{c in Tile(type: c == "L" ? .seat : .floor) } }
        rows = seatMap.count
        cols = seatMap.first!.count
        tolerance = neighbourTolerance
        neighboursMap = Array(repeating: Array(repeating: [(Int, Int)](), count: cols), count: rows)
        for r in 0..<rows {
            for c in 0..<cols {
                neighboursMap[r][c] = (part == .part1) ? computeNeighbours(row: r, col: c) : computeNeighbours2(row: r, col: c)
            }
        }
    }

    public enum AOCPart {
        case part1, part2
    }

    private var seatMap: [[Tile]]
    private var neighboursMap: [[[(Int, Int)]]]
    private let tolerance: Int
    private let rows: Int
    private let cols: Int

    private func getNeighbours(row: Int, col: Int) -> [(Int, Int)] {
        return neighboursMap[row][col]
    }

    private func computeNeighbours(row: Int, col: Int) -> [(Int, Int)] {
        let indexes = [(row - 1, col), (row + 1, col), (row, col - 1), (row, col + 1),
                       (row - 1, col + 1), (row - 1, col - 1), (row + 1, col - 1), (row + 1, col + 1)]
        return indexes.filter{ $0.0 >= 0 && $0.1 >= 0 && $0.0 < rows && $0.1 < cols}
    }

    private func computeNeighbours2(row: Int, col: Int) -> [(Int, Int)] {
        let increments = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, 1), (-1, -1), (1, -1), (1, 1)]
        var indexes = [(Int, Int)]()
        for increment in increments {
            var pos = (row + increment.0, col + increment.1)
            while (pos.0 >= 0 && pos.1 >= 0 && pos.0 < rows && pos.1 < cols) {
                if seatMap[pos.0][pos.1].type == .seat {
                    indexes.append(pos)
                    break
                }
                pos = (pos.0 + increment.0, pos.1 + increment.1)
            }
        }
        return indexes
    }

    private struct Tile: CustomStringConvertible {
        let type: Kind
        var occupied = false

        mutating func occupy() {
            guard type == .seat else {
                return
            }
            occupied = true
        }
        mutating func vacate() { occupied = false }

        enum Kind: String {
            case seat = "L", floor = "."
        }

        public var description: String {
            switch type {
            case .floor: return "."
            case .seat: return occupied ? "#" : "L"
            }
        }
    }
}
