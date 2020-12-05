import Foundation

// Returns the content of the input.txt file from the Resources folder
public func getInput() -> String {
    guard let inputFile = Bundle.main.path(forResource: "input", ofType: "txt"),
          let contentData = FileManager.default.contents(atPath: inputFile) else {
        return String()
    }
    return String(data: contentData.dropLast(), encoding: .ascii) ?? String()
}

extension StringProtocol {

    public subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    public func substring(fromIndex: Int) -> String {
        return self[Swift.min(fromIndex, count) ..< count]
    }

    public func substring(toIndex: Int) -> String {
        return self[0 ..< Swift.max(0, toIndex)]
    }

    public subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: Swift.max(0, Swift.min(count, r.lowerBound)),
                                            upper: Swift.min(count, Swift.max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
