import Foundation
import Overture

func regex(_ pattern: String, _ options: NSRegularExpression.Options = []) throws -> NSRegularExpression {
    return try NSRegularExpression(pattern: pattern, options: options)
}

func ranges(of match: NSTextCheckingResult) -> [NSRange] {
    var groups = [NSRange]()
    groups.reserveCapacity(match.numberOfRanges)
    for index in 0..<match.numberOfRanges  {
        groups.append(match.range(at: index))
    }
    return groups
}

func matchingResults(of regex: NSRegularExpression) -> (String) throws -> [[String]] {
    return { string in
        let range = NSRange(location: 0, length: string.count)
        let matches = regex.matches(in: string, options: [], range: range)
        return matches.map(pipe(
            ranges(of:),
            compactMap(nsRange(from: string))
        )) as [[String]]
    }
}
