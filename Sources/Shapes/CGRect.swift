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
}
