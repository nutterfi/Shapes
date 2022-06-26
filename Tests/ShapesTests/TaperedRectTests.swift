import XCTest
@testable import Shapes

final class TaperedRectTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TaperedRectangle(taper: 5).taper, 5)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
