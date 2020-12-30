import Foundation

public struct SecureDevice {
    public var seed = 20201227

    public func transform(subject: Int, loopSize: Int) -> Int {
        var publicKey = 1
        for _ in 1...loopSize {
            publicKey *= subject
            publicKey %= seed
        }
        return publicKey
    }

    public func reverseTransform(publicKey: Int, subject: Int) -> Int {
        var input = publicKey
        var loopSize = 0
        while input != 1 {
            while input % subject != 0 {
                input += seed
            }
            input /= subject
            loopSize += 1
        }
        return loopSize
    }
    public init(seed: Int) {
        self.seed = seed
    }
}
