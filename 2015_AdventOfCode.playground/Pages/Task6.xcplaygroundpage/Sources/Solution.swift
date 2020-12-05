import Foundation

public struct Command {

    var left : (x: Int, y: Int) = (0, 0)
    var right : (x: Int, y: Int) = (0, 0)
    var action : Action

    enum Action {
        case On, Off, Toggle
    }

    func isInRange(x: Int, y: Int) -> Bool {
        x >= left.x && y >= left.y && x <= right.x && y <= right.y
    }
    func isNotInRange(x: Int, y: Int) -> Bool {
        x < left.x || y < left.y || x > right.x || y > right.y
    }

    // turn on 887,9 through 959,629
    public init(line: String.SubSequence) {
        if line.starts(with: "turn on") {
            action = .On
        } else if (line.starts(with: "turn off")) {
            action = .Off
        } else /*if (line.starts(with: "toggle"))*/ {
            action = .Toggle
        }
        guard let regex = try? NSRegularExpression(pattern: "(\\d+),(\\d+) through (\\d+),(\\d+)"),
              let match = regex.firstMatch(in: String(line), options: [], range: NSRange(location: 0, length: line.utf16.count))
        else {
            return
        }

        guard let leftX = Int(line[Range(match.range(at: 1), in: line)!]),
              let leftY = Int(line[Range(match.range(at: 2), in: line)!]),
              let rightX = Int(line[Range(match.range(at: 3), in: line)!]),
              let rightY = Int(line[Range(match.range(at: 4), in: line)!])
        else {
            return
        }
        left = (leftX, leftY)
        right = (rightX, rightY)
    }
}

fileprivate let squareSize = 1000

public func countLitLamps(for input: [Command]) -> Int {
    var litNumber = 0
    for i in 0..<squareSize*squareSize {
        let x = i / squareSize
        let y = i % squareSize
        var isLit = false
        for cmd in input {
            if (cmd.isNotInRange(x: x, y: y)) {
                continue
            }
            switch cmd.action {
            case .On: isLit = true
            case .Off: isLit = false
            case .Toggle: isLit.toggle()
            }
        }
        if (isLit) {
            litNumber += 1
        }
    }
    return litNumber
}

// part 2
public func computeBrightness(for input: [Command]) -> Int {
    var brightness = 0
    for i in 0..<squareSize*squareSize {
        let x = i / squareSize
        let y = i % squareSize
        var lampBrightness = 0
        for cmd in input {
            if (cmd.isNotInRange(x: x, y: y)) {
                continue
            }
            switch cmd.action {
            case .On: lampBrightness += 1
            case .Off:
                if (lampBrightness > 0) {
                    lampBrightness = (lampBrightness - 1)
                }
            case .Toggle: lampBrightness += 2
            }
        }
        brightness += lampBrightness
    }
    return brightness
}
