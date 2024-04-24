import SwiftUI

public extension CGPoint {
  
  /// Returns a new point located at an offset from the current point
  func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
    CGPoint(x: x + dx, y: y + dy)
  }
  
  /// Calculates the offset for the current point as if it were at the center of a circle, with a given magnitude and angle.
  func offset(magnitude: Double, angle: Angle) -> CGPoint {
    let dx = magnitude * cos(angle.radians)
    let dy = magnitude * sin(angle.radians)
    return CGPoint(x: x + dx, y: y + dy)
  }
  
  /// Calculates the distance between the current point and the given point.
  func distance(to point: CGPoint) -> Double {
    let dx = x - point.x
    let dy = y - point.y
    return sqrt(dx * dx + dy * dy)
  }
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

/// Multiplies the components of the CGPoint by a factor
/// - Parameters:
///   - lhs: the CGPoint
///   - rhs: the factor
/// - Returns: a scaled CGPoint
public func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
  CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}
