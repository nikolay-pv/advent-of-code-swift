//: [Previous](@previous)

import Foundation

let cardPublicKey = 11404017
let doorPublicKey = 13768789
let subject = 7
let device = SecureDevice(seed: 20201227)

// MARK:- Part 1
let cardLoopSize = device.reverseTransform(publicKey: cardPublicKey, subject: subject)
let doorLoopSize = device.reverseTransform(publicKey: doorPublicKey, subject: subject)
print("Card's loop size: \(cardLoopSize)")
print("Door's loop size: \(doorLoopSize)")
print("Card encrypts key into: \(device.transform(subject: doorPublicKey, loopSize: cardLoopSize))")
print("Door encrypts key into: \(device.transform(subject: cardPublicKey, loopSize: doorLoopSize))")

//: [Next](@next)
