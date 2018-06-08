import XCTest
@testable import CompatabilityDetection

final class CompatabilityDetectionTests: XCTestCase {
    func testEmptyDiffHasEmptySummary() throws {
        Current = .mockEmptyDiff
        let additions = try compatabilityTestAdditionsForUrl("https://my.valid.url/diff")
        XCTAssertEqual(additions, [])
    }
}
