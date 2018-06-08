import XCTest

extension CompatabilityDetectionTests {
    static let __allTests = [
        ("testEmptyDiffHasEmptySummary", testEmptyDiffHasEmptySummary),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CompatabilityDetectionTests.__allTests),
    ]
}
#endif
