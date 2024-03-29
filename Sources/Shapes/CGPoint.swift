import CoreGraphics

public extension CGPoint {
  func offsetBy(x: CGFloat, y: CGFloat) -> CGPoint {
    CGPoint(x: self.x + x, y: self.y + y)
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
