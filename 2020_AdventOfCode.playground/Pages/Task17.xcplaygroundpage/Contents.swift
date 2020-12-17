//: [Previous](@previous)

import Foundation

var input = getInput().split(separator: "\n")

// MARK:- Part 1
var cubesState = [Cube: Bool]()
for (row, cubes) in input.enumerated() {
    for (column, cube) in cubes.enumerated() {
        if cube == "#" {
            let c = Cube(x: column, y: row, z: 0)
            cubesState[c] = true
        }
    }
}
Cube.enableForth = false
var cubesIn3D = cubesState
for _ in 1...6 {
    cubesIn3D = liveCycle(cubes: cubesIn3D)
}
let answer = cubesIn3D.values.filter{ $0 }.count
print("The answer is \(answer)")


// MARK:- Part 2
Cube.enableForth = true
var cubesIn4D = cubesState
for _ in 1...6 {
    cubesIn4D = liveCycle(cubes: cubesIn4D)
}
let newAnswer = cubesIn4D.values.filter{ $0 }.count
print("The answer is \(newAnswer)")


//: [Next](@next)
