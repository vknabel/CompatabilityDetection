import Foundation
import Overture

let rangeFromNSRangeForString = with(Range.init(_:in:), pipe(curry, flip))

func range(from string: String) -> (Range<String.Index>) -> String {
    return { String(string[$0]) }
}

func nsRange(from string: String) -> (NSRange) -> String? {
    return pipe(
        rangeFromNSRangeForString(string),
        map(range(from: string))
    )
}
