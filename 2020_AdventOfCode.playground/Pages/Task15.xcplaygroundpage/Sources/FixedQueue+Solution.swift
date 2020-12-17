import Foundation

public class FixedQueue<T> {
    typealias Element = T
    public func enqueue(_ element: T) {
        storage.append(element)
        cutHead()
    }

    private func cutHead() {
        if storage.count > maxSize {
            storage.removeFirst(storage.count - maxSize)
        }
    }
    private var storage = [T]()
    private var maxSize: Int

    public var count: Int { storage.count }
    public var last: T? { storage.last }
    public var first: T? { storage.first }

    init(withSize size: Int, content: [T] = [T]())
    {
        maxSize = size
        if content.count != 0 {
            storage = content
            cutHead()
        }
    }
}

public func runGame(input: [Int], forIterations: Int) -> Int {
    var ages = [Int: FixedQueue<Int>]()
    input.enumerated().forEach {
        ages[$1] = FixedQueue(withSize: 2, content: [$0])
    }
    var lastSpoken = input.last!
    for turn in input.count...(forIterations-1) { // start from 0!
        if ages.keys.contains(lastSpoken) && ages[lastSpoken]!.count == 2 {
            let lastSpokenTurns = ages[lastSpoken]!
            lastSpoken = lastSpokenTurns.last! - lastSpokenTurns.first!
        } else {
            lastSpoken = 0
        }
        if !ages.keys.contains(lastSpoken) {
            ages[lastSpoken] = FixedQueue(withSize: 2, content: [turn])
        } else {
            ages[lastSpoken]!.enqueue(turn)
        }
    }
    return lastSpoken
}
