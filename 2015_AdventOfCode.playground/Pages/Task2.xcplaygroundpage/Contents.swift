//: [Previous](@previous)

import Foundation

struct Box {
    var l : Int
    var w : Int
    var h : Int

    func surfaceAreaWithExtra() -> Int {
        var sidesSurface = [l * w, w * h, h * l]
        sidesSurface.sort()
        // The extra equals the smallest surface area
        let scalers = [3, 2, 2]
        return zip(sidesSurface, scalers).map{ $0 * $1 }.reduce(0, +)
    }

    func ribbonLength() -> Int {
        var sidesPerimeter = [2 * (l + w), 2 * (w + h), 2 * (h + l)]
        sidesPerimeter.sort()
        // the needed amount of ribbon for the bow is box' volume
        let bow = l * w * h
        return sidesPerimeter[0] + bow
    }

    init(l: Int, w: Int, h: Int) {
        self.l = l
        self.w = w
        self.h = h
    }

    // takes in a string in form of l x w x h
    init?<Stringlike: StringProtocol>(from: Stringlike) {
        let rawInput = from.split(separator: "x")
        if (rawInput.count == 0) {
            return nil
        }
        let dims = rawInput.map { Int($0) }
        if (dims.firstIndex(of: nil) != nil) {
            return nil
        }
        l = dims[0]!
        w = dims[1]!
        h = dims[2]!
    }
}
assert(Box(l: 1, w: 1, h: 1).surfaceAreaWithExtra() == 7)
assert(Box(from: "1x1x1")!.surfaceAreaWithExtra() == 7)
assert(Box(from: "1x1x1")!.ribbonLength() == 5)


let input = getInput().split(separator: "\n").map( { Box(from: $0) } )

// MARK:- Part 1
var totalArea = input.map { $0?.surfaceAreaWithExtra() ?? 0 }.reduce(0, +)
print(totalArea)

// MARK:- Part 2
var totalRibbon = input.map { $0?.ribbonLength() ?? 0 }.reduce(0, +)
print(totalRibbon)


//: [Next](@next)
