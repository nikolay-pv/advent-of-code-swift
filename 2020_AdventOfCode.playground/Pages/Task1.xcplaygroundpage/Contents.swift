import UIKit

var input = Set(getInput().split(separator: "\n").map{ Int($0)! })

// returns set with elements or nil otherwise
private func findPair(_ input: Set<Int>, withSum sum: Int) -> Set<Int>?{
    let differences = input.compactMap{ $0 > sum ? nil : sum - $0 }
    let intersection = input.intersection(differences)
    return intersection.count > 0 ? intersection : nil
}

// MARK:- Part 1
if let pair = findPair(input, withSum: 2020) {
    if (pair.count > 2) {
        print("There are more than one variant!")
    }
    let answer = pair.first! * (2020 - pair.first!)
    assert(answer == 1006875)
    print("The answer for the first part is \(answer)")
}

// MARK:- Part 2
let sumsOfTwo = input.compactMap{ $0 > 2020 ? nil : 2020 - $0 }
for sum in sumsOfTwo {
    if let pair = findPair(input, withSum: sum) {
        if (pair.count > 2) {
            print("There are more than one variant for part 2!")
        }
        let answer = pair.first! * (sum - pair.first!) * (2020 - sum)
        print("The answer for the second is \(answer)")
        break
    }
}
