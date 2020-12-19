import Foundation

// Returns the content of the input.txt file from the Resources folder
public func getInput(_ filename: String = "input") -> String {
    guard let inputFile = Bundle.main.path(forResource: filename, ofType: "txt"),
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

extension NSRegularExpression {
    public convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }

    public func matchingGroups(in string: String) -> [Range<String.Index>] {
        let matches = self.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
        var res = [Range<String.Index>]()
        if matches.count == 0 {
            return res
        }
        let entireGroup = matches[0]
        for i in 1..<entireGroup.numberOfRanges {
            guard let range = Range(entireGroup.range(at: i), in: string) else {
                fatalError()
            }
            res.append(range)
        }
        return res
    }
}
