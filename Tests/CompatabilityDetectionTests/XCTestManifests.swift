import XCTest

extension CompatabilityDetectionTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CompatabilityDetectionTests.__allTests),
    ]
}
#endif
