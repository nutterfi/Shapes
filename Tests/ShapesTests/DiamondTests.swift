import XCTest
@testable import Shapes

final class DiamondTests: XCTestCase {
  
  /// WISH LIST
  // TODO: How can I use a rect in Shape for scaling normalized CGPoints?
//  protocol NFiShape: Shape {
//    func scaledPoint(_ point: CGPoint) -> CGPoint
//  }
//  
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
