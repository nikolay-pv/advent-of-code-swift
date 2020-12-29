//: [Previous](@previous)

import Foundation

func computeChances(ingredientsKeys: Set<String>,
                    allergenKeys: Set<String>,
                    input: [([String], [String])])-> [String: [String: Double]] {
    // calculate the probabilities or each ingredient to have an allergen
    var ingredientAllergenAllChances = [String: [String: [Double]]]()
    for ingredient in ingredientsKeys {
        ingredientAllergenAllChances[ingredient] = [String: [Double]]()
        for allergen in allergenKeys {
            ingredientAllergenAllChances[ingredient]![allergen] = []
        }
    }
    for (ingredients, allergens) in input {
        let eligibleIngredients = ingredientsKeys.intersection(ingredients)
        let chance = Double(eligibleIngredients.count - allergens.count) / Double(eligibleIngredients.count)
        for ingredient in eligibleIngredients {
            for allergen in allergens {
                ingredientAllergenAllChances[ingredient]![allergen]!.append(chance)
            }
        }
    }

    // calculate the probability for the ingredient have an allergen given the number of recipes
    var ingredientAllergenTable = [String: [String: Double]]()
    for ingredient in ingredientsKeys {
        ingredientAllergenTable[ingredient] = [String: Double]()
        for allergen in allergenKeys {
            let chances = ingredientAllergenAllChances[ingredient]![allergen]!
            let probability = chances.map{ $0 * Double(chances.count) / Double(allergenCount[allergen]!) }.reduce(0.0, +)
            ingredientAllergenTable[ingredient]![allergen] = probability
        }
    }
    return ingredientAllergenTable
}


var input = getInput().split(separator: "\n").map{ food -> ([String], [String]) in
    let recipe = String(food).trimmingCharacters(in: [")"]).split(separator: "(")
    let foods = recipe.first!.split(separator: " ").map{ String($0) }
    let diary = recipe.last?.replacingOccurrences(of: "contains", with: "").split(separator: ",").map{ String($0).trimmingCharacters(in: [" "]) } ?? []
    return (foods, diary)
}

// MARK:- Part 1
var ingredientCount = [String: Int]()
var allergenCount = [String: Int]()
input.forEach{ (ingredients, allergens) in
    for ingredient in ingredients {
        ingredientCount[ingredient] = (ingredientCount[ingredient] ?? 0) + 1
    }
    for allergen in allergens {
        allergenCount[allergen] = (allergenCount[allergen] ?? 0) + 1
    }
}

let ingredients = Set(ingredientCount.keys)
let allergens = Set(allergenCount.keys)
var ingredientAllergenTable = computeChances(ingredientsKeys: ingredients, allergenKeys: allergens, input: input)

func getSafeIngredients(table: [String: [String: Double]]) -> [String] {
// get the maximum per allergen
    let ingredients = table.keys
    let allergens = table[ingredients.first!]!.keys
    var maximums = [String: Double]()
    for allergen in allergens {
        maximums[allergen] = 0.0
        for ingredient in ingredients {
            maximums[allergen] = max(maximums[allergen]!, table[ingredient]![allergen]!)
        }
    }
    var safeIngredients = [String]()
    for ingredient in ingredients {
        if allergens.allSatisfy({ maximums[$0]! > table[ingredient]![$0]! }) {
            safeIngredients.append(ingredient)
        }
    }
    return safeIngredients
}
let goodIngredients = getSafeIngredients(table: ingredientAllergenTable)

let answer = goodIngredients.map{ ingredientCount[$0]! }.reduce(0, +)
print("The answer is \(answer)")
assert(2770 < answer)
assert(3122 > answer)

// MARK:- Part 2
func resolve(table: [String: [String: Double]]) -> [String: String] {
    // get the maximum per allergen
    let ingredients = table.keys
    let allergens = table[ingredients.first!]!.keys
    var maximums = [String: Double]()
    for allergen in allergens {
        maximums[allergen] = 0.0
        for ingredient in ingredients {
            maximums[allergen] = max(maximums[allergen]!, table[ingredient]![allergen]!)
        }
    }
    var allergenIngredient = [String: [String]]()
    for allergen in allergens {
        allergenIngredient[allergen] = []
        for ingredient in ingredients {
            if maximums[allergen] == table[ingredient]![allergen]! {
                allergenIngredient[allergen]!.append(ingredient)
            }
        }
    }

    func cleanUp(ingredient: String) -> Void{
        for allergen in allergens {
            if allergenIngredient[allergen]!.count == 1 {
                continue
            }
            allergenIngredient[allergen] = allergenIngredient[allergen]!.filter{ $0 != ingredient }
            if allergenIngredient[allergen]!.count == 1 {
                cleanUp(ingredient: allergenIngredient[allergen]!.first!)
            }
        }
    }
    let keys = allergens.sorted(by: { allergenIngredient[$0]!.count > allergenIngredient[$1]!.count })
    for allergen in keys {
        if allergenIngredient[allergen]!.count == 1 {
            let ingredient = allergenIngredient[allergen]!.first!
            cleanUp(ingredient: ingredient)
        }
    }
    var newAllergenIngredient = [String: String]()
    allergenIngredient.forEach{
        assert($1.count == 1)
        newAllergenIngredient[$0] = $1.first!
    }
    return newAllergenIngredient
}

var shortenedIngredients = ingredients
shortenedIngredients.subtract(goodIngredients)

var newIngredientAllergenTable = computeChances(ingredientsKeys: shortenedIngredients, allergenKeys: allergens, input: input)
let allergenIngredient = resolve(table: newIngredientAllergenTable)
print(allergenIngredient)

var newAnswer = [String]()
for allergen in allergenIngredient.keys.sorted() {
    newAnswer.append(allergenIngredient[allergen]!)
}
print("The answer is \(newAnswer.joined(separator: ","))")

//: [Next](@next)
