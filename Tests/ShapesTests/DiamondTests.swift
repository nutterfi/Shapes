import XCTest
@testable import Shapes

final class DiamondTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
      XCTAssertEqual(Diamond(pointRatio: 0.25).pointRatio, 0.25)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
