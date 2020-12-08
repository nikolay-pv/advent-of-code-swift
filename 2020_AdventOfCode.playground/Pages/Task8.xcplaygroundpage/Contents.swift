//: [Previous](@previous)

import Foundation

class Program {

    var accumulator = 0 // single global var
    var instructions: [Instruction]

    // part 1
    func runSingleCycle() -> Int {
        var evaluated = Set<Int>()
        var position = 0
        while !evaluated.contains(position) {
            evaluated.insert(position)
            instructions[position].evaluate(pos: &position, accumulator: &accumulator)
        }
        return accumulator
    }

    // part 2
    func run() -> Bool {
        var evaluated = Set<Int>()
        var position = 0
        while !evaluated.contains(position) {
            if (position >= instructions.count) {
                return true
            }
            evaluated.insert(position)
            instructions[position].evaluate(pos: &position, accumulator: &accumulator)
        }
        return false
    }

    func reset() {
        accumulator = 0
    }

    func searchFaultyInstruction() -> Int {
        let mutateIndexes = instructions.enumerated().compactMap{ $1.operation == .acc ? nil : $0 }.reversed()
        for idx in mutateIndexes {
            reset()
            instructions[idx].operation.toggle()
            if run() {
                break
            }
            instructions[idx].operation.toggle()
        }
        return accumulator
    }

    init<StringLike: StringProtocol>(with instructions: [StringLike]) {
        self.instructions = instructions.map{ Instruction(from: $0) }
    }

    struct Instruction {
        var operation: Operation
        var argument: Int

        func evaluate(pos: inout Int, accumulator: inout Int) {
            switch operation {
            case .nop: pos += 1
            case .jmp: pos += argument
            case .acc:
                pos += 1
                accumulator += argument
            }
        }

        enum Operation: String {
            case nop = "nop", acc = "acc", jmp = "jmp"
            mutating func toggle() {
                switch self {
                case .acc:
                    break
                case .nop:
                    self = .jmp
                case .jmp:
                    self = .nop
                }
            }
        }

        init<StringLike: StringProtocol>(from: StringLike) {
            let opArg = String(from).split(separator: " ")
            guard let op = Operation(rawValue: String(opArg.first ?? "")),
                  let argStr = opArg.last,
                  let arg = Int(argStr) else {
                fatalError()
            }
            operation = op
            argument = arg
        }
    }
}

var input = getInput().split(separator: "\n")

// MARK:- Part 1
let prog = Program(with: input)
let answer = prog.runSingleCycle()
print("The answer is \(answer)")


// MARK:- Part 2
prog.reset()
let newAnswer = prog.searchFaultyInstruction()
print("The answer is \(newAnswer)")
assert(309430 > newAnswer)
assert(319 < newAnswer)


//: [Next](@next)
