import SwiftUI

public extension CGRect {
  /// The minimum point in both x and y dimensions
  var minXY: CGPoint {
    CGPoint(x: minX, y: minY)
  }
  
  /// The middle point in both x and y dimensions
  var midXY: CGPoint {
    CGPoint(x: midX, y: midY)
  }
  
  /// The maximum point in both x and y dimensions
  var maxXY: CGPoint {
    CGPoint(x: maxX, y: maxY)
  }
  
  /// The shorter side of the standardized version of the rectangle
  var breadth: CGFloat {
    min(width, height)
  }
  
  /// The longer side of the standardized version of the rectangle
  var length: CGFloat {
    max(width, height)
  }
  
  /// The rectangle's aspect ratio
  var aspectRatio: CGFloat {
    width / height
  }
  
  /// converts the input UnitPoint to a scaled CGPoint based on the associated CGRect
  /// - Parameters:
  ///   - point: the relative point with respect to the rectangle
  ///   - boundToFrame: whether the result should stay within the bounds of the rectangle
  /// - Returns: the scaled point
  func projectedPoint(_ point: UnitPoint, boundToFrame: Bool = false) -> CGPoint {
    let x = boundToFrame ? max(0, min(1, point.x)) : point.x
    let y = boundToFrame ? max(0, min(1, point.y)) : point.y
    return CGPoint(x: minX + x * width, y: minY + y * height)
  }
  
  /// constructs an array of `CGRect` instances in a 2D grid fashion that fit inside the original rectangle
  func subdivide(rows: Double, columns: Double) -> [CGRect] {
    var rects = [CGRect]()
    let dx = width / Double(columns)
    let dy = height / Double(rows)
    let size = CGSize(width: dx, height: dy)
    
    for row in 0..<Int(rows) {
      for column in 0..<Int(columns) {
        let origin = CGPoint(
          x: minX + CGFloat(column) * dx,
          y: minY + CGFloat(row) * dy
        )
        let item = CGRect(origin: origin, size: size)
        
        rects.append(item)
      }
    }
    return rects
  }
  
  /// Adjusts a rectangle by the given edge insets.
  /// - Parameter insets: The amount of inset to apply to each rectangle edge
  /// - Returns: A new rectangle, inset by the specified amount.
  ///
  /// The rectangle is standardized and then the inset parameters are applied. If the resulting rectangle would have a negative height or width, a null rectangle is returned.
  func inset(by insets: EdgeInsets) -> CGRect {
    
    let standard = self.standardized
    let newWidth = standard.width - insets.leading - insets.trailing
    let newHeight = standard.height - insets.top - insets.bottom
    
    if newWidth < 0 || newHeight < 0 {
      return .null
    }
    
    let newOrigin = standard.origin.offsetBy(dx: insets.leading, dy: insets.top)
    let newSize = CGSize(width: newWidth, height: newHeight)
    
    return CGRect(origin: newOrigin, size: newSize)
  }
  
  /// Creates a rectangle with square dimensions at the zero origin
  static func square(_ size: CGFloat) -> CGRect {
    CGRect(origin: .zero, size: CGSize(width: size, height: size))
  }
  
  /// Creates a rectangle with square dimensions at the provided origin
  static func square(origin: CGPoint, size: CGFloat) -> CGRect {
    CGRect(origin: origin, size: CGSize(width: size, height: size))
  }
  
  /// Creates a rectangle with square dimensions at the provided origin
  static func square(center: CGPoint, size: CGFloat) -> CGRect {
    CGRect(center: center, size: CGSize(width: size, height: size))
  }
  
  /// Creates a rectangle with the specified center point and size
  init(center: CGPoint, size: CGSize) {
    let origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
    self.init(origin: origin, size: size)
  }
}
